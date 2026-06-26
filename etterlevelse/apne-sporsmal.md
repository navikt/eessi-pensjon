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

- [ ] **Verdivurdering (SK1):** Bekreftes om det er gjennomført en formell verdivurdering av EESSI Pensjon etter verdivurderingsmalen, og om lenken er delt med HSB. Team eessipensjon. _Kommentar: Jeg kan ikke finne denne vurderingen_
- [ ] **Trusselmodellering (SK2):** Bekreftes om det er gjennomført en formell trusselmodellering (DFD + STRIPED/STRIDE) etter sikkerhetsmalen, utover den eksisterende arkitekturdokumentasjonen. Team eessipensjon / Team AppSec.
- [ ] **Sikkerhetsrisikovurdering (SK3):** Avhenger av SK1 — dersom verdien er Høy eller Svært Høy, skal en sikkerhetsrisikovurdering gjennomføres. Bekreftes om dette er gjort. Team eessipensjon / HSB.
- [ ] **Rutiner for oppdatering (SK4):** Bekreftes om teamet har en formell rutine (f.eks. årshjul eller som del av sprint-review) for å vurdere om sikkerhetsassessmentene er oppdaterte. Team eessipensjon.
- [ ] **Lagring (SK5):** Bekreftes hvor eventuelle verdi-, trussel- og risikovurderinger er lagret, og om lenke er delt med HSB. Team eessipensjon.

## K115.1 – Behandling som benytter automatisering oppfyller vilkårene for dette

- [x] **Behandlingskatalogen (SK1):** Bekreftes at EESSI Pensjon sine automatiserte behandlingsaktiviteter er dokumentert i Behandlingskatalogen. Team eessipensjon / personvernrådgiver.
- [x] **Kravinitialisering (SK1):** Avklares om kravinitialisering (der EESSI Pensjon automatisk sender krav til PESYS basert på mottatt SED) betraktes som del av en helautomatisk avgjørelseskjede, eller om det kun er en administrativ videresending. Team eessipensjon / PESYS-teamet.
- [x] **Dødsmelding (SK1):** Avklares om automatisk utsendelse av H070 SED ved dødsfall (uten saksbehandlers involvering) kan betraktes som en helautomatisk avgjørelse, gitt at den utløser prosesser i andre lands trygdemyndigheter. Team eessipensjon / juridisk.

## K187.1 – Den registrerte skal ha tilstrekkelig informasjon om behandlingen når Nav fatter automatiske avgjørelser

- [x] **Avhengighet av K115.1 (SK1, SK2, SK3):** Vurderingen av K187.1 bygger på konklusjonen i K115.1 om at EESSI Pensjon ikke fatter helautomatiske avgjørelser. Dersom kravinitialisering eller dødsmelding reklassifiseres som del av en helautomatisk avgjørelseskjede, vil informasjonsplikten i K187.1 også gjelde for EESSI Pensjon. Se åpne spørsmål under K115.1.

## K231.1 – Språket i løsningen er klart, korrekt og brukertilpasset

- [ ] **Brukertest av språk (SK2):** Bekreftes om det er gjennomført strukturert brukertesting som spesifikt undersøker om språket i grensesnittet er forståelig og om saksbehandlerne finner fram og får løst oppgaven – utover den løpende, uformelle tilbakemeldingen fra fagmiljøet. Team eessipensjon. _Kommentar: teamet har i portalen markert dette kriteriet som «Ikke relevant» da løsningen fungerer tilfredsstillende og brukertesting ikke er aktuelt per nå._
- [ ] **Kontakt med klarspråk-fagmiljø (SK3):** Bekreftes om teamet faktisk har vært i kontakt med Nav sitt fagmiljø for klarspråk om konkrete språkspørsmål i EESSI Pensjon, eller om kanalen kun er tilgjengelig og ikke benyttet. Team eessipensjon.

## K104.1 – Personopplysninger skal kunne slettes

- [ ] **Mellomlagring i GCP Storage (SK1):** Bekreftes om GCP Storage-bøttene har automatiske livssyklusregler (retention/lifecycle policies) som sletter mellomlagrede SED-dokumenter etter en definert periode, og hva denne perioden er. Team eessipensjon.
- [ ] **Prosedyre for sletting (SK1):** Avklares om teamet har en dokumentert prosedyre for å håndtere en forespørsel om sletting fra Nav sin sletteenhet — herunder hvordan man identifiserer og fjerner data knyttet til en bestemt person fra GCP Storage. Team eessipensjon.
- [ ] **EESSI-mekanisme for varsling (SK2):** Bekreftes hvilken konkret mekanisme i EESSI-regelverket som benyttes for å varsle mottakerlandet om at personopplysninger i en tidligere sendt SED skal slettes. Team eessipensjon / faggruppe pensjon.

## K105.1 – Det må tilrettelegges for dataportabilitet av personopplysninger

- [ ] **Håndtering av forespørsler (SK2):** Bekreftes at Nav sin sentrale innsyns-/rettighetsenhet håndterer eventuelle forespørsler om dataportabilitet, og at EESSI Pensjon ikke trenger en egen prosedyre utover å henvise videre. Team eessipensjon / Nav personvern.

## K103.2 – Personopplysninger skal kunne rettes

- [ ] **Korrigering av sendte SED-er (SK2, SK3):** Bekreftes hvilken konkret prosedyre som gjelder i EESSI-regelverket for å korrigere feilaktige opplysninger i en allerede sendt SED — om det sendes en ny SED, eller om det håndteres via meldingsutveksling i BUC-en. Team eessipensjon / faggruppe pensjon.
- [ ] **Varsling via PDL (SK3):** Bekreftes at PDL har egne mekanismer for å videreformidle rettinger til sine konsumenter, slik at EESSI Pensjon ikke har et selvstendig ansvar for å varsle andre Nav-systemer om rettinger mottatt fra utlandet. Team eessipensjon / PDL-teamet.
## K219.1 – IT-løsninger skal avlevere data slik at det lages offisiell statistikk, sentral styringsinformasjon og analyser

- [ ] **Avklart datainnhold (SK1):** Bekreftes om innholdet og omfanget av dataene EESSI Pensjon avleverer til datavarehuset er avklart med Statistikkseksjonen og Styringsinformasjon, eller om avleveringen i dag dekker teamets eget behov uten en slik formell avklaring. Team eessipensjon / Statistikkseksjonen.
- [ ] **Behov for EESSI-spesifikk statistikk (SK3, SK4):** Avklares om volum- og flyttall for SED-utvekslingen (antall SED-er per BUC og land, behandlingstid m.m.) skal inngå i sentral styringsinformasjon og analyser, eller om behovet dekkes av fagsystemenes egne avleveringer. Styrings- og statistikkmiljøet / berørte fagavdelinger.

## K154.1 – Nav må overholde taushetsplikten

- [ ] **Taushetspliktsvurdering (SK1):** Bekreftes om det finnes en dokumentert, konkret faglig vurdering av hvilke taushetspliktsregler som gjelder for EESSI Pensjon og overfor hvem, eller om dette utelukkende dekkes av de generelle vurderingene for pensjonsområdet. Team eessipensjon / Juridisk avdeling / fagansvarlige per ytelse.
- [x] **Behandlingskatalogen (SK4):** Bekreftes at utveksling av taushetsbelagte trygdeopplysninger med andre EU/EØS-land er registrert i Behandlingskatalogen, og hvor registreringen ligger. Team eessipensjon.

## K251.1 – Barnets beste skal være et grunnleggende hensyn i alle saker og avgjørelser som berører barn

- [x] **Barnets beste-vurdering på systemnivå (SK2):** Bekreftes om det er gjort og dokumentert en overordnet barnets beste-vurdering for hvordan EESSI Pensjon formidler opplysninger i saker om barnepensjon og etterlatteytelser, eller om barnets beste utelukkende vurderes i fagsystemet i den enkelte sak. Team eessipensjon / fagansvarlige for etterlatteytelser.

## K268.1 – Nav følger reglene, standardene, føringene og prinsippene i EØS-avtalen

- [x] **Dokumentert EØS-vurdering (SK1):** Bekreftes om det finnes en dokumentert vurdering på systemnivå av at EESSI Pensjon følger EØS-regelverket og ikke forskjellsbehandler EØS-borgere, eller om dette utelukkende dekkes av at løsningen følger de felles EESSI-standardene og av likebehandlingsvurderingene som gjøres i fagsystemet per sak. Team eessipensjon / Juridisk avdeling / styringsseksjonen i fagavdelingen.

## K196.6 – Løsningen oppfyller alle A- og AA-krav i WCAG 2.1

- [ ] **WCAG-samsvar (SK1):** Bekreftes at de pensjonsspesifikke skjermbildene som er bygget utover standard Aksel-komponenter faktisk oppfyller WCAG 2.1 nivå A og AA, gjennom en dokumentert manuell gjennomgang av løsningen. Team eessipensjon / fagmiljøet for universell utforming.
- [ ] **Automatiserte uu-tester (SK2):** Avklares om saksbehandlerløsningen skal ta i bruk automatiserte uu-tester i byggeprosessen (f.eks. axe/jest-axe og uu-linting, jf. https://github.com/navikt/uu-testing). Dette er en anbefaling, ikke et lovkrav. Team eessipensjon.

## K197.1 – Dere tester om løsningen fungerer for flest mulig i praksis

- [ ] **Testing med hjelpemidler (SK1):** Avklares om teamet skal etablere en fast rutine for å teste EESSI Pensjon med simulatorer og hjelpemidler (skjermleser, empatilab, ekspert-testing fra uu-teamet). Team eessipensjon / uu-teamet.
- [ ] **Brukertesting (SK2):** Avklares om og hvordan løsningen skal brukertestes med reelle personer med variert funksjonsnivå, gitt at den er et internt saksbehandlerverktøy. Team eessipensjon / uu-teamet ("test min løsning").

## K101.2 – Overføring av personopplysninger til utlandet må være lovlig

- [x] **Tredjeland (SK1, SK2):** Bekreftes at all utveksling i EESSI Pensjon skjer med EU/EØS-land, og at det ikke utveksles med land utenfor EU/EØS (f.eks. Sveits eller andre avtaleland i EESSI-sammenheng) som ville utløse tredjelandsvurdering. Team eessipensjon / faggruppe pensjon. _Kommentar: teamet har tidligere markert kriteriet som «Ikke relevant – overføres kun innad i EU»._

## K102.3 – Det må fastsettes et klart formål før innsamling og behandling av personopplysninger

- [ ] **Formål i Behandlingskatalogen (SK1):** Bekreftes at formålet med behandlingen i EESSI Pensjon er registrert og oppdatert i Behandlingskatalogen. Team eessipensjon / personvernrådgiver.
- [ ] **Avlevering til datavarehus (SK2):** Bekreftes at data som avleveres til datavarehuset for statistikk-/styringsformål er aggregert eller avidentifisert, slik at viderebruken er forenlig med innsamlingsformålet. Team eessipensjon / Statistikkseksjonen. _Se også åpne spørsmål under K219.1._

## K107.2 – Behandling av personopplysninger må være lovlig

- [ ] **Dokumentert vurdering (SK2):** Bekreftes hvor den skriftlige vurderingen av valg av behandlingsgrunnlag for pensjonsformålene er dokumentert (Behandlingskatalogen / Public 360), og at den er oppdatert. Team eessipensjon / Juridisk avdeling.

## K108.2 – Den registrerte skal informeres om hvordan Nav behandler personopplysninger

- [ ] **Informasjon i personvernerklæringen (SK1, SK2):** Bekreftes at personvernerklæringen på nav.no og fagsystemets brukerdialog faktisk dekker at trygdeopplysninger utveksles med andre EU/EØS-land, inkludert hvilke kategorier opplysninger og kilder som inngår. Team eessipensjon / Juridisk avdeling.

## K111.1 – Behandling av personopplysninger skal være nødvendig og proporsjonal

- [ ] **Nødvendighet av saksbehandlervalg (SK1):** Avklares hvordan det sikres at saksbehandlers valg av vedlegg og fritekst i SED-er ikke medfører at flere opplysninger enn nødvendig sendes, gitt at det kan være uklart hvilke opplysninger den enkelte trygdemyndighet trenger. Team eessipensjon / faggruppe pensjon.
- [ ] **Dokumentert vurdering (SK1, SK2):** Bekreftes hvor nødvendighets- og forholdsmessighetsvurderingen per ytelse er dokumentert. Team eessipensjon / Juridisk avdeling.

## K113.2 – Den registrerte har krav på innsyn i hvilke personopplysninger Nav har registrert

- [ ] **Innsynsrutine (SK1):** Bekreftes at Nav Kontaktsenter er informert om EESSI Pensjon som løsning med personopplysninger (e-post med emne «K113.2 Innsyn»), og at teamet har en dokumentert rutine for å finne igjen og hente ut opplysninger om en bestemt person fra mellomlagringen ved en innsynsforespørsel. Team eessipensjon.

## K116.1 – Behandling av personopplysninger må kunne begrenses

- [ ] **Begrensning i mellomlagring (SK1):** Bekreftes at teamet teknisk kan stanse videre bruk (begrense) av opplysninger om en bestemt person i den midlertidige mellomlagringen, og at Nav sin felles retningslinje for retting, sletting og begrensning dekker EESSI Pensjon. Team eessipensjon.
- [ ] **Varsling til mottakerland (SK2):** Bekreftes hvilken mekanisme i EESSI-samarbeidet som benyttes for å varsle et mottakerland om at opplysninger i en tidligere sendt SED er begrenset. Team eessipensjon / faggruppe pensjon. _Se også tilsvarende punkt om sletting under K104.1._

## K190.2 – Behandlingsansvar og databehandlerrelasjon er avklart og dokumentert

- [ ] **Tredjepartsrelasjoner i Behandlingskatalogen (SK1):** Bekreftes at relasjonene til andre lands trygdemyndigheter og til Nav sine fellesløsninger er dokumentert i Behandlingskatalogen for EESSI Pensjon. Team eessipensjon / personvernrådgiver.

## K191.1 – Lagringstid skal være avklart for alle personopplysninger Nav behandler

- [ ] **Lagringstid dokumentert (SK1, SK2):** Bekreftes at lagringstid og begrunnelse for pensjonsformålene er registrert i Behandlingskatalogen og i lagringstidsskjemaet på Confluence, og at EESSI Pensjon kan vise til disse. Team eessipensjon / fagansvarlige per ytelse.
- [ ] **Sletting i mellomlagring (SK3):** Bekreftes at mellomlagrede dokumenter har en definert, automatisk levetid (lifecycle-regler) slik at de slettes rutinemessig. Team eessipensjon. _Samme antagelse som under K104.1._

## K262.1 – Det må tilrettelegges for at den registrerte kan protestere mot behandling av personopplysninger

- [ ] **Stans av behandling (SK2):** Bekreftes at teamet teknisk kan stanse videre bruk av opplysninger om en bestemt person i mellomlagringen, og at Nav sin felles retningslinje dekker EESSI Pensjon. Team eessipensjon. _Samme antagelse som under K116.1 (SK1)._
- [ ] **Informasjon om protestrett (SK3):** Bekreftes at personvernerklæringen/fagsystemets brukerdialog uttrykkelig informerer om retten til å protestere på de områdene der rettigheten er aktuell. Team eessipensjon / Juridisk avdeling.

## Tverrgående antagelser – Arkiv og dokumentasjon

- [ ] **Ansvarsdeling arkiv (Generelt):** Besvarelsene for arkivkravene legger til grunn at den arkivpliktige dokumentasjonen i EESSI Pensjon er trygdedokumentene (SED-er), at disse journalføres automatisk til Joark som dermed er arkiv av record, og at løsningens egen skylagring kun er midlertidig mellomlagring/arbeidstilstand som ikke er arkiv. Bekreftes at denne forståelsen er riktig, og at det ikke finnes arkivpliktig dokumentasjon i mellomlagringen som ikke også journalføres til Joark eller forvaltes i RINA. Team eessipensjon / Team Dokumentasjonsstyring.
- [ ] **Formell arkivavklaring (Generelt):** Bekreftes at det er gjort en formell avklaring med Team Dokumentasjonsstyring om hvordan EESSI Pensjon sin dokumentasjon skal forvaltes, og at avgrensningen mot Joark og RINA er dokumentert. Team eessipensjon / Team Dokumentasjonsstyring.

## K130.2 – Dokumentasjonen og databasen er lagret i Norge

- [x] **Lagringssted (SK1):** Bekreftes at den midlertidige mellomlagringen (skylagring) ligger i Norge eller er akseptabel etter arkivloven gitt at den ikke er arkiv av record, og at all arkivpliktig dokumentasjon faktisk havner i Joark som lagrer i Norge. Team eessipensjon / Team Dokumentasjonsstyring.

## K230.2 – Dokumentasjonen skal kunne avleveres og slettes til rett tid

- [x] **Bevarings- og kassasjonsvedtak (SK1):** Bekreftes at de journalførte trygdedokumentene fra EESSI Pensjon dekkes av eksisterende bevarings- og kassasjonsvedtak for pensjonsområdet, eller om det trengs et eget vedtak fra Nasjonalarkivet. Team eessipensjon / Team Dokumentasjonsstyring.
- [x] **Lagringstid (SK2):** Bekreftes at fastsatt lagringstid for pensjonsområdets arkiv dekker EESSI-dokumentasjonen, og at mellomlagrede dokumenter har definerte livssyklusregler. Team eessipensjon / Team Dokumentasjonsstyring. _Se også K104.1/K191.1 om livssyklusregler i mellomlagringen._
- [x] **Begrense tilgang til historisk dokumentasjon (SK3):** Avklares om EESSI Pensjon kaller Joark sin tjeneste for å avslutte sak (avsluttsak) når en sak er ferdigbehandlet, slik at historisk dokumentasjon skjermes, eller om dette håndteres av andre. Team eessipensjon / Team dokumentløsninger. _Kommentar: Dette skal håndteres av Pesys._

## K269.1 – Team skal avklare hvordan deres data og dokumentasjon skal forvaltes

- [x] **Arkivavklaring (SK1):** Se tverrgående punkt «Formell arkivavklaring» over. Bekreftes konklusjonen om at SED-er er arkivpliktige og journalføres til Joark, mens mellomlagringen ikke er arkiv. Team eessipensjon / Team Dokumentasjonsstyring.

## K270.1 – Systemet skal oppfylle grunnleggende arkivkrav

- [x] **Arkivkrav dekket av Joark (SK1–SK5):** Besvarelsene legger til grunn at Joark ivaretar de grunnleggende arkivkravene (opphav/kontekst, frysing, sporing, gjenfinning, bevaringsvennlig format) for de journalførte trygdedokumentene. Bekreftes at dette er en gyldig avgrensning for EESSI Pensjon. Team eessipensjon / Team Dokumentasjonsstyring.

## K271.1 – Systemet skal være dokumentert

- [ ] **Systemdokumentasjon (SK1, SK2):** Bekreftes at systemdokumentasjonen faktisk beskriver hvilke typer dokumentasjon løsningen håndterer, opphav/historikk og informasjonsstrukturen, og hvor denne dokumentasjonen er lagret og tilgjengelig. Team eessipensjon.

## K273.1 – Journalpliktig dokumentasjon skal journalføres

- [x] **Taushetsplikt i offentlig journal (SK4):** Bekreftes at skjerming av taushetsbelagte opplysninger i offentlig journal fullt ut ivaretas av Joark for de journalførte trygdedokumentene, og at EESSI Pensjon ikke har et selvstendig ansvar utover å markere sensitive saker. Team eessipensjon / Team dokumentløsninger.

## K274.1 – Feil i dokumentasjonen må kunne rettes

- [x] **Korrigeringsmekanisme (SK1, SK2):** Bekreftes hvilken konkret mekanisme i EESSI-regelverket som benyttes for å korrigere feil i en allerede sendt SED, og hvor rutinen for retting er dokumentert. Team eessipensjon / faggruppe pensjon. _Samme antagelse som under K103.2._
