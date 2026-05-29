# Åpne spørsmål – etterlevelse

## K267.1 – Applikasjoner skal ha et forsvarlig sikkerhetsnivå

- [ ] **Snyk-rutiner:** Bekreftes at Snyk CLI kjøres regelmessig (ikke bare ad-hoc) og at teamet har en fast rutine for å følge opp funn. Team eessipensjon.
- [ ] **Backend sårbarhetsskanning:** Backend Kotlin-applikasjonene har ikke Dependabot eller dedikert automatisk sårbarhetsskanning i CI (kun UI-appen har Dependabot for npm). Bekreftes at NAIS-plattformens container-skanning (Trivy) dekker dette tilstrekkelig, eller om det bør legges til Dependabot/Snyk for Gradle-avhengigheter. Team eessipensjon.
- [ ] **Secure logs:** Bekreftes at fødselsnummer/aktør-ID faktisk kun logges til sikre logger og aldri lekker til standard applikasjonslogger eller URL-er. Team eessipensjon.
- [ ] **ISOC-tilgang:** Bekreftes at loggene faktisk er tilrettelagt og tilgjengelige for Team ISOC ved hendelser. Team ISOC / plattformteam.
- [ ] **GCP Storage backup:** Bekreftes at GCP Storage-bøttene har versjonering aktivert og at teamet har testet gjenoppretting. Team eessipensjon.
- [ ] **Compliant device / phishing-resistent MFA:** Bekreftes at Wonderwall-oppsettet krever enten compliant device eller phishing-resistent MFA for Nav-ansatte. NAIS-teamet.
- [ ] **Rotasjonsfrekvens hemmeligheter:** Bekreftes at Azure AD-secrets roteres automatisk og hva den faktiske frekvensen er. NAIS-teamet / team eessipensjon.
- [ ] **Fritekstfelt og input-validering:** Saksbehandler-UI har fritekstfelt (TextArea) i P2000 og P8000 SED-skjemaer. Frontend begrenser kun lengde (maxLength). Bekreftes at fagmodul/backend validerer innholdet mot SED-skjema og filtrerer ugyldige tegn før data sendes til RINA. Team eessipensjon.
- [ ] **dangerouslySetInnerHTML:** Error.tsx bruker dangerouslySetInnerHTML for feilbeskrivelse og stacktrace. Bekreftes at description-feltet kun populeres fra oversettelsesnøkler (i18n) og aldri fra brukerinput. Team eessipensjon.

## K255.1 – Nav skal beskytte brukere med adressebeskyttelse

- [ ] **Strengt fortrolig adresse utland i prefill (BEKREFTET AVVIK):** Koden i PrefillPDLAdresse sjekker kun FORTROLIG og STRENGT_FORTROLIG — men IKKE STRENGT_FORTROLIG_UTLAND. Brukere med strengt fortrolig adresse utland kan ha adresse i PDL som i dag forhåndsutfylles i utgående pensjonsdokumenter. Avviket bør lukkes. Team eessipensjon.
- [ ] **Fortrolig adresse (kode 7) og sensitivitetsmarkering:** Begrens-innsyn-sjekken markerer EESSI-saker som sensitive kun for STRENGT_FORTROLIG og STRENGT_FORTROLIG_UTLAND — ikke for FORTROLIG (kode 7). Avklares om dette er tilsiktet, og om brukere med kode 7 likevel er tilstrekkelig beskyttet gjennom at adressefeltet utelates i prefill. Team eessipensjon.
- [ ] **Sensitivitetsmarkering i UI:** Bekreftes at saksbehandlergrensesnittet tydelig viser at en sak involverer en person med adressebeskyttelse (f.eks. med ikon, farge eller banner) — ikke bare at tilgangen avvises. Team eessipensjon / EUX-plattformteam.
- [ ] **Oversiktslister og filtrering:** Bekreftes at saksoversikter i saksbehandlergrensesnittet faktisk filtrerer bort sensitive saker for saksbehandlere uten riktig rolle, og ikke bare skjuler innholdet. Team eessipensjon.
- [ ] **Rolle-sjekk i EP vs. RINA:** Avklares om tilgangskontrollen for adressebeskyttede brukere utelukkende håndheves av RINA/EUX-plattformen, eller om EESSI Pensjon har en egen sjekk mot GA-Fortrolig_Adresse / GA-Strengt_Fortrolig_Adresse i sitt API-lag. Team eessipensjon.
- [ ] **Geolokaliserende opplysninger i SED:** Kartlegges hvilke felter i pensjonsdokumenter (SED) som kan inneholde geolokaliserende opplysninger utover adresse (f.eks. arbeidsgiver, trygdetilhørighet), og om det er mulig/ønskelig å utelate disse for adressebeskyttede brukere. Team eessipensjon / faggruppe pensjon.
- [ ] **Avvisningsmelding fra RINA:** Bekreftes at RINA faktisk gir saksbehandler en forklaring når tilgang avvises (f.eks. "saken er sensitiv") og ikke bare returnerer en generisk feilmelding. Team eessipensjon / EUX-plattformteam.