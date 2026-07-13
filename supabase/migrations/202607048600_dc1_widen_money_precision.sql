-- DC-1 / R7: widen monetary columns numeric(14,2) -> numeric(19,4).
-- numeric(14,2) truncates the minor unit of 3-decimal currencies (KWD/BHD/OMR/JOD),
-- where currencies.decimal_places = 3. Scale 4 covers every ISO 4217 minor unit (max 4,
-- e.g. CLF) with headroom; precision 19 preserves >= 15 integer digits.
-- Scope: monetary amount columns only. quotation_items.quantity (a count) and
-- exchange_rates.exchange_rate (numeric(18,8), rate precision) are deliberately unchanged.
-- Widening is loss-free; existing CHECK constraints (non-negative, debit-xor-credit) remain
-- valid and are preserved by ALTER COLUMN TYPE. See reports/master/MASTER_GAP_REGISTER.md (DC-1/R7).

alter table public.booking_item_passengers alter column cost_amount_override    type numeric(19,4);
alter table public.booking_item_passengers alter column selling_amount_override type numeric(19,4);
alter table public.booking_items           alter column cost_amount             type numeric(19,4);
alter table public.booking_items           alter column selling_amount          type numeric(19,4);
alter table public.campaign_daily_metrics  alter column revenue_amount          type numeric(19,4);
alter table public.campaign_daily_metrics  alter column spend_amount            type numeric(19,4);
alter table public.company_assets          alter column purchase_amount         type numeric(19,4);
alter table public.financial_accounts      alter column opening_balance         type numeric(19,4);
alter table public.invoices                alter column total_amount            type numeric(19,4);
alter table public.journal_entry_lines     alter column credit_amount           type numeric(19,4);
alter table public.journal_entry_lines     alter column debit_amount            type numeric(19,4);
alter table public.leads                   alter column expected_value          type numeric(19,4);
alter table public.offline_conversions     alter column conversion_value        type numeric(19,4);
alter table public.payment_allocations     alter column allocated_amount        type numeric(19,4);
alter table public.payment_allocations     alter column allocated_amount_invoice_currency type numeric(19,4);
alter table public.payments                alter column amount                  type numeric(19,4);
alter table public.quotation_items         alter column total_amount            type numeric(19,4);
alter table public.quotation_items         alter column unit_price              type numeric(19,4);
alter table public.quotations              alter column total_amount            type numeric(19,4);
alter table public.refunds                 alter column amount                  type numeric(19,4);
alter table public.suppliers               alter column credit_limit_amount     type numeric(19,4);
