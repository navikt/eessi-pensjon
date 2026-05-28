#!/usr/bin/env node
/**
 * parse-input.mjs
 *
 * Tar inn rå tekst kopiert fra etterlevelse-portalen og oppretter en
 * strukturert agent-input-fil (etterlevelse/agent-input/K<nr>.<versjon>.txt).
 *
 * Bruk:
 *   node etterlevelse/script/parse-input.mjs < råtekst.txt
 *   node etterlevelse/script/parse-input.mjs råtekst.txt
 *   pbpaste | node etterlevelse/script/parse-input.mjs
 */

import { createInterface } from "readline";
import { readFileSync, writeFileSync, existsSync, openSync, createReadStream } from "fs";
import { execSync } from "child_process";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const OUTPUT_DIR = resolve(__dirname, "..", "agent-input");

const TEMAER = [
  "Personvern",
  "Saksbehandling og forvaltningsrett",
  "Arkiv og dokumentasjon",
  "Elektronisk kommunikasjon",
  "Informasjonssikkerhet",
  "Interoperabilitet og samhandling",
  "Likestilling og ikke-diskriminering",
  "Språk",
  "Statistikk og styringsinformasjon",
  "Økonomi",
];

// --- Helpers ---

function stripHtml(text) {
  return text
    .replace(/&nbsp;/gi, " ")
    .replace(/&amp;/gi, "&")
    .replace(/&lt;/gi, "<")
    .replace(/&gt;/gi, ">")
    .replace(/&quot;/gi, '"')
    .replace(/<br\s*\/?>/gi, "\n")
    .replace(/<\/?(p|div|li|ul|ol|h[1-6]|span|strong|em|b|i|a|table|tr|td|th|thead|tbody)[^>]*>/gi, "\n")
    .replace(/<[^>]+>/g, "")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

function wrapLines(text, maxLen = 120) {
  return text
    .split("\n")
    .map((line) => {
      if (line.length <= maxLen) return line;
      const words = line.split(/\s+/);
      const wrapped = [];
      let current = "";
      for (const w of words) {
        if (current && current.length + 1 + w.length > maxLen) {
          wrapped.push(current);
          current = w;
        } else {
          current = current ? current + " " + w : w;
        }
      }
      if (current) wrapped.push(current);
      return wrapped.join("\n");
    })
    .join("\n");
}

function ask(rl, question) {
  return new Promise((resolve) => rl.question(question, resolve));
}

// --- Parsing ---

function findKravId(text) {
  const match = text.match(/K(\d+)\.(\d+)/);
  return match ? match[0] : null;
}

function findTema(text) {
  for (const tema of TEMAER) {
    if (text.toLowerCase().includes(tema.toLowerCase())) return tema;
  }
  // Try short forms
  if (/informasjonssikkerhet/i.test(text)) return "Informasjonssikkerhet";
  if (/personvern/i.test(text)) return "Personvern";
  if (/arkiv/i.test(text)) return "Arkiv og dokumentasjon";
  return null;
}

function findTitle(text, kravId) {
  // Look for the title near the krav-ID
  const lines = text.split("\n");
  for (const line of lines) {
    if (line.includes(kravId)) {
      const after = line.substring(line.indexOf(kravId) + kravId.length).trim();
      // Remove leading separators
      let title = after.replace(/^[\s:–\-]+/, "").trim();
      // Strip tema prefix if present
      for (const tema of TEMAER) {
        if (title.toLowerCase().startsWith(tema.toLowerCase())) {
          title = title.substring(tema.length).replace(/^[\s:–\-]+/, "").trim();
          break;
        }
      }
      if (title.length > 5) return title;
    }
  }
  // Try next line after krav-ID line
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].includes(kravId) && i + 1 < lines.length) {
      const next = lines[i + 1].trim();
      if (next.length > 5 && !next.match(/^(hensikt|sukse|tema|krav)/i)) return next;
    }
  }
  return null;
}

function findHensikt(text) {
  const lower = text.toLowerCase();
  // Look for "hensikt" section
  const markers = ["hensikt med kravet", "hensikten med kravet", "hensikt"];
  for (const marker of markers) {
    const idx = lower.indexOf(marker);
    if (idx < 0) continue;
    const afterMarker = text.substring(idx + marker.length);
    // Skip header chars
    const content = afterMarker.replace(/^[\s:–\-\n]+/, "");
    // Take until next section
    const endMatch = content.match(/\n\s*(suksesskriterium|oppgave|skriv en tekst)/i);
    const end = endMatch ? endMatch.index : Math.min(content.length, 2000);
    const hensikt = content.substring(0, end).trim();
    if (hensikt.length > 10) return hensikt;
  }
  return null;
}

function findCriteria(text) {
  const criteria = [];
  // Pattern: "Suksesskriterium N" or numbered criteria
  const lines = text.split("\n");

  // Strategy 1: Look for "Suksesskriterium" markers
  const skPattern = /suksesskriterium\s*(\d+)/i;
  const skIndices = [];
  for (let i = 0; i < lines.length; i++) {
    if (skPattern.test(lines[i])) skIndices.push(i);
  }

  if (skIndices.length > 0) {
    for (let s = 0; s < skIndices.length; s++) {
      const startIdx = skIndices[s];
      const endIdx = s + 1 < skIndices.length ? skIndices[s + 1] : lines.length;
      const block = lines.slice(startIdx, endIdx);

      // Title is usually the next non-empty line after the marker
      let title = "";
      let descStart = 1;
      for (let j = 1; j < block.length; j++) {
        const line = block[j].trim();
        if (!line) continue;
        if (/^(utfyllende|beskrivelse|description)/i.test(line)) {
          descStart = j + 1;
          break;
        }
        if (!title && line.length > 3) {
          title = line;
          descStart = j + 1;
        } else if (title && !/^(utfyllende|beskrivelse)/i.test(line)) {
          descStart = j;
          break;
        }
      }

      // Find description
      let description = "";
      const descLines = [];
      let foundDescMarker = false;
      for (let j = 1; j < block.length; j++) {
        if (/^(utfyllende om kriteriet|utfyllende|beskrivelse)/i.test(block[j].trim())) {
          foundDescMarker = true;
          continue;
        }
        if (foundDescMarker) {
          descLines.push(block[j]);
        }
      }
      if (descLines.length > 0) {
        description = descLines.join("\n").trim();
      } else {
        // Take everything after title
        description = block.slice(descStart).join("\n").trim();
      }

      if (title) criteria.push({ title, description });
    }
  }

  return criteria;
}

// --- Main ---

async function readStdinLines() {
  return new Promise((resolve) => {
    const rl = createInterface({ input: process.stdin, terminal: false });
    const lines = [];
    rl.on("line", (line) => lines.push(line));
    rl.on("close", () => resolve(lines.join("\n")));
  });
}

function readFromClipboard() {
  try {
    return execSync("pbpaste", { encoding: "utf-8" });
  } catch {
    return null;
  }
}

async function main() {
  // Read input
  let rawInput = "";
  const inputFile = process.argv[2];

  if (inputFile) {
    rawInput = readFileSync(inputFile, "utf-8");
  } else if (!process.stdin.isTTY) {
    // Piped input
    rawInput = await readStdinLines();
  } else {
    // Interactive — read from clipboard
    console.log("Ingen fil angitt — leser fra clipboard (pbpaste)...\n");
    rawInput = readFromClipboard();
    if (!rawInput || !rawInput.trim()) {
      console.error("✗ Clipboard er tom. Kopier tekst fra portalen først, eller oppgi filnavn:");
      console.error("  node etterlevelse/script/parse-input.mjs <fil.txt>");
      console.error("  pbpaste | node etterlevelse/script/parse-input.mjs");
      process.exit(1);
    }
  }

  if (!rawInput.trim()) {
    console.error("✗ Ingen input mottatt.");
    process.exit(1);
  }

  const text = stripHtml(rawInput);

  // Set up interactive prompts via /dev/tty (since stdin may be consumed)
  let rlTty;
  let interactive = true;
  try {
    const fd = openSync("/dev/tty", "r");
    rlTty = createInterface({
      input: createReadStream(null, { fd }),
      output: process.stdout,
      terminal: true,
    });
  } catch {
    // /dev/tty not available — use stdin if it's still a TTY
    if (process.stdin.isTTY && !inputFile) {
      // stdin already consumed, can't prompt
      interactive = false;
    } else if (process.stdin.isTTY) {
      rlTty = createInterface({ input: process.stdin, output: process.stdout, terminal: true });
    } else {
      interactive = false;
    }
  }

  const prompt = interactive
    ? (q) => ask(rlTty, q)
    : (q) => { console.error(`\n✗ Interaktiv input kreves: ${q}`); process.exit(1); };

  const cleanup = () => { if (rlTty) rlTty.close(); };

  // --- Parse ---
  let kravId = findKravId(text);
  if (!kravId) {
    kravId = await prompt("Kunne ikke finne krav-ID. Skriv inn (f.eks. K267.1): ");
  } else {
    console.log(`✓ Krav-ID: ${kravId}`);
  }

  let tema = findTema(text);
  if (!tema) {
    console.log("\nKunne ikke utlede tema. Gyldige temaer:");
    TEMAER.forEach((t, i) => console.log(`  ${i + 1}. ${t}`));
    const choice = await prompt("\nVelg nummer (1-10): ");
    const idx = parseInt(choice) - 1;
    tema = TEMAER[idx] || null;
    if (!tema) {
      tema = await prompt("Skriv tema manuelt: ");
    }
  } else {
    console.log(`✓ Tema: ${tema}`);
  }

  let title = findTitle(text, kravId);
  if (!title) {
    title = await prompt("Kunne ikke finne kravtittel. Skriv inn: ");
  } else {
    console.log(`✓ Tittel: ${title}`);
  }

  let hensikt = findHensikt(text);
  if (!hensikt) {
    console.log("⚠ Kunne ikke finne hensiktstekst. Du kan legge den til manuelt i filen etterpå.");
    hensikt = "(Fyll inn hensikt her)";
  } else {
    console.log(`✓ Hensikt: ${hensikt.substring(0, 80)}...`);
  }

  const criteria = findCriteria(text);
  if (criteria.length === 0) {
    console.error("\n✗ Fant ingen suksesskriterier. Sjekk at input-teksten inneholder kriteriene.");
    cleanup();
    process.exit(1);
  }
  console.log(`✓ Suksesskriterier: ${criteria.length} funnet`);
  for (const c of criteria) {
    console.log(`    - ${c.title}`);
  }

  // --- Build output ---
  const N = criteria.length;
  let output = `# Hjelp meg å dokumentere: ${kravId} ${title}\n\n`;
  output += `Tema: ${tema}\n\n`;
  output += `## Hensikten med kravet\n`;
  output += wrapLines(hensikt) + "\n\n";
  output += `## Oppgave til AI\n`;
  output += `Skriv en tekst til meg for "Hvordan oppfylles kriteriet?" som jeg kan paste inn. ...\n\n`;
  output += `du skal lage ${N} tekster:\n\n`;

  for (let i = 0; i < criteria.length; i++) {
    output += `Suksesskriterium ${i + 1} av ${N}\n`;
    output += `${criteria[i].title}\n\n`;
    output += `Utfyllende om kriteriet\n`;
    output += wrapLines(criteria[i].description) + "\n\n";
  }

  // --- Write file ---
  const filename = `${kravId}.txt`;
  const filepath = resolve(OUTPUT_DIR, filename);

  if (existsSync(filepath)) {
    if (interactive) {
      const answer = await prompt(`\n⚠ ${filename} finnes allerede. Overskrive? (j/n): `);
      if (answer.toLowerCase() !== "j") {
        console.log("Avbrutt.");
        cleanup();
        process.exit(0);
      }
    } else {
      console.log(`⚠ ${filename} finnes allerede — overskriver (ikke-interaktiv modus).`);
    }
  }

  writeFileSync(filepath, output, "utf-8");
  console.log(`\n✓ Opprettet: etterlevelse/agent-input/${filename}`);
  console.log(`  Krav: ${kravId} – ${title}`);
  console.log(`  Tema: ${tema}`);
  console.log(`  Suksesskriterier: ${N}`);
  console.log(`\n  Kjør agenten: /etterlev ${kravId}`);

  cleanup();
}

main().catch((e) => {
  console.error("Feil:", e.message);
  process.exit(1);
});
