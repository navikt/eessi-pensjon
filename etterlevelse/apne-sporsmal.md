# Åpne spørsmål – etterlevelse

## K267.1 – Applikasjoner skal ha et forsvarlig sikkerhetsnivå

- [ ] **Snyk-rutiner:** Bekreftes at Snyk CLI kjøres regelmessig (ikke bare ad-hoc) og at teamet har en fast rutine for å følge opp funn. Team eessipensjon.
- [ ] **Secure logs:** Bekreftes at fødselsnummer/aktør-ID faktisk kun logges til sikre logger og aldri lekker til standard applikasjonslogger eller URL-er. Team eessipensjon.
- [ ] **ISOC-tilgang:** Bekreftes at loggene faktisk er tilrettelagt og tilgjengelige for Team ISOC ved hendelser. Team ISOC / plattformteam.
- [ ] **GCP Storage backup:** Bekreftes at GCP Storage-bøttene har versjonering aktivert og at teamet har testet gjenoppretting. Team eessipensjon.
- [ ] **Compliant device / phishing-resistent MFA:** Bekreftes at Wonderwall-oppsettet krever enten compliant device eller phishing-resistent MFA for Nav-ansatte. NAIS-teamet.
- [ ] **Rotasjonsfrekvens hemmeligheter:** Bekreftes at Azure AD-secrets roteres automatisk og at frekvensen er minst årlig. NAIS-teamet / team eessipensjon.

## K255.1 – Nav skal beskytte brukere med adressebeskyttelse

- [ ] **Strengt fortrolig adresse utland i prefill:** Bekreftes at forhåndsutfylling av pensjonsdokumenter (SED) filtrerer ut adresseopplysninger for brukere med strengt fortrolig adresse utland, som kan ha adresse i PDL (i motsetning til strengt fortrolig som kun har postboks). Team eessipensjon.
- [ ] **Sensitivitetsmarkering i UI:** Bekreftes at saksbehandlergrensesnittet tydelig viser at en sak involverer en person med adressebeskyttelse (f.eks. med ikon, farge eller banner) — ikke bare at tilgangen avvises. Team eessipensjon / EUX-plattformteam.
- [ ] **Oversiktslister og filtrering:** Bekreftes at saksoversikter i saksbehandlergrensesnittet faktisk filtrerer bort sensitive saker for saksbehandlere uten riktig rolle, og ikke bare skjuler innholdet. Team eessipensjon.
- [ ] **Rolle-sjekk i EP vs. RINA:** Avklares om tilgangskontrollen for adressebeskyttede brukere utelukkende håndheves av RINA/EUX-plattformen, eller om EESSI Pensjon har en egen sjekk mot GA-Fortrolig_Adresse / GA-Strengt_Fortrolig_Adresse i sitt API-lag. Team eessipensjon.
- [ ] **Geolokaliserende opplysninger i SED:** Kartlegges hvilke felter i pensjonsdokumenter (SED) som kan inneholde geolokaliserende opplysninger utover adresse (f.eks. arbeidsgiver, trygdetilhørighet), og om det er mulig/ønskelig å utelate disse for adressebeskyttede brukere. Team eessipensjon / faggruppe pensjon.
