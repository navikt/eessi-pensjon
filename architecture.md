# EESSI Pensjon (EP) Architecture Overview

This document describes the technical architecture of the **EESSI Pensjon (EP)** domain — NAV's pension-specific system for processing and managing EESSI (Electronic Exchange of Social Security Information) documents and events. EP operates as a downstream consumer of the [EUX platform](https://github.com/navikt/eux-architecture), adding pension-domain logic such as journalføring, prefill, task creation, statistics, and person data updates.

## What is EESSI Pensjon?

**EESSI Pensjon** handles pension-specific processing of SEDs (Structured Electronic Documents) exchanged through the EESSI/RINA system. While the EUX platform handles the generic infrastructure for SED exchange (RINA integration, case management, event routing), EP adds:

- **Journalføring** — archiving pension SEDs in NAV's document archive (Dokarkiv)
- **Prefill** — pre-populating SED forms with data from NAV's pension systems (PESYS/PEN)
- **Task creation** — generating tasks (oppgaver) for caseworkers based on incoming SEDs
- **Claim initialization** — initiating pension claims based on incoming EESSI documents
- **Person data updates** — extracting person information from SEDs and updating PDL
- **Access restriction** — detecting sensitive persons and restricting BUC access
- **Death notifications** — automatically notifying Nordic institutions when a pensioner dies
- **Statistics** — tracking SED processing metrics and outcomes
- **Caseworker UI** — a React frontend for pension caseworkers to manage EESSI cases

## Applications

### Core Services

| Application | Tech | Description |
|---|---|---|
| [eessi-pensjon-fagmodul](https://github.com/navikt/eessi-pensjon-fagmodul) | Kotlin / Spring Boot | Main "business module". Orchestrates SED operations, integrates with EUX, PESYS/PEN, PDL, Dokarkiv, SAF. Publishes statistics to Kafka. |
| [eessi-pensjon-prefill](https://github.com/navikt/eessi-pensjon-prefill) | Kotlin / Spring Boot | Pre-fills SED forms with data from NAV pension systems (PEN), PDL, and KRR. Called by fagmodul. |
| [eessi-pensjon-saksbehandling-api](https://github.com/navikt/eessi-pensjon-saksbehandling-api) | Kotlin / Spring Boot | Frontend API for UI-specific data (user state, Kafka-derived SED status). Consumes sedSendt/sedMottatt events. |
| [eessi-pensjon-saksbehandling-ui](https://github.com/navikt/eessi-pensjon-saksbehandling-ui) | React / TypeScript / Vite | Web frontend for pension caseworkers. Express server proxies `/frontend` → saksbehandling-api and `/fagmodul` → fagmodul. |

### Event-Driven Workers (Kafka Consumers)

| Application | Tech | Consumes | Description |
|---|---|---|---|
| [eessi-pensjon-journalforing](https://github.com/navikt/eessi-pensjon-journalforing) | Kotlin / Spring Boot | `sedSendt`, `sedMottatt` | Journals pension SEDs in Dokarkiv. Creates tasks and initiates claims via internal Kafka topics. |
| [eessi-pensjon-oppgave](https://github.com/navikt/eessi-pensjon-oppgave) | Kotlin / Spring Boot | internal oppgave topic | Creates and updates tasks (oppgaver) in NAV Oppgave for pension caseworkers. |
| [eessi-pensjon-krav-initialisering](https://github.com/navikt/eessi-pensjon-krav-initialisering) | Kotlin / Spring Boot | internal krav topic | Initiates pension claims in PESYS/PEN based on incoming EESSI documents. |
| [eessi-pensjon-pdl-produsent](https://github.com/navikt/eessi-pensjon-pdl-produsent) | Kotlin / Spring Boot | `sedMottatt`, PDL-hendelser | Updates person data in PDL from incoming SEDs. Handles address updates and foreign ID registration. Also creates tasks (oppgaver) when manual follow-up is needed. |
| [eessi-pensjon-begrens-innsyn](https://github.com/navikt/eessi-pensjon-begrens-innsyn) | Kotlin / Spring Boot | `sedSendt`, `sedMottatt` | Detects sensitive Norwegian IDs (kode 6/7) in SEDs and marks the BUC as sensitive via eux-rina-api. |
| [eessi-pensjon-statistikk](https://github.com/navikt/eessi-pensjon-statistikk) | Kotlin / Spring Boot | `sedSendt`, `sedMottatt`, statistikk topics | Collects and produces statistics about SED processing for reporting. |
| [eessi-pensjon-dodsmelding](https://github.com/navikt/eessi-pensjon-dodsmelding) | Kotlin / Spring Boot | `pdl.leesah-v1` (PDL person events) | Listens for death notifications from PDL. When a person dies, checks PESYS for pension cases and creates H070 SED (death notification) to relevant Nordic institutions (Sweden, Finland, Poland) via EUX. |

### Libraries

These are not deployed applications — they are shared dependencies used by the services above.

| Library | Description |
|---|---|
| [ep-eux](https://github.com/navikt/ep-eux) | Helper library for integrating with the Rina EUX API (`eux-rina-api`). Reduces duplicate HTTP client code across EP apps. |
| [ep-kodeverk](https://github.com/navikt/ep-kodeverk) | Shared code registry (kodeverk) library. Provides lookup of EESSI codes via NAV's kodeverk service. |
| [ep-logging](https://github.com/navikt/ep-logging) | Shared logging library. MDC-based request tracing, audit logging via syslog. |
| [ep-metrics](https://github.com/navikt/ep-metrics) | Shared metrics library. Prometheus request-count filter with toggle (`METRICS_REQUESTFILTER_ENABLE`). |
| [ep-personoppslag](https://github.com/navikt/ep-personoppslag) | Shared person-lookup library. Wraps PDL calls for consistent person data access across EP apps. |

### Supporting Tools

| Tool | Description |
|---|---|
| [ep-meta-analyse](https://github.com/navikt/eessi-pensjon/tree/master/ep-meta-analyse) | Code and revision history analysis tool. Generates PDF notebook reports. |

## Architecture Diagram

The diagram below is based on [ep-architecture.svg](ep-architecture.svg) and the actual code. The EP domain is divided into **synchronous** services (user-initiated request/response) and **asynchronous** workers (Kafka-driven event processing).

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                                EESSI-PENSJON (EP)                                │
│                                                                                  │
│  ┌─ SYNKRON (Request/Response) ─────────────────────────────────────────────────┐│
│  │                                                                              ││
│  │  ┌──────────────────────────────────────┐                                    ││
│  │  │  SAKSBEHANDLING-UI (React + Express) │                                    ││
│  │  │                                      │                                    ││
│  │  │  /       → EP entry page             │                                    ││
│  │  │  /gjenny → Gjenny entry page         │                                    ││
│  │  └────────┬──────────────┬──────────────┘                                    ││
│  │           │              │                                                   ││
│  │  /frontend (proxy)  /fagmodul (proxy)                                        ││
│  │           │              │                                                   ││
│  │           ▼              ▼                                                   ││
│  │  ┌────────────────┐  ┌────────────────┐        ┌────────────────┐            ││
│  │  │SAKSBEHANDLING- │  │    FAGMODUL    │───────▶│    PREFILL     │            ││
│  │  │API             │  │                │        │                │            ││
│  │  │(UI state,      │  │(SED operations,│        │(Pre-fill SEDs  │            ││
│  │  │ Kafka-derived  │  │ orchestration) │        │ from PEN, PDL, │            ││
│  │  │ SED status)    │  │                │        │ KRR)           │            ││
│  │  └────────────────┘  └───────┬────────┘        └───────┬────────┘            ││
│  │                              │                         │                     ││
│  └──────────────────────────────┼─────────────────────────┼─────────────────────┘│
│                                 │                         │                      │
│  ┌─ ASYNK (Kafka Event-Driven)  ┼─────────────────────────┼───────────────────┐  │
│  │                              │                         │                   │  │
│  │  ┌────────────────┐          │                         │                   │  │
│  │  │ JOURNALFORING  │──────────┼─────────────────────────┼───────────┐       │  │
│  │  └──────┬─────────┘          │                         │           │       │  │
│  │         │                    │                         │           │       │  │
│  │    ┌────┴─────┐              │                         │           │       │  │
│  │    ▼          ▼              │                         │           │       │  │
│  │  ┌──────┐ ┌──────────┐       │                         │           │       │  │
│  │  │OPPG. │ │KRAV-INIT │       │                         │           │       │  │
│  │  └──────┘ └──────────┘       │                         │           │       │  │
│  │                              │                         │           │       │  │
│  │  ┌────────────────┐          │                         │           │       │  │
│  │  │ BEGRENS INNSYN │──────────┼─────────────────────────┼───────────┤       │  │
│  │  └────────────────┘          │                         │           │       │  │
│  │                              │                         │           │       │  │
│  │  ┌────────────────┐          │                         │           │       │  │
│  │  │ PDL-PRODUSENT  │──────────┼─────────────────────────┼───────────┤       │  │
│  │  └────────────────┘          │                         │           │       │  │
│  │                              │                         │           │       │  │
│  │  ┌────────────────┐          │                         │           │       │  │
│  │  │ STATISTIKK     │──────────┼─────────────────────────┼───────────┤       │  │
│  │  └────────────────┘          │                         │           │       │  │
│  │                              │                         │           │       │  │
│  │  ┌────────────────┐          │                         │           │       │  │
│  │  │ DODSMELDING    │──────────┼─────────────────────────┼───────────┤       │  │
│  │  └────────────────┘          │                         │           │       │  │
│  │                              │                         │           │       │  │
│  └──────────────────────────────┼─────────────────────────┼───────────┼───────┘  │
│                                 │                         │           │          │
└─────────────────────────────────┼─────────────────────────┼───────────┼──────────┘
                                  │                         │           │
                                  ▼                         ▼           ▼
┌────────────────────────────────────────────────────────────────────────────────────┐
│  EXTERNAL SYSTEMS                                                                  │
│                                                                                    │
│  ┌─────────────┐  ┌──────┐  ┌──────┐  ┌────────┐  ┌──────┐  ┌─────────────┐        │
│  │EUX-RINA-API │  │ PDL  │  │PESYS │  │  JOARK │  │ SAF  │  │PERSON-MOTTAK│        │
│  └─────────────┘  └──────┘  └──────┘  └────────┘  └──────┘  └─────────────┘        │
│                                                                                    │
│  ┌─────────────┐  ┌──────┐  ┌────────┐  ┌──────┐  ┌──────┐  ┌────────────┐         │
│  │   OPPGAVE   │  │NORG2 │  │KODEVERK│  │ KRR  │  │  S3  │  │ ETTERLATTE │         │
│  └─────────────┘  └──────┘  └────────┘  └──────┘  └──────┘  └────────────┘         │
│                                                                                    │
│  ┌─────────────┐  ┌──────────┐                                                     │
│  │     DVH     │  │NAV Ansatt│                                                     │
│  └─────────────┘  └──────────┘                                                     │
│                                                                                    │
└────────────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────────────────┐
│  KAFKA TOPICS                                                                      │
│                                                                                    │
│  FROM EUX:                                                                         │
│    eessi-basis-sedsendt-v1                                                         │
│    eessi-basis-sedmottatt-v1                                                       │
│                                                                                    │
│  FROM PDL:                                                                         │
│    pdl.leesah-v1                                                                   │
│                                                                                    │
│  INTERNAL EP:                                                                      │
│    privat-eessipensjon-oppgave-v1-p                                                │
│    privat-eessipensjon-krav-initialisering                                         │
│    eessipensjon.privat-statistikk                                                  │
│    eessipensjon.public-statistikk                                                  │
│    eessipensjon.public-automatisering                                              │
│                                                                                    │
└────────────────────────────────────────────────────────────────────────────────────┘
```

### Service-to-service connections (from code)

| EP Service | Calls |
|---|---|
| **saksbehandling-ui** | saksbehandling-api (`/frontend`), fagmodul (`/fagmodul`) |
| **fagmodul** | EUX-RINA-API, PREFILL, PESYS, PDL, SAF |
| **prefill** | PESYS, PDL, KRR, Etterlatte |
| **journalforing** | EUX-RINA-API, fagmodul, JOARK, PDL, SAF, NORG2, NAV Ansatt, PESYS (bestemSak), Etterlatte |
| **oppgave** | OPPGAVE, SAF |
| **krav-initialisering** | PESYS (PEN) |
| **pdl-produsent** | EUX-RINA-API, PDL, PERSON-MOTTAK, SAF, NORG2 |
| **begrens-innsyn** | EUX-RINA-API, PDL |
| **statistikk** | EUX-RINA-API |
| **dodsmelding** | EUX-RINA-API, PESYS, PDL, SAF |

## How the Apps Talk to Each Other

### Request Flow (user-initiated)

1. **saksbehandling-ui** → The caseworker opens the pension EESSI app. The Express server in saksbehandling-ui handles authentication (Wonderwall sidecar) and proxies requests:
   - `/frontend/*` → **saksbehandling-api** (UI-specific state, user preferences, Kafka-derived SED status)
   - `/fagmodul/*` → **fagmodul** (SED operations, BUC management, pension lookups)

2. **fagmodul** → The main orchestrator handles SED operations:
   - **prefill** — pre-populates SEDs with pension data from PEN, PDL, KRR
   - **eux-rina-api** (EUX platform) — RINA/SED operations (create case, fetch/send SED)
   - **PESYS/PEN** — pension case data and claim management
   - **PDL** — person data lookups (GraphQL)
   - **Dokarkiv / SAF** — journal post creation and queries
   - **Kodeverk** — EESSI code lookups

### Event Flow (Kafka-driven)

1. When a SED is sent or received in RINA, the EUX event pipeline delivers events to the legacy Kafka topics `eessi-basis-sedsendt-v1` and `eessi-basis-sedmottatt-v1`.

2. EP's Kafka consumers process these events in parallel:
   - **journalforing** — journals the SED in Dokarkiv, then publishes to internal topics for downstream processing
   - **begrens-innsyn** — checks all Norwegian IDs in the SED against PDL for sensitive status (kode 6/7), marks the BUC sensitive if needed
   - **pdl-produsent** — extracts person data (addresses, foreign IDs) and updates PDL via PERSON-MOTTAK
   - **statistikk** — records metrics about SED processing
   - **saksbehandling-api** — tracks incoming/outgoing SEDs for the caseworker UI

3. **journalforing** publishes to internal Kafka topics consumed by:
   - **oppgave** — creates NAV tasks for pension caseworkers
   - **krav-initialisering** — initiates pension claims in PESYS/PEN

4. **pdl-produsent** also publishes to the oppgave topic when person data processing requires manual follow-up by a caseworker.

5. **dodsmelding** listens to `pdl.leesah-v1` (PDL person events). When a death event is detected, it looks up the person in PESYS for active pension cases, then creates and sends an H070 SED (death notification) to relevant Nordic/Polish institutions via EUX.

### Kafka Topics

| Topic | Producer | Consumer(s) |
|---|---|---|
| `eessi-basis-sedsendt-v1` | EUX platform (eux-legacy-rina-events) | journalforing, begrens-innsyn, statistikk, saksbehandling-api |
| `eessi-basis-sedmottatt-v1` | EUX platform (eux-legacy-rina-events) | journalforing, begrens-innsyn, pdl-produsent, statistikk, saksbehandling-api |
| `pdl.leesah-v1` | PDL | dodsmelding, pdl-produsent |
| `privat-eessipensjon-oppgave-v1-p` | journalforing, pdl-produsent | oppgave |
| `privat-eessipensjon-krav-initialisering` | journalforing | krav-initialisering |
| `eessipensjon.privat-statistikk` | fagmodul, journalforing | statistikk |
| `eessipensjon.public-statistikk` | statistikk | DVH (external) |
| `eessipensjon.public-automatisering` | journalforing, prefill | external consumers (dv-team-pensjon) |

## External NAV Systems

| System | Purpose | Used by |
|---|---|---|
| **EUX-RINA-API** | RINA/SED operations, BUC management | fagmodul, begrens-innsyn, pdl-produsent, statistikk, dodsmelding |
| **PESYS** | Pension case system (claims, benefits) | fagmodul, prefill, krav-initialisering, journalforing, dodsmelding |
| **PDL** | Person data (Folkeregisteret) | fagmodul, journalforing, prefill, pdl-produsent, begrens-innsyn, dodsmelding (via ep-personoppslag) |
| **PERSON-MOTTAK** | Write updates to PDL | pdl-produsent |
| **JOARK** (Dokarkiv) | Create/update journal posts | fagmodul, journalforing |
| **SAF** | Query journal posts and documents | fagmodul, journalforing, oppgave, pdl-produsent, dodsmelding |
| **OPPGAVE** | Task management system | oppgave |
| **KODEVERK** | Code registry service | fagmodul, prefill, pdl-produsent (via ep-kodeverk) |
| **NORG2** | NAV organizational units / routing | journalforing, oppgave |
| **KRR** | Contact and reservation registry | prefill |
| **NAV Ansatt** | Employee/caseworker info | journalforing |
| **Etterlatte** | Survivor benefits system | journalforing, prefill |
| **S3** (GCP Storage) | Intermediate document/state storage | fagmodul, journalforing, statistikk, dodsmelding |

## Common Patterns

- **Language & framework**: All backend services are written in **Kotlin** on **Spring Boot**. The frontend uses **React** with **TypeScript** and **Vite**.
- **Build system**: **Gradle** (Kotlin DSL and Groovy DSL). The meta-repo uses a root `build.gradle` and `settings.gradle` to include all subprojects.
- **Authentication**: All services use **Azure AD** for service-to-service auth (OAuth2 client credentials). The frontend uses Azure AD via the **Wonderwall** sidecar.
- **NAIS deployment**: All apps deploy to **NAIS** (NAV's Kubernetes platform) on GCP.
- **Kafka**: Event-driven architecture using Kafka for SED event processing. Consumer groups are per-application with manual offset management.
- **GCP Storage (S3)**: Several backend services use GCP Storage for intermediate SED document and state storage.
- **Shared libraries**: The `ep-*` libraries provide consistent patterns across all EP apps for EUX integration, person lookups, logging, metrics, and code lookups.
- **Health/metrics**: All JVM services expose `/actuator/health` and `/actuator/prometheus`.
- **Testing**: JaCoCo for coverage, SonarQube for quality gates, MockK for mocking, ArchUnit for architecture tests.

## Relationship to EUX Platform

EP is a **domain-specific consumer** of the EUX platform. The key integration points are:

1. **eux-rina-api** — EP calls this service (via the `ep-eux` library) for all RINA operations: fetching SEDs, creating BUCs, sending documents, setting sensitivity.
2. **Kafka events** — EP consumes the legacy event topics (`sedSendt-v1`, `sedMottatt-v1`) produced by `eux-legacy-rina-events` in the EUX pipeline.

The separation is: **EUX handles generic EESSI infrastructure**, while **EP handles pension-domain business logic**.

## Architectural Decisions

Key architectural decisions are documented in [docs/adr/](docs/adr/index.md):

- **ADR-0001**: Split API module into API-SBS and API-FSS
- **ADR-0002**: Delegation of access control
- **ADR-0003**: Choice of storage for simple data persistence (GCP Storage / Key-Value)
- **ADR-0005**: Code sharing strategy (ep-* libraries)
- **ADR-0006**: Single PDL producer app with multiple listeners on same topic
- **ADR-0008**: Framework for EP listener apps (Kafka consumer pattern)
- **ADR-0010**: Task routing (oppgaveruting)

## Pitfalls and Things to Watch Out For

### Kafka consumer isolation

Each EP consumer has its own consumer group, meaning the same SED event is processed independently by journalforing, begrens-innsyn, pdl-produsent, and statistikk. If one consumer fails, it doesn't block the others — but it also means you can't rely on ordering between them.

### Internal topic chaining

Journalforing publishes to internal topics consumed by oppgave and krav-initialisering. If journalforing is down or processing slowly, task creation and claim initialization are delayed. Monitor consumer lag on all internal topics.

### EUX dependency

Several EP services depend on `EUX-RINA-API` (via the `ep-eux` library): fagmodul, begrens-innsyn, pdl-produsent, statistikk, and dodsmelding. If eux-rina-api is unavailable, SED operations, sensitivity checks, death notifications, and statistics collection all fail.

### Shared libraries version management

The `ep-*` libraries are published to GitHub Package Registry. All consuming apps must use compatible versions. A breaking change in `ep-eux` affects all EP services.

### GCP Storage usage

Several backend services use GCP Storage (S3) for intermediate state and document storage. Ensure bucket permissions and lifecycle policies are correctly configured per environment.

## Other Repositories in the Meta-Repo

The meta-repo also contains frontend helper packages that are not core to the EP architecture but are used by the UI:

| Package | Description |
|---|---|
| fetch-api | HTTP fetch wrapper library |
| tabell | Table component library |
| landvelger | Country selector component |
| land-verktoy | Country utility library |
| flagg-ikoner | Flag icon assets |
| templates / template-data | SED template definitions and data |
