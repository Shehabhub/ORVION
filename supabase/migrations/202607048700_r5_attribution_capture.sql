-- R5 (ARB): complete attribution capture for closed-loop offline conversion (Phase 8).
-- Adds iOS / app-campaign Google click IDs (gbraid/wbraid) and Google consent-mode signals
-- to attribution_clicks, plus a first-touch attribution anchor on leads. All additive/nullable.
-- Rationale: click IDs are unrecoverable retroactively, so the columns must exist before
-- Phase-8 lead intake begins writing them. Consent values follow Google consent mode
-- (granted/denied/unspecified); the CHECK permits NULL (not-yet-captured).

alter table public.attribution_clicks
  add column gbraid text,
  add column wbraid text,
  add column consent_ad_user_data text
    constraint attribution_clicks_consent_ad_user_data_check
    check (consent_ad_user_data in ('granted','denied','unspecified')),
  add column consent_ad_personalization text
    constraint attribution_clicks_consent_ad_personalization_check
    check (consent_ad_personalization in ('granted','denied','unspecified'));

alter table public.leads
  add column attribution_click_id uuid
    constraint leads_attribution_click_id_fkey references public.attribution_clicks(id) on delete restrict;

create index leads_attribution_click_id_idx on public.leads(attribution_click_id);
