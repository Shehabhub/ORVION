-- pgTAP invariant: money storage scale vs currency precision (ARB finding DC-1 / R7).
-- Money columns were modeled as numeric(14,2), but currencies.decimal_places reaches 3
-- (KWD/BHD/OMR/JOD), so scale 2 TRUNCATED the minor unit. SPEC-118 widened every monetary
-- column to numeric(19,4) (scale >= the maximum currency precision). This test is now a HARD
-- gate: no monetary numeric column may carry a scale below the highest-precision currency.
create extension if not exists pgtap with schema extensions;

begin;
select plan(1);

-- Money columns carry the numeric(14,2) signature; SPEC-118 widened them all to numeric(19,4).
-- Assert none of that money signature survives below the highest currency precision.
-- quotation_items.quantity is a count (also 14,2) and is deliberately excluded.
select is(
  (select count(*)::int
     from information_schema.columns col
    where col.table_schema = 'public'
      and col.data_type = 'numeric'
      and col.column_name <> 'quantity'
      and col.numeric_precision = 14
      and col.numeric_scale = 2
      and col.numeric_scale < (select max(decimal_places) from currencies)),
  0,
  'No money column stores fewer decimal places than the highest-precision currency');

select * from finish();
rollback;
