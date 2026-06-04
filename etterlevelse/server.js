const http = require("http");
const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

const PORT = 3333;
const BASE = __dirname;
const INPUT_DIR = path.join(BASE, "agent-input");
const OUTPUT_DIR = path.join(BASE, "agent-output");
const QA_FILE = path.join(BASE, "qa-status.json");

// --- Helpers ---

function readJson(filepath, fallback) {
  try { return JSON.parse(fs.readFileSync(filepath, "utf-8")); }
  catch { return fallback; }
}

function writeJson(filepath, data) {
  fs.writeFileSync(filepath, JSON.stringify(data, null, 2), "utf-8");
}

function parseInputFile(content) {
  const lines = content.split("\n");
  const titleMatch = lines[0]?.match(/^#\s*Hjelp meg å dokumentere:\s*(\S+)\s+(.+)/);
  if (!titleMatch) return null;

  const id = titleMatch[1];
  const title = titleMatch[2];

  // Extract tema
  let tema = "";
  const temaLine = lines.find(l => /^Tema:\s*/.test(l));
  if (temaLine) tema = temaLine.replace(/^Tema:\s*/, "").trim();

  // Extract hensikt
  let hensikt = "";
  const hensiktIdx = lines.findIndex(l => l.startsWith("## Hensikten med kravet"));
  const oppgaveIdx = lines.findIndex(l => l.startsWith("## Oppgave til AI"));
  if (hensiktIdx >= 0 && oppgaveIdx >= 0) {
    hensikt = lines.slice(hensiktIdx + 1, oppgaveIdx).join("\n").trim();
  }

  // Extract criteria
  const criteria = [];
  const criteriaRegex = /^Suksesskriterium (\d+) av (\d+)/;
  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(criteriaRegex);
    if (m) {
      const num = parseInt(m[1]);
      const criterionTitle = lines[i + 1]?.trim() || "";
      // Find "Utfyllende om kriteriet" section
      let description = "";
      if (i + 3 < lines.length && lines[i + 2]?.trim() === "" && lines[i + 3]?.startsWith("Utfyllende om kriteriet")) {
        const descStart = i + 4;
        const descLines = [];
        for (let j = descStart; j < lines.length; j++) {
          if (lines[j].match(criteriaRegex) || lines[j].startsWith("## ")) break;
          descLines.push(lines[j]);
        }
        description = descLines.join("\n").trim();
      }
      criteria.push({ num, title: criterionTitle, description });
    }
  }

  return { id, title, tema, hensikt, criteria };
}

function getOutputFiles(kravId) {
  if (!fs.existsSync(OUTPUT_DIR)) return {};
  const files = fs.readdirSync(OUTPUT_DIR).filter(f => f.startsWith(kravId + "-"));
  const result = {};
  for (const f of files) {
    const content = fs.readFileSync(path.join(OUTPUT_DIR, f), "utf-8");
    const mtime = fs.statSync(path.join(OUTPUT_DIR, f)).mtimeMs;
    const m = f.match(/suksesskriterium(\d+)/);
    if (m) result[parseInt(m[1])] = { filename: f, content, mtime };
  }
  return result;
}

function checkAndResetStaleQa(kravId, criteria) {
  const qa = readJson(QA_FILE, {});
  let changed = false;
  for (const c of criteria) {
    const key = kravId + "-" + c.num;
    const entry = qa[key];
    if (!entry || !entry.done) continue;
    // If the file was modified after QA was marked, reset QA
    if (c.mtime && entry.qaAt && c.mtime > entry.qaAt) {
      entry.done = false;
      entry.stale = true;
      entry.staleReason = "Fil endret etter QA (" + new Date(c.mtime).toLocaleString("no-NO") + ")";
      changed = true;
    }
  }
  if (changed) writeJson(QA_FILE, qa);
  return qa;
}

const OPEN_QUESTIONS_FILE = path.join(BASE, "apne-sporsmal.md");

function parseOpenQuestions() {
  if (!fs.existsSync(OPEN_QUESTIONS_FILE)) return {};
  const content = fs.readFileSync(OPEN_QUESTIONS_FILE, "utf-8");
  const lines = content.split("\n");
  const result = {};
  let currentKrav = null;

  for (const line of lines) {
    // Match krav header: ## K267.1 – ...
    const kravMatch = line.match(/^##\s+(K\d+\.\d+)/);
    if (kravMatch) {
      currentKrav = kravMatch[1];
      result[currentKrav] = [];
      continue;
    }
    if (!currentKrav) continue;
    // Match question line: - [ ] **Topic:** Text. Owner. _Kommentar: ..._
    // or: - [x] **Topic:** Text. Owner.
    const qMatch = line.match(/^-\s*\[([ x])\]\s*\*\*([^*]+)\*\*:?\s*(.+)/);
    if (qMatch) {
      const done = qMatch[1] === "x";
      const topic = qMatch[2].trim();
      let rest = qMatch[3].trim();

      // Extract comment if present: _Kommentar: ..._
      let comment = "";
      const commentMatch = rest.match(/\s*_Kommentar:\s*(.+?)_\s*$/);
      if (commentMatch) {
        comment = commentMatch[1].trim();
        rest = rest.substring(0, rest.length - commentMatch[0].length).trim();
      }

      // Try to split text and owner (last sentence before trailing period)
      // Format: "Description text. Owner team." — owner is last sentence
      let text = rest;
      let owner = "";
      // Strip trailing period for analysis
      const stripped = rest.endsWith(".") ? rest.slice(0, -1).trim() : rest;
      const lastDot = stripped.lastIndexOf(".");
      if (lastDot > 0) {
        const candidate = stripped.substring(lastDot + 1).trim();
        // Heuristic: owner is typically short (< 60 chars), starts with uppercase or "team"
        if (candidate.length > 0 && candidate.length < 60) {
          text = stripped.substring(0, lastDot + 1).trim();
          owner = candidate;
        }
      }
      result[currentKrav].push({ topic, text, owner, done, comment });
    }
  }
  return result;
}

function toggleOpenQuestion(kravId, index, done) {
  if (!fs.existsSync(OPEN_QUESTIONS_FILE)) return;
  const content = fs.readFileSync(OPEN_QUESTIONS_FILE, "utf-8");
  const lines = content.split("\n");
  let currentKrav = null;
  let questionIdx = -1;

  for (let i = 0; i < lines.length; i++) {
    const kravMatch = lines[i].match(/^##\s+(K\d+\.\d+)/);
    if (kravMatch) {
      currentKrav = kravMatch[1];
      questionIdx = -1;
      continue;
    }
    if (currentKrav !== kravId) continue;
    const qMatch = lines[i].match(/^-\s*\[([ x])\]\s*/);
    if (qMatch) {
      questionIdx++;
      if (questionIdx === index) {
        const mark = done ? "x" : " ";
        lines[i] = lines[i].replace(/^-\s*\[([ x])\]/, `- [${mark}]`);
        break;
      }
    }
  }
  fs.writeFileSync(OPEN_QUESTIONS_FILE, lines.join("\n"), "utf-8");
}

function updateOpenQuestionComment(kravId, index, comment) {
  if (!fs.existsSync(OPEN_QUESTIONS_FILE)) return;
  const content = fs.readFileSync(OPEN_QUESTIONS_FILE, "utf-8");
  const lines = content.split("\n");
  let currentKrav = null;
  let questionIdx = -1;

  for (let i = 0; i < lines.length; i++) {
    const kravMatch = lines[i].match(/^##\s+(K\d+\.\d+)/);
    if (kravMatch) {
      currentKrav = kravMatch[1];
      questionIdx = -1;
      continue;
    }
    if (currentKrav !== kravId) continue;
    const qMatch = lines[i].match(/^-\s*\[([ x])\]\s*/);
    if (qMatch) {
      questionIdx++;
      if (questionIdx === index) {
        // Remove existing comment if any
        lines[i] = lines[i].replace(/\s*_Kommentar:\s*.+?_\s*$/, "");
        // Add new comment if non-empty
        if (comment && comment.trim()) {
          lines[i] = lines[i].trimEnd() + " _Kommentar: " + comment.trim() + "_";
        }
        break;
      }
    }
  }
  fs.writeFileSync(OPEN_QUESTIONS_FILE, lines.join("\n"), "utf-8");
}

function buildKravList() {
  if (!fs.existsSync(INPUT_DIR)) return [];
  const files = fs.readdirSync(INPUT_DIR).filter(f => f.endsWith(".txt"));
  const kravList = [];
  for (const f of files) {
    const content = fs.readFileSync(path.join(INPUT_DIR, f), "utf-8");
    const parsed = parseInputFile(content);
    if (!parsed) continue;
    const outputs = getOutputFiles(parsed.id);
    const criteria = parsed.criteria.map(c => ({
      ...c,
      answer: outputs[c.num]?.content || null,
      filename: outputs[c.num]?.filename || null,
      mtime: outputs[c.num]?.mtime || null
    }));
    // Check if any QA is stale due to file changes
    checkAndResetStaleQa(parsed.id, criteria);
    kravList.push({
      id: parsed.id,
      title: parsed.title,
      tema: parsed.tema || "",
      hensikt: parsed.hensikt,
      criteria
    });
  }
  return kravList.sort((a, b) => a.id.localeCompare(b.id));
}

// --- HTTP Server ---

function sendJson(res, data, status = 200) {
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(JSON.stringify(data));
}

function readBody(req) {
  return new Promise((resolve) => {
    let body = "";
    req.on("data", chunk => body += chunk);
    req.on("end", () => resolve(body));
  });
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);

  // CORS — restrict to same origin
  const origin = req.headers.origin || "";
  const allowedOrigin = `http://localhost:${PORT}`;
  if (origin === allowedOrigin) {
    res.setHeader("Access-Control-Allow-Origin", allowedOrigin);
  }
  res.setHeader("Access-Control-Allow-Methods", "GET, PUT, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  if (req.method === "OPTIONS") { res.writeHead(204); res.end(); return; }

  // API routes
  if (url.pathname === "/api/last-modified" && req.method === "GET") {
    // Returns max mtime across all output files + qa-status for efficient polling
    let maxMtime = 0;
    if (fs.existsSync(OUTPUT_DIR)) {
      for (const f of fs.readdirSync(OUTPUT_DIR)) {
        const mt = fs.statSync(path.join(OUTPUT_DIR, f)).mtimeMs;
        if (mt > maxMtime) maxMtime = mt;
      }
    }
    if (fs.existsSync(QA_FILE)) {
      const mt = fs.statSync(QA_FILE).mtimeMs;
      if (mt > maxMtime) maxMtime = mt;
    }
    if (fs.existsSync(OPEN_QUESTIONS_FILE)) {
      const mt = fs.statSync(OPEN_QUESTIONS_FILE).mtimeMs;
      if (mt > maxMtime) maxMtime = mt;
    }
    return sendJson(res, { lastModified: maxMtime });
  }

  if (url.pathname === "/api/krav" && req.method === "GET") {
    return sendJson(res, buildKravList());
  }

  if (url.pathname === "/api/open-questions" && req.method === "GET") {
    return sendJson(res, parseOpenQuestions());
  }

  if (url.pathname === "/api/open-questions" && req.method === "PUT") {
    const body = await readBody(req);
    const { kravId, index, done } = JSON.parse(body);
    toggleOpenQuestion(kravId, index, done);
    return sendJson(res, { ok: true });
  }

  if (url.pathname === "/api/open-questions/comment" && req.method === "PUT") {
    const body = await readBody(req);
    const { kravId, index, comment } = JSON.parse(body);
    updateOpenQuestionComment(kravId, index, comment);
    return sendJson(res, { ok: true });
  }

  if (url.pathname === "/api/qa-status" && req.method === "GET") {
    return sendJson(res, readJson(QA_FILE, {}));
  }

  if (url.pathname === "/api/qa-status" && req.method === "PUT") {
    const body = await readBody(req);
    writeJson(QA_FILE, JSON.parse(body));
    return sendJson(res, { ok: true });
  }

  if (url.pathname.startsWith("/api/output/") && req.method === "PUT") {
    const filename = decodeURIComponent(url.pathname.replace("/api/output/", ""));
    if (!filename || filename.includes("..") || filename.includes("/")) {
      return sendJson(res, { error: "Invalid filename" }, 400);
    }
    const body = await readBody(req);
    const { content } = JSON.parse(body);
    if (!fs.existsSync(OUTPUT_DIR)) fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    fs.writeFileSync(path.join(OUTPUT_DIR, filename), content, "utf-8");
    return sendJson(res, { ok: true, filename });
  }

  // --- Git operations (locked to etterlevelse/ folder) ---

  if (url.pathname === "/api/git/status" && req.method === "GET") {
    const repoRoot = path.resolve(BASE, "..");
    try {
      const raw = execFileSync("git", ["status", "--porcelain", "--", "etterlevelse/"], { cwd: repoRoot, encoding: "utf-8" });
      const files = raw.trim().split("\n").filter(Boolean).map(line => {
        const m = line.match(/^([ MADRCU?!]{1,2})\s(.+)$/);
        return m ? { status: m[1].trim(), file: m[2] } : { status: "?", file: line.trim() };
      });
      return sendJson(res, { files });
    } catch (e) {
      return sendJson(res, { error: e.message }, 500);
    }
  }

  if (url.pathname === "/api/git/pull" && req.method === "POST") {
    const repoRoot = path.resolve(BASE, "..");
    try {
      const branch = execFileSync("git", ["rev-parse", "--abbrev-ref", "HEAD"], { cwd: repoRoot, encoding: "utf-8" }).trim();
      const output = execFileSync("git", ["pull"], { cwd: repoRoot, encoding: "utf-8", timeout: 30000 });
      return sendJson(res, { ok: true, output: output.trim(), branch });
    } catch (e) {
      return sendJson(res, { error: e.stderr || e.message }, 500);
    }
  }

  if (url.pathname === "/api/git/push" && req.method === "POST") {
    const repoRoot = path.resolve(BASE, "..");
    const body = await readBody(req);
    const { files, message } = JSON.parse(body);

    // Validate: only allow files under etterlevelse/ with safe characters
    if (!files || !files.length) return sendJson(res, { error: "No files selected" }, 400);
    const safePathRegex = /^etterlevelse\/[\w.\-\/]+$/;
    const invalidFiles = files.filter(f => !safePathRegex.test(f));
    if (invalidFiles.length) return sendJson(res, { error: "Invalid file paths: " + invalidFiles.join(", ") }, 403);
    if (!message || !message.trim()) return sendJson(res, { error: "Commit message required" }, 400);

    // Verify resolved paths stay within the repo's etterlevelse/ directory
    const ettDir = path.resolve(repoRoot, "etterlevelse");
    for (const f of files) {
      const resolved = path.resolve(repoRoot, f);
      if (!resolved.startsWith(ettDir + path.sep) && resolved !== ettDir) {
        return sendJson(res, { error: "Path traversal detected: " + f }, 403);
      }
    }

    try {
      // Stage selected files
      execFileSync("git", ["add", "--", ...files], { cwd: repoRoot, encoding: "utf-8" });
      // Commit
      execFileSync("git", ["commit", "-m", message.trim()], { cwd: repoRoot, encoding: "utf-8" });
      // Push
      const branch = execFileSync("git", ["rev-parse", "--abbrev-ref", "HEAD"], { cwd: repoRoot, encoding: "utf-8" }).trim();
      execFileSync("git", ["push", "origin", branch], { cwd: repoRoot, encoding: "utf-8", timeout: 30000 });
      return sendJson(res, { ok: true, branch, committedFiles: files });
    } catch (e) {
      return sendJson(res, { error: e.stderr || e.message }, 500);
    }
  }

  // Serve static files
  let filePath = url.pathname === "/" ? "/index.html" : url.pathname;
  filePath = path.join(BASE, filePath);
  const resolved = path.resolve(filePath);
  if (!resolved.startsWith(BASE + path.sep) && resolved !== BASE) {
    res.writeHead(403);
    res.end("Forbidden");
  } else if (fs.existsSync(resolved) && fs.statSync(resolved).isFile()) {
    const ext = path.extname(resolved);
    const mimeTypes = { ".html": "text/html", ".js": "application/javascript", ".css": "text/css", ".json": "application/json" };
    res.writeHead(200, { "Content-Type": mimeTypes[ext] || "text/plain" });
    res.end(fs.readFileSync(resolved));
  } else {
    res.writeHead(404);
    res.end("Not found");
  }
});

server.listen(PORT, () => {
  console.log(`\n  Etterlevelse QA-server kjører på: http://localhost:${PORT}\n`);
  console.log(`  Leser input fra:  ${INPUT_DIR}`);
  console.log(`  Leser/skriver output: ${OUTPUT_DIR}`);
  console.log(`  QA-status lagres i:   ${QA_FILE}\n`);

  // Auto-pull on startup
  const repoRoot = path.resolve(BASE, "..");
  try {
    console.log("  ⬇ Henter siste fra GitHub…");
    const output = execFileSync("git", ["pull"], { cwd: repoRoot, encoding: "utf-8", timeout: 30000 }).trim();
    console.log(`  ✓ ${output}\n`);
  } catch (e) {
    console.log(`  ⚠ Pull feilet: ${(e.stderr || e.message).trim()}\n`);
  }
});
