# ORVION INDUSTRY REFERENCES

Status: **Permanent evidence library.** External sources used to validate/challenge architectural findings (pipeline Stage 3). Every accepted finding that relied on external evidence cites a row here. Never delete; add rows as reviews consult new sources. Sources are pointers — verify against the live source before a high-stakes decision (the ecosystem moves).

Last updated: 2026-07-11.

| Ref | Topic | What it establishes | Findings it supports/challenges | Consulted |
|---|---|---|---|---|
| R-01 | Money in PostgreSQL — [Crunchy Data](https://www.crunchydata.com/developers/playground/working-with-money-in-postgres), [The New Stack](https://thenewstack.io/what-data-type-should-you-use-for-storing-monetary-values_2/) | `NUMERIC` is the standard for money; define precision/scale explicitly; store currency alongside amount | Supports **DC-1** (scale must cover currency decimal_places) | 2026-07-10 |
| R-02 | ERP multi-currency — [Acumatica currency mgmt](https://www.cloud9erp.com/acumatica-financial-management/currency-management/) | ERPs configure decimal places **per currency**; rounding honors it | Supports **DC-1** (per-currency rounding), **DC-11** (FX) | 2026-07-10 |
| R-03 | GDPR vs immutable audit — [Michiel Rook](https://www.michielrook.nl/2017/11/forget-me-please-event-sourcing-gdpr/), [Axiom](https://axiom.co/blog/the-right-to-be-forgotten-vs-audit-trail-mandates) | Reconcile erasure with immutable logs via **pseudonymization / crypto-shredding**; legal-basis retention can override erasure | Supports **DC-4** (events already ID-based → erasure-safe boundary); tempers **DC-6/DC-25** (retention has legal basis) | 2026-07-10 |
| R-04 | Saudi PDPL 2026 — [DLA Piper](https://www.dlapiperdataprotection.com/?c=SA), [ICLG SA 2025-26](https://iclg.com/practice-areas/data-protection-laws-and-regulations/saudi-arabia), [Clyde & Co](https://www.clydeco.com/en/insights/2026/03/enforcement-of-the-saudi-pdp-law) | PDPL **enforced**; data in-Kingdom by default; cross-border restricted; fines to **SAR 5M/breach** | Raised **DC-22**; but jurisdiction applicability to Egyptian tenants is **unresolved** → moved DC-22 to PENDING | 2026-07-11 |
| R-05 | UUIDv7 vs v4 in Postgres — [Umang Sinha benchmark](https://www.umangsinha.in/blog/postgresql-uuid-performance-benchmark), [uuidv7 in PG18 (DEV)](https://dev.to/devopsdaily/stop-using-random-uuids-as-primary-keys-uuidv7-lands-in-postgresql-18-5fim), [SayBackend](https://saybackend.com/blog/uuidv7-postgres-comparison/) | v4 fine until **millions of rows/table**, then page-split/bloat; v7 ≈ BIGINT locality; native `uuidv7()` in **PG18** (~4% of v4 gen cost) | **Challenged DC-13** → deferred (Supabase=PG17; SME scale) | 2026-07-11 |

## Reference gaps to fill in future reviews (Stage 3 not yet done)
- **Egypt PDPL (Law 151/2020)** applicability + data-transfer rules — needed to resolve DC-22. *(No search performed yet.)*
- **Google Ads Data Manager API + Consent Mode** current spec — needed for Batch-3 delivery design (cited in audit A3 as of 2026; re-verify at build).
- **WhatsApp Cloud API** 24-hour window + template categories — needed for Engagement build (deferred to Batch 5).
- **IATA BSP / ADM** current process — needed for BF-7 build.
- **TOMS / GCC VAT margin scheme** current rates/rules — needed for BF-4 build.
- **Vertical-SaaS custom-field posture** (opinionated vs extensible) — would inform DC-20/DC-24.

Each gap is tied to a finding; fill the reference when that finding's build is scheduled (avoid researching ahead of need — but never suppress the design).
