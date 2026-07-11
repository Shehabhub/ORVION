-- pgTAP invariant: money storage scale vs currency precision (ARB finding DC-1 / R7).
-- Money columns are modeled as numeric(14,2), but currencies.decimal_places reaches 3
-- (KWD/BHD/OMR/JOD), so those columns TRUNCATE the minor unit. The correct scale is >= the
-- maximum currency precision (fix: numeric(19,4)).
--
-- This is a KNOWN, validated defect whose fix alters built columns and is therefore
-- owner-gated (schema + ADR). Until that fix lands, the assertion is wrapped in a pgTAP
-- todo block: it records the invariant as an executable expectation WITHOUT failing the
-- suite. The owner-gated DC-1 fix CR removes the todo wrapper, turning it into a hard gate.
create extension if not exists pgtap with schema extensions;

begin;
select plan(1);

select todo_start(
  'DC-1: money numeric(14,2) columns cannot represent 3-dp currencies; fix -> numeric(19,4) is owner-gated. See reports/master/MASTER_GAP_REGISTER.md (DC-1 / R7).');

select is(
  (select count(*)::int
     from information_schema.columns col
    where col.table_schema = 'public'
      and col.data_type = 'numeric'
      and col.numeric_precision = 14
      and col.numeric_scale = 2
      and col.numeric_scale < (select max(decimal_places) from currencies)),
  0,
  'No money column stores fewer decimal places than the highest-precision currency');

select todo_end();

select * from finish();
rollback;
