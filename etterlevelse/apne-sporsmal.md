# Åpne spørsmål – etterlevelse

## K267.1 – Applikasjoner skal ha et forsvarlig sikkerhetsnivå

- [ ] **Sårbarhetshåndtering (SK1):** Bekreftes at Snyk CLI kjøres regelmessig (ikke bare ad-hoc) og at teamet har en fast rutine for å følge opp funn. Team eessipensjon.
- [ ] **Sårbarhetshåndtering (SK1):** Backend Kotlin-applikasjonene har ikke Dependabot eller dedikert automatisk sårbarhetsskanning i CI (kun UI-appen har Dependabot for npm). Bekreftes at NAIS-plattformens container-skanning (Trivy) dekker dette tilstrekkelig, eller om det bør legges til Dependabot/Snyk for Gradle-avhengigheter. Team eessipensjon.
- [ ] **Input-validering (SK3):** Saksbehandler-UI har fritekstfelt (TextArea) i P2000 og P8000 SED-skjemaer. Frontend begrenser kun lengde (maxLength). Bekreftes at fagmodul/backend validerer innholdet mot SED-skjema og filtrerer ugyldige tegn før data sendes til RINA. Team eessipensjon.
- [ ] **Input-validering (SK3):** Error.tsx bruker dangerouslySetInnerHTML for feilbeskrivelse og stacktrace. Bekreftes at description-feltet kun populeres fra oversettelsesnøkler (i18n) og aldri fra brukerinput. Team eessipensjon.
- [ ] **Hemmeligheter (SK4):** Bekreftes at Azure AD-secrets roteres automatisk og hva den faktiske frekvensen er. NAIS-teamet / team eessipensjon.
- [ ] **Logging (SK5):** Bekreftes at fødselsnummer/aktør-ID faktisk kun logges til sikre logger og aldri lekker til standard applikasjonslogger eller URL-er. Team eessipensjon.
- [ ] **Logging (SK5):** Bekreftes at loggene faktisk er tilrettelagt og tilgjengelige for Team ISOC ved hendelser. Team ISOC / plattformteam.
- [ ] **Backup (SK6):** Bekreftes at GCP Storage-bøttene har versjonering aktivert og at teamet har testet gjenoppretting. Team eessipensjon.
- [ ] **Tilgangskontroll (SK7):** Bekreftes at Wonderwall-oppsettet krever enten compliant device eller phishing-resistent MFA for Nav-ansatte. NAIS-teamet.

## K255.1 – Nav skal beskytte brukere med adressebeskyttelse

- [ ] **Tilgangssjekk (SK1):** Avklares om tilgangskontrollen for adressebeskyttede brukere utelukkende håndheves av RINA/EUX-plattformen, eller om EESSI Pensjon har en egen sjekk mot GA-Fortrolig_Adresse / GA-Strengt_Fortrolig_Adresse i sitt API-lag. Team eessipensjon.
- [ ] **Tilgangssjekk (SK1, SK5):** Begrens-innsyn-sjekken markerer BUC-er som sensitive kun for STRENGT_FORTROLIG og STRENGT_FORTROLIG_UTLAND — ikke for FORTROLIG (kode 7). Avklares om dette er tilsiktet, og om brukere med kode 7 likevel er tilstrekkelig beskyttet gjennom at adressefeltet utelates i prefill. Team eessipensjon.
- [ ] **Tydelig markering (SK2):** Bekreftes at saksbehandlergrensesnittet tydelig viser at en sak involverer en person med adressebeskyttelse (f.eks. med ikon, farge eller banner) — ikke bare at tilgangen avvises. Team eessipensjon / EUX-plattformteam.
- [ ] **Tydelig markering (SK2):** Bekreftes at RINA faktisk gir saksbehandler en forklaring når tilgang avvises (f.eks. "saken er sensitiv") og ikke bare returnerer en generisk feilmelding. Team eessipensjon / EUX-plattformteam.
- [ ] **Sammenstilte oversikter (SK4):** Bekreftes at saksoversikter i saksbehandlergrensesnittet faktisk filtrerer bort sensitive saker for saksbehandlere uten riktig rolle, og ikke bare skjuler innholdet. Team eessipensjon.
- [ ] **Deling av adresse (SK5) — BEKREFTET AVVIK:** Koden i PrefillPDLAdresse sjekker kun FORTROLIG og STRENGT_FORTROLIG — men IKKE STRENGT_FORTROLIG_UTLAND. Brukere med strengt fortrolig adresse utland kan ha adresse i PDL som i dag forhåndsutfylles i utgående SED-er. Avviket bør lukkes. Team eessipensjon.
- [ ] **Geolokaliserende opplysninger (SK6):** Kartlegges hvilke felter i SED-er som kan inneholde geolokaliserende opplysninger utover adresse (f.eks. arbeidsgiver, trygdetilhørighet), og om det er mulig/ønskelig å utelate disse for adressebeskyttede brukere. Team eessipensjon / faggruppe pensjon.

## K253.1 – Visning av personopplysninger skal skrives til oppslagslogg (Arcsight)

- [ ] **Innsynsrapporter (SK5):** Avklares med Team Auditlogging Arcsight om EESSI Pensjon skal inkluderes i innsynsrapportene til innbyggere og ledere, og hvordan løsningen skal navngis og beskrives i rapporten. Team eessipensjon / Team Auditlogging Arcsight.
- [ ] **Formatbekreftelse (SK6):** Bekreftes med Team Auditlogging Arcsight at oppslagsloggene fra EESSI Pensjon er mottatt på riktig format i produksjon. Team eessipensjon / Team Auditlogging Arcsight.
- [ ] **Logging fra saksbehandling-api (SK1):** Avklares om saksbehandling-api eksponerer personopplysninger direkte til frontend som burde vært logget til oppslagsloggen, eller om all personvisning går via fagmodul (som allerede logger). Team eessipensjon.

## K245.1 – Krav til risikovurdering for applikasjoner, systemer og plattformer

- [ ] **Verdivurdering (SK1):** Bekreftes om det er gjennomført en formell verdivurdering av EESSI Pensjon etter verdivurderingsmalen, og om lenken er delt med HSB. Team eessipensjon.
- [ ] **Trusselmodellering (SK2):** Bekreftes om det er gjennomført en formell trusselmodellering (DFD + STRIPED/STRIDE) etter sikkerhetsmalen, utover den eksisterende arkitekturdokumentasjonen. Team eessipensjon / Team AppSec.
- [ ] **Sikkerhetsrisikovurdering (SK3):** Avhenger av SK1 — dersom verdien er Høy eller Svært Høy, skal en sikkerhetsrisikovurdering gjennomføres. Bekreftes om dette er gjort. Team eessipensjon / HSB.
- [ ] **Rutiner for oppdatering (SK4):** Bekreftes om teamet har en formell rutine (f.eks. årshjul eller som del av sprint-review) for å vurdere om sikkerhetsassessmentene er oppdaterte. Team eessipensjon.
- [ ] **Lagring (SK5):** Bekreftes hvor eventuelle verdi-, trussel- og risikovurderinger er lagret, og om lenke er delt med HSB. Team eessipensjon.

## K115.1 – Behandling som benytter automatisering oppfyller vilkårene for dette

- [ ] **Behandlingskatalogen (SK1):** Bekreftes at EESSI Pensjon sine automatiserte behandlingsaktiviteter er dokumentert i Behandlingskatalogen. Team eessipensjon / personvernrådgiver.
- [ ] **Kravinitialisering (SK1):** Avklares om kravinitialisering (der EESSI Pensjon automatisk sender krav til PESYS basert på mottatt SED) betraktes som del av en helautomatisk avgjørelseskjede, eller om det kun er en administrativ videresending. Team eessipensjon / PESYS-teamet.
- [ ] **Dødsmelding (SK1):** Avklares om automatisk utsendelse av H070 SED ved dødsfall (uten saksbehandlers involvering) kan betraktes som en helautomatisk avgjørelse, gitt at den utløser prosesser i andre lands trygdemyndigheter. Team eessipensjon / juridisk.

## K187.1 – Den registrerte skal ha tilstrekkelig informasjon om behandlingen når Nav fatter automatiske avgjørelser

- [ ] **Avhengighet av K115.1 (SK1, SK2, SK3):** Vurderingen av K187.1 bygger på konklusjonen i K115.1 om at EESSI Pensjon ikke fatter helautomatiske avgjørelser. Dersom kravinitialisering eller dødsmelding reklassifiseres som del av en helautomatisk avgjørelseskjede, vil informasjonsplikten i K187.1 også gjelde for EESSI Pensjon. Se åpne spørsmål under K115.1.