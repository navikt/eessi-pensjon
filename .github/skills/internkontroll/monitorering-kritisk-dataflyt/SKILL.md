---
name: monitorering-kritisk-dataflyt
description: >-
  Lager en copy-paste-klar dokumentasjon av monitorering av kritisk dataflyt
  for en valgt EP-applikasjon, basert på kode, NAIS-manifester og
  observability-konfigurasjon. Følger rutinen i
  docs/internkontroll/monitorering_kritisk_dataflyt.txt.
agent: eessi-pensjon-etterlevelse
---

# Monitorering av kritisk dataflyt

Denne skillen dokumenterer monitorering av kritisk dataflyt for en valgt
applikasjon i EESSI Pensjon, iht. rutinen i
`docs/internkontroll/monitorering_kritisk_dataflyt.txt`.

Resultatet er en copy-paste-klar markdown-tabell som kan brukes i
internkontroll-dokumentasjonen.

## Input

Brukeren oppgir normalt:

- applikasjon (f.eks. `eessi-pensjon-journalforing`)
- scope: `prod-only` eller `alle miljo`

Hvis scope ikke er oppgitt, bruk `prod-only`.

## Kilder som skal brukes

1. `docs/internkontroll/monitorering_kritisk_dataflyt.txt` (regelgrunnlag)
2. `<app>/nais/prod-gcp.yml` (og evt. dev-manifester ved `alle miljo`)
3. `<app>/nais/topics/*.yml` (for å fastslå Kafka-produsent/konsument-rolle)
4. `<app>/src/main/resources/application.yml`
5. Kode i `<app>/src/main/**`:
   - `@KafkaListener` — konsument av topic
   - `KafkaTemplate.send*` / `sendDefault` — produsent av topic
   - REST-klienter (WebClient, RestTemplate) — synkrone dataflyter ut
   - REST-kontrollere — synkrone dataflyter inn
6. Observability-konfigurasjon:
   - `nais.yaml` `observability.logging` og `observability.autoInstrumentation`
   - Prometheus-endepunkt (`/actuator/prometheus` eller tilsvarende)
   - Bruk av `ep-metrics` / `MetricsHelper` i kode
   - Alerting-konfigurasjon (Prometheus-alerts, `.nais/alerts.yml` e.l.)

## Hva er en kritisk dataflyt (iht. regelgrunnlag)

En dataflyt er kritisk hvis den:

- initierer eller benyttes i behandling som påvirker økonomiske transaksjoner, eller
- avleverer data til et økonomisystem (f.eks. PESYS/PEN, DVH/statistikk)

Asynkrone Kafka-topics og synkrone REST-kall til slike systemer skal vurderes.

## Regler

1. **Ikke dikt opp dataflyter.** Kun det som kan verifiseres i kildene.
2. **Produsent vs. konsument:**
   - `@KafkaListener` => konsument (inn)
   - `KafkaTemplate.send*` => produsent (ut)
   - Synkron REST-klient => dataflyt ut
   - REST-kontroller (inbound accessPolicy) => dataflyt inn
3. **Kritikalitetsvurdering per dataflyt:**
   - `KRITISK` — berører økonomi (PESYS, statistikk til DVH, journalføring til Joark/Dokarkiv)
   - `IKKE KRITISK` — intern teknisk flyt uten direkte økonomieffekt
4. **Monitorering — vurder hva som faktisk finnes:**
   - Prometheus-metrics (er MetricsHelper / `@Timed` i bruk?)
   - Logging med strukturert output (ep-logging)
   - Alerting (finnes alerts-konfig?)
   - Manuell oppfølging (dead letter queues, retry-logikk, feilhåndtering i koden)
   - Merk: NAIS autoInstrumentation gir baseline JVM-metrics, men dette er
     ikke tilstrekkelig for kritisk dataflyt-monitorering alene
5. **Konservativ vurdering:** hvis monitorering ikke kan verifiseres fra koden,
   merk som `Ikke verifisert`.
6. **Kort og direkte norsk språk.**

## Steg

1. Finn app-katalogen i meta-repoet.
2. Les prod-NAIS-manifest. Finn Kafka-topics, outbound REST-hosts og observability-konfig.
3. Finn `@KafkaListener` og `KafkaTemplate`-bruk i kode — klassifiser retning.
4. Finn REST-klienter mot kritiske systemer (PESYS, Joark/Dokarkiv, DVH).
5. Vurder kritikalitet per dataflyt iht. regelgrunnlaget.
6. Vurder eksisterende monitorering fra kode og konfig.
7. Generer tabellen og konklusjonen under.

## Output format

Returner kun denne markdown-strukturen:

```markdown
## Monitorering av kritisk dataflyt — <appnavn>

**Rutine:** docs/internkontroll/monitorering_kritisk_dataflyt.txt
**Dato:** <YYYY-MM-DD>
**Scope:** prod

### Dataflyter

| Dataflyt | Retning | Type | Kritikalitet | Monitorering | Merknad |
|----------|---------|------|--------------|--------------|---------|
| <topic eller API> | Inn / Ut | Kafka / REST | KRITISK / IKKE KRITISK | Ja / Nei / Ikke verifisert | <kort begrunnelse> |

### Konklusjon

**Aggregert status:** <KRITISK DATAFLYT MONITORERT / MANGLER MONITORERING / IKKE KRITISKE DATAFLYTER>

<1–3 setninger om hva som er på plass og eventuelle gap.>

### Avvik

<Liste over dataflyter som er kritiske og mangler verifisert monitorering, eller
skriv "Ingen avvik identifisert." >
```

## Kvalitetssjekk for levering

- Er alle Kafka-topics fra prod-manifest tatt med i tabellen?
- Er alle outbound REST-kall mot PESYS, Joark, SAF, DVH tatt med?
- Er kritikalitetsvurderingen begrunnet?
- Er monitorering-statusen verifisert fra kode/konfig, ikke antatt?
- Er konklusjonen i samsvar med regelgrunnlagets krav (fullstendighet, korrekthet, rettidighet)?

