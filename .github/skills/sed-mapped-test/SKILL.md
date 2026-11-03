---
name: sed-mapped-test
description: >-
  Create or update an ep-eux pension SED HelMappetTest and synthetic NAV JSON
  fixture from a supplied PDF. Takes sedType and pdfFile. Checks v4.4/v4.5 ACL
  mappings, adds PDF-numbered assertions and discrepancy TODOs, and retains
  v4.4 mapping comments only beside TODOs. Use for requests such as making
  P9000HelMappetTest or repeating the mapped-test workflow for another SED.
---

# SED mapped test

Create a field-numbered Kotlin model test and synthetic fixture for a pension
SED. Use the PDF for field meaning and numbering, the versioned ACL templates
for source-to-CDM mappings, and Kotlin source for actual model support.

## Inputs

Exactly two parameters:

- `sedType`: pension SED identifier, for example `P9000`.
- `pdfFile`: path to the supplied PDF, for example `P9000.pdf`.

Resolve relative paths from the workspace. Normalize `sedType` to uppercase.
Confirm the PDF identifies the requested SED and that its model and templates
exist. Ask for missing or ambiguous inputs; do not substitute another SED.

Check both CDM v4.4 and v4.5. Versions are not an additional parameter.

## Outputs and scope

Create or update these files in the `ep-eux` repository:

- `src/test/kotlin/no/nav/eessi/pensjon/eux/model/sed/<SED>HelMappetTest.kt`
- `src/test/resources/sed/<SED>-HelMappet-NAV.json`

Change tests and fixtures only. Do not fix production models or ACL templates,
create an HTML report, stage changes, or commit unless separately requested.
Use `sed-model-sync` for a full compatibility audit or HTML report.

## Workflow

### 1. Inspect and plan

Read applicable repository instructions and check the actual subrepository's
working tree. Preserve staged and unstaged user changes. Read an existing
`HelMappetTest`, the selected SED model, nested DTOs, serialization helpers,
and any existing test or fixture for that SED.

Give a short plan before editing: inventory PDF fields, compare both template
versions with the model, implement the fixture and assertions, then validate.
If the target files already exist, integrate changes rather than overwrite
them with generated output.

### 2. Inventory numbered fields

Extract all PDF pages with an available local tool such as `pdftotext`,
`mutool`, or macOS PDFKit. Keep extraction artifacts outside the repository.
Check page count and all sections, not just the first extracted pages. For
missing or ambiguous content, inspect the PDF visually or use a supplied image.
Do not treat unsuccessful text extraction as evidence that a field is absent.

Cross-check field numbers and code choices against:

```text
eux-rina-api/src/main/resources/sedoversettelser/v44/P/<SED>_oversettelser.json
eux-rina-api/src/main/resources/sedoversettelser/v45/P/<SED>_oversettelser.json
```

Some conditional fields are absent from the printed PDF, and later CDM
versions can add fields. Include relevant template fields, but explicitly
identify numbers obtained only from versioned metadata. Do not claim those
fields were visible in the PDF.

### 3. Resolve mappings independently for each version

Inspect:

```text
eux-rina-api/src/main/resources/sedtemplates/v44/pension/<SED>_v4.4.json
eux-rina-api/src/main/resources/sedtemplates/v45/pension/<SED>_v4.5.json
ep-eux/src/main/kotlin/no/nav/eessi/pensjon/eux/model/sed/
```

Inventory each full source expression and its CDM destination. Resolve every
segment through the selected Kotlin model, including inheritance,
`@JsonProperty`, ignored properties, custom getters/setters, enums and
collection cardinality. A path existing on a shared DTO is not enough:
it must be reachable through the selected SED.

Use the real Kotlin accessor in assertions. For example, JSON `nav` can be
`navP2200`, and JSON `pensjon` can be `p4000Pensjon`. Preserve JSON property
names in the fixture and mapping expressions in comments.

Compare PDF meaning as well as property existence. Flag suspicious source
choices, misspellings, indexed sources feeding scalar destinations, and
different source lists supplying fields of one destination item. Distinguish
confirmed missing paths from semantic or runtime review points.

Do not assume the versions are identical. Document version differences without
calling every difference a bug. CDM `.value[x]` code wrappers do not by
themselves imply a collection in the NAV model.

### 4. Build the fixture

Use synthetic data only; never copy personal data from the PDF or existing
fixtures. Use distinct values for fields vulnerable to swapping, especially
start/end dates, entitlement/payment dates, gross/net/component amounts,
current/birth names, and version-specific sources.

Populate supported fields and use valid model enum values and serialized codes.
Exercise repeating collections with at least two distinguishable entries,
including nested collections where applicable. Make collection order observable.
Keep competing conditional branches clearly understood as a serialization
fixture, not necessarily a valid business submission.

Exclude unsupported JSON properties rather than relying on Jackson to ignore
them. Account for defaults, inherited serialized fields, compatibility getters,
and non-empty serialization so strict round-trip comparison is meaningful.

### 5. Write the test and comments

Use JUnit and existing JSON helpers. Split assertions into useful PDF/domain
sections. Extract named locals for object paths used more than twice.
Assert expected values rather than using null assertions for missing support.

Before each field assertion, include its PDF number and readable field label.
Include the exact source-to-CDM mapping for v4.5 where applicable.
**Keep `// Mapping (ACL v4.4):` comments only in assertion/comment blocks
containing a `//TODO:`.** A v4.4-only field still needs its version and source
documented; do not mislabel it as v4.5.

Example:

```kotlin
// 5.1.4 Article concerning limitation of overlapping
// Mapping (ACL v4.4): $pensjon.sak.reduksjon[x].artikkeltype -> P6000.Reductions.ReductionsPension[x].articleConcerningLimitationRuleOverlapping.value[x]
// Mapping (ACL v4.5): $pensjon.sak.reduksjon[x].artikkeltype -> P6000.Reductions.ReductionsPension[x].articleConcerningLimitationRuleOverlapping.value[x]
//TODO: 5.1.4 Verify index alignment with pensjon.reduksjon[x], which supplies the other reduction fields.
assertEquals("01", reduction?.artikkeltype)
```

Place discrepancy TODOs beside the specific affected assertions, not in a
detached summary. Use the exact `//TODO:` prefix, field number, and an
actionable explanation. Preserve both version mappings beside the TODO.
For unsupported fields with no possible assertion, put numbered TODOs and
mapping comments in the relevant section without creating an empty test.

A supported model property may be tested despite an unresolved ACL spelling
or source choice. Label it **model-only**, show the broken ACL mapping, and
do not imply the assertion executes or validates the ACL.

Add a strict JSON round-trip test using the repository's serialization helper
and `JSONAssert.assertEquals(expected, serialized, true)`. This must cover
populated fields, collection sizes and order. Explain in the class comment
that these are model JSON tests, not cross-repository runtime ACL tests.

### 6. Validate and hand off

Check every numbered PDF/template leaf has an assertion or an explicit TODO.
Check each assertion's actual accessor, alias, expected value and fixture path.
Verify every populated fixture leaf is exercised, collection entries are
distinguishable, and only TODO blocks retain v4.4 mapping comments.
Verify source names, serialized names and version-specific comments separately;
generated inventories alone are not proof that generated code is correct.

Run the smallest existing Gradle test selection for `<SED>HelMappetTest`,
including compilation, and check the diff for unintended changes. If blocked
by the environment, report the actual blocker and do not claim compilation,
runtime success, or full ACL compatibility based on static checks.

Finish with created/updated paths, meaningful discrepancies, and any unresolved
execution blocker. Leave unrelated user changes untouched.
