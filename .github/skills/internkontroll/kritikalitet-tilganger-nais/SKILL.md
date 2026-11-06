---
name: kritikalitet-tilganger-nais
description: >-
  Lager en kort kritikalitetsvurdering (HØY/LAV) for en valgt EP-applikasjon
  basert pa NAIS-manifester og kodeverifisering av tilgangstyper.
agent: eessi-pensjon-etterlevelse
---

# Kritikalitet tilganger NAIS

Denne skillen lager en copy-paste-klar markdown-oversikt for kritikalitet av
NAIS-tilganger for en valgt applikasjon i meta-repoet.

Malen er:

- `### HOY KRITIKALITET`
- `#### Google Secret Manager`
- `#### Kafka`
- `#### REST API`
- `#### Azure AD - Rollekontroll` (kun hvis grupper er eksplisitt satt)
- `### LAV KRITIKALITET`
- `#### GCP Buckets`

## Input

Brukeren oppgir normalt:

- applikasjon (f.eks. `eessi-pensjon-oppgave`)
- scope: `prod-only` eller `alle miljo`

Hvis scope ikke er oppgitt, bruk `alle miljo`.

## Kilder som skal brukes

1. `docs/internkontroll/kritikalitet_tilganger_nais.txt` (regelgrunnlag)
2. `<app>/nais/*.yml` / `<app>/nais/*.yaml`
3. `<app>/nais/topics/*.yml` / `<app>/nais/topics/*.yaml` (hvis finnes)
4. `<app>/src/main/resources/application.yml`
5. relevant kode i `<app>/src/main/**` for a verifisere Kafka READ/WRITE

## Regler

1. **Ikke dikt opp tilganger.** Bruk kun det som kan verifiseres i kilder.
2. **Prod-only betyr kun prod-manifest.** Ikke ta med q1/q2/dev.
3. **Google Secret Manager:** ta med `envFrom.secret`.
4. **Kafka topics:**
   - les topic-navn fra miljøvariabler i NAIS/app config
   - klassifiser `READ/WRITE` kun hvis verifisert
   - verifisering:
     - `@KafkaListener` => READ
     - `KafkaTemplate.send*` => WRITE
     - topic ACL i `nais/topics` kan brukes som ekstra bevis
   - hvis retning ikke kan verifiseres: bruk `(tilgang konfigurert)`
5. **REST API:**
   - ta med outbound `accessPolicy.external.host`
   - oversett til kjent tjenestenavn der det er tydelig (f.eks. PDL, SAF)
6. **Azure AD grupper:**
   - ta med kun hvis `azure.application.claims.groups` er satt
   - bruk gruppenavn hvis kommentert i manifest, ellers oppgi kun id
7. **GCP Buckets:**
   - ta med `gcp.buckets[].name`
   - hvis ingen buckets: skriv `Ingen verifiserte bucket-tilganger`
8. **Kort og direkte norsk språk.**

## Steg

1. Finn app-katalogen i meta-repoet.
2. Les aktuelle NAIS-manifester etter valgt scope.
3. Samle secrets, Kafka-topic variabler, outbound hosts, Azure-grupper, buckets.
4. Verifiser Kafka-retning i kode (`@KafkaListener`, `KafkaTemplate`).
5. Kryssjekk med `nais/topics` hvis tilgjengelig.
6. Generer markdown i formatet under.

## Output format

Returner kun denne markdown-strukturen:

```markdown
### HOY KRITIKALITET
#### Google Secret Manager
- secret: <navn>

#### Kafka
- <topic> (READ)
- <topic> (WRITE)
- <topic> (tilgang konfigurert)

#### REST API
- <tjeneste 1>
- <tjeneste 2>

#### Azure AD - Rollekontroll
- Gruppe <navn eller id>

### LAV KRITIKALITET
#### GCP Buckets
- <bucket-navn>
```

## Kvalitetssjekk for levering

- Har du utelatt alle q1/q2/dev-linjer ved `prod-only`?
- Er alle punkter sporbare til filreferanser?
- Er Kafka-retning merket konservativt?
- Er output i samme stil som tidligere internkontroll-eksempler?

