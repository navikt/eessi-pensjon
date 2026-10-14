---
name: sed-model-sync
description: >-
  Audit two-way SED model compatibility between ep-eux and eux-rina-api for a
  user-specified pension SED type such as P2200. Checks template paths, Kotlin
  property types and array/object cardinality for CDM v4.4 and v4.5, and creates
  an HTML report. Use when asked to check, compare, or report SED model mapping.
---

# SED Model Sync Audit

Audit whether an `ep-eux` Kotlin model and the `eux-rina-api` ACL templates
preserve the selected pension SED in both directions:

- Sending: Kotlin model → NAV JSON → EU CDM JSON
- Receiving: EU CDM JSON → NAV JSON → Kotlin model

## Input

Required:

- SED type, for example `P2200`

Optional:

- CDM versions to check: `4.4`, `4.5`, or both. Check both when omitted.

If the SED type is missing, ask the user for it before starting. Validate that
the requested type has a pension template and model. Do not silently substitute
another SED.

## Slash invocation

Invoke this skill by entering its name with a leading slash, followed by the
SED type:

> `/sed-model-sync P2200`

This audits P2200 against v4.4 and v4.5 and writes the report to
`eessi-pensjon/docs/p2200-v44-v45-sync-report.html`.

To select a version:

> `/sed-model-sync P2200 v4.5`

If the skill was added or changed during the current CLI session, run
`/skills reload` first. Check discovery with `/skills info sed-model-sync`.

## Workflow

1. **Locate the selected SED's assets.**
   - Kotlin models and tests:
     `eessi-pensjon/ep-eux/src/main/kotlin/no/nav/eessi/pensjon/eux/model/sed/`
     and `eessi-pensjon/ep-eux/src/test/`
   - ACL templates:
     `eux-rina-api/src/main/resources/sedtemplates/v44/pension/` and/or
     `eux-rina-api/src/main/resources/sedtemplates/v45/pension/`
   - Versioned NAV/EU fixtures and ACL tests:
     `eux-rina-api/src/test/resources/v44/pension/`,
     `eux-rina-api/src/test/resources/v45/pension/`, and the matching
     `PensionAclTest` classes.
   - Read both repositories' `copilot-instructions.md` before making code
     changes in them. Preserve all existing user changes.

2. **Inventory template paths and shapes.**
   - Extract every distinct `$nav.*` and `$pensjon.*` mapping from each selected
     version's template.
   - Count distinct mapped leaf paths by useful model/domain group.
   - Record `[x]` array markers at every segment; distinguish those from
     non-indexed object and scalar paths.
   - Compare v4.4 and v4.5 templates and list version-specific mappings.

3. **Compare paths to Kotlin model types.**
   - Resolve each template path through the selected SED's Kotlin model and
     shared nested models, using source definitions rather than naming
     assumptions.
   - A template segment containing `[x]` must correspond to a Kotlin
     collection at that segment; a non-indexed segment must resolve to a
     single object or scalar.
   - Check leaf property names and types as well as container cardinality.
     Distinguish `List<String>` from `List<DTO>`, enums, dates, and nullable
     scalar fields where relevant.
   - Report unmatched template paths, model properties with no template path,
     incompatible cardinality, and mismatched property names/types separately.
   - Shared nested DTOs can serve multiple path prefixes; follow the complete
     model path for each use.

4. **Verify runtime behavior.**
   - Run the selected SED's relevant `ep-eux` model serialization/deserialization
     test.
   - Run the selected version(s)' focused `eux-rina-api` ACL tests, if the
     local build/test setup allows it.
   - Record exact commands and pass/fail results. If the test does not exercise
     the entire cross-repository flow, state that limitation; do not claim an
     end-to-end round trip passed based on separate repository tests.

5. **Create an HTML report.**
   - Save under `eessi-pensjon/docs/` with a filename that includes the SED and
     checked versions, for example
     `p2200-v44-v45-sync-report.html`.
   - Include total path counts by version, path/type/cardinality results,
     actionable mismatches, version differences, test evidence and limitations.
   - Make path counts clickable, expanding to the exact template leaf paths.
   - Do not mark a version or model as fully compatible when any mapping or
     runtime check is unresolved or failing.

## P12000 reference

For P12000, the specialized model is `P12000.kt` with pension data in
`P12000Pensjon.kt`. For example,
`$pensjon.pensjoninfo.betalingsdetaljer[x]` must resolve to
`Pensjoninfo.betalingsdetaljer: List<Betalingsdetaljer>?`. Check all nested
collections and scalar leaves in the same way; matching property names alone
does not establish compatibility.
