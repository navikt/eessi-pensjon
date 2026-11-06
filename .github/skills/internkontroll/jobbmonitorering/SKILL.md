---
name: jobbmonitorering
description: >-
  Lager en copy-paste-klar tertialvis dokumentasjon av jobbmonitorering for
  kritisk dataflyt i en valgt EP-applikasjon, iht.
  docs/internkontroll/jobbmonitorering.txt.
agent: eessi-pensjon-etterlevelse
---

# Jobbmonitorering

Denne skillen dokumenterer jobbmonitorering av kritisk dataflyt for en valgt
applikasjon i EESSI Pensjon.

Skillen er tertialvis og bruker rutinen i
`docs/internkontroll/jobbmonitorering.txt`.

## Input

Brukeren oppgir normalt:

- applikasjon (f.eks. `eessi-pensjon-pdl-produsent`)
- periode (f.eks. `T1 2026`, `T2 2026`, `T3 2026`)
- scope: `prod-only` eller `alle miljo`

Hvis scope ikke er oppgitt, bruk `prod-only`.

## Kilder som skal brukes

1. `docs/internkontroll/jobbmonitorering.txt` (regelgrunnlag)
2. `docs/internkontroll/monitorering_kritisk_dataflyt.txt` (detaljkrav)
3. `<app>/nais/prod-gcp.yml` (og evt. dev ved `alle miljo`)
4. `<app>/nais/topics/*.yml` (hvis finnes)
5. `<app>/src/main/resources/application.yml`
6. Kode i `<app>/src/main/**`:
   - `@KafkaListener` => inn/READ
   - `KafkaTemplate.send*` => ut/WRITE
   - REST-klienter => synkron dataflyt ut
   - Scheduler/batch/job-klasser => bakgrunnsjobb
7. Driftssignaler (hvis tilgjengelig):
   - Grafana/Prometheus dashboards
   - Alert-historikk
   - Logger/Splunk/Loki
   - Incident/JIRA for perioden

## Regler

1. **Ikke dikt opp dataflyter eller feil.** Alt skal kunne spores til kilder.
2. **Produsent/konsument-ansvar:**
   - Produsent monitorerer produksjon
   - Konsument monitorerer konsumering
3. **Kritisk dataflyt** er flyt som kan pavirke okonomi, regnskap eller rapportering.
4. **Monitorering skal dekke:**
   - Fullstendighet
   - Korrekthet
   - Rettidighet
5. **Konservativ vurdering:**
   - Hvis monitorering ikke kan verifiseres: bruk `Ikke verifisert`
   - Hvis feil ikke kan bekreftes lukket innen frist: marker avvik
6. **Avvik skal foresla oppfolging:**
   - JIRA-sak
   - Teknologileder informeres
   - Produktleder informeres

## Steg

1. Identifiser alle dataflyter inn/ut for valgt app.
2. Marker hvilke som er kritiske.
3. Kartlegg monitorering pr kritisk dataflyt:
   - metrics
   - alarmer
   - loggspor
   - oppfolgingsrutine/eier
4. Kontroller perioden:
   - feil pa kritiske flyter
   - om feil ble fulgt opp
   - om feil ble lost innen frist
5. Dokumenter avvik og anbefalt oppfolging.
6. Returner output i formatet under.

## Output format

Returner kun denne markdown-strukturen:

```markdown
## Jobbmonitorering - <appnavn>

**Rutine:** docs/internkontroll/jobbmonitorering.txt
**Periode:** <T1/T2/T3 YYYY>
**Frekvens:** Tertialsvis
**Ansvarlig rolle:** Teknologileder
**Scope:** <prod / alle miljo>

### Kritiske dataflyter

| Dataflyt | Retning | Type | Kritikalitet | Eier (produsent/konsument) |
|----------|---------|------|--------------|-----------------------------|
| <topic/api/job> | Inn/Ut | Kafka/REST/Batch | KRITISK/IKKE KRITISK | <app/system> |

### Monitorering per kritisk dataflyt

| Dataflyt | Fullstendighet | Korrekthet | Rettidighet | Monitorering status | Merknad |
|----------|----------------|------------|-------------|---------------------|---------|
| <flyt> | Ja/Nei/Ikke verifisert | Ja/Nei/Ikke verifisert | Ja/Nei/Ikke verifisert | Pa plass/Delvis/Mangler | <kort> |

### Feil og oppfolging i perioden

| Dataflyt | Feil identifisert | Innen frist lost | Avvik | Tiltak |
|----------|-------------------|------------------|-------|--------|
| <flyt> | Ja/Nei | Ja/Nei/Uavklart | Ja/Nei | <JIRA/oppfolging> |

### Konklusjon

**Aggregert status:** <OK / DELVIS / AVVIK>

<1-3 setninger om status for kritisk dataflyt og monitorering i perioden.>

### Avvikshandtering

- [ ] JIRA opprettet for avvik
- [ ] Teknologileder informert
- [ ] Produktleder informert
- [ ] Ny gjennomgang planlagt etter utbedring
```

## Kvalitetssjekk for levering

- Er alle inn/ut-dataflyter kartlagt?
- Er kritiske dataflyter tydelig markert?
- Er fullstendighet, korrekthet og rettidighet vurdert per kritisk flyt?
- Er feil i perioden dokumentert med friststatus?
- Er avvik og oppfolging tydelig beskrevet?

