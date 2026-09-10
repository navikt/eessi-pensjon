---
name: new-sed-ui
description: >-
  Wires a new EESSI SED type into eessi-pensjon-saksbehandling-ui when no UI
  exists yet, using the ep-eux DTO model and an existing SED UI as a pattern.
---

# New SED UI

Use this skill when adding the initial UI shell and navigation wiring for a SED
type that is supported by the backend but does not yet have a UI in
`eessi-pensjon-saksbehandling-ui`.

## Input

The user supplies:

- SED type, for example `P12000`
- Optional target branch

Default the lower-case UI identifier to the lower-case SED type, for example
`p12000`.

## Steps

1. **Check the target repositories.**
   - Work in `eessi-pensjon-saksbehandling-ui`.
   - If the user supplies a target branch, check it out.
   - If no target branch is supplied, or the currently checked-out branch is
     `master`, check out `master`, pull the latest `master` from `origin`, then
     create `feature/<SED type>` from it and check it out.
   - Check the working tree before editing. Preserve unrelated user changes.
   - Use `ep-eux` as the source of truth for the backend DTO.

2. **Study the model and an established UI.**
   - Find the SED model in `ep-eux/src/main/kotlin/no/nav/eessi/pensjon/eux/model/sed/`.
   - Read model tests and JSON fixtures when available to confirm serialized
     field names and nesting.
   - Use `P2000` as the default implementation pattern. Use another existing
     SED UI only when it is a closer functional match.

3. **Create the declaration.**
   - Add `src/declarations/<sed-type-lowercase>.d.ts`.
   - Reuse shared types from `src/declarations/sed`.
   - Define interfaces matching the backend JSON model, preserving field names
     and optionality conventions used by the existing declarations.
   - Add the SED type to `PSED` and its lower-case mode to `BUCMode` in
     `src/declarations/app.d.ts`.

4. **Register the SED editor mode.**
   - Add the new mode to the SED-editor branch in both
     `src/applications/BUC/BUCIndexPage.tsx` and
     `src/applications/BUC/BUCIndexPageGjenny.tsx`.
   - In `src/applications/BUC/components/SEDHeader/SEDHeader.tsx`, import the
     new component and add an action for the new SED type. Follow the P2000
     flow: log the button action, call `setMode` with the new mode and component
     content, and scroll to the top.
   - Apply the existing status restrictions used by the comparable SED type.

5. **Create the initial component.**
   - Add `src/applications/<SED type>/<SED type>.tsx`.
   - Define props compatible with P2000:

     ```ts
     buc: Buc
     sed?: Sed
     setMode: (mode: BUCMode, s: string, callback?: () => void, content?: JSX.Element) => void
     ```

   - Render an Aksel level-1 heading containing the SED type.
   - Wire backend loading as in P2000:
     - Define a selector and `mapState` that read the typed SED from
       `state.buc.PSED` and `state.loading.gettingSed`.
     - Reset `PSED` with `useUnmount` when leaving the component.
     - In a `useEffect` triggered by `sed`, reset editing and validation state,
       then dispatch `getSed(buc.caseId!, sed)`.
     - Render `WaitingPanel` while `gettingSed` is true.
   - Add the P2000/P8000-style back button: reset editing state, reset
     validation for the SED namespace, refresh the BUC, then call
     `setMode('bucedit', 'back')`.

6. **Add development mock data.**
   - Add `src/mocks/buc/sed_<SED type>.ts` with data matching the backend JSON
     model, including the SED type, `nav`, and SED-specific `pensjon` fields.
   - Import the mock in `src/actions/buc.ts` and add it to the `sedMocks`
     registry using the key `mock<SED type>`.
   - Keep `getSed` generic: resolve the mock from `mock${sed.type}` and retain
     the existing P2000 fallback for SED types without a dedicated mock.
   - Add an action test verifying that `getSed` selects the new SED mock.

7. **Register translations.**
   - Add the lower-case namespace to `src/i18n.ts`.
   - Create both `public/locales/nb/<sed-type-lowercase>.json` and
     `public/locales/en/<sed-type-lowercase>.json`.
   - Each translation file must contain valid JSON. Use `{}` until the UI has
     translation keys; never leave a registered resource empty.

8. **Validate and report.**
   - Run `git diff --check`.
   - Run the existing `npm run typecheck` command. If it fails because of
     unrelated baseline errors, report that precisely without changing
     unrelated configuration or tests.
   - Do not commit or push unless the user explicitly asks.

## Completion criteria

- The SED type has a DTO declaration based on `ep-eux`.
- The SED can open its initial UI shell from the BUC SED header.
- The shell has a working back button and title.
- Both BUC contexts recognize the mode.
- Registered translation resources are valid JSON.
