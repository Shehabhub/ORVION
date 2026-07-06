-- Migration: seed_currencies
-- Reference-data layer (earned by Phase 5 Booking Core: booking_items.currency_code is NOT NULL and
-- references currencies(code), and the table was empty). currencies is a global system-reference table
-- (no tenant_id; read-all for authenticated, writes are platform/migration only per the RLS baseline),
-- so it is seeded here exactly like the system catalogs. Curated set: widely-used majors + the
-- travel/GCC/MENA currencies ORVION most needs. decimal_places is set correctly per ISO 4217 (JPY = 0;
-- KWD/BHD/OMR/JOD = 3) because Finance Core will rely on it for money handling. Idempotent.
-- Scope: currencies only -- countries/nationalities/languages remain deferred until a hard requirement
-- earns them (their referencing columns are nullable today).

insert into public.currencies (code, name, symbol, decimal_places) values
    ('USD', 'US Dollar',              '$',    2),
    ('EUR', 'Euro',                   '€',    2),
    ('GBP', 'Pound Sterling',         '£',    2),
    ('SAR', 'Saudi Riyal',            'SR',   2),
    ('AED', 'UAE Dirham',             'AED',  2),
    ('EGP', 'Egyptian Pound',         'E£',   2),
    ('QAR', 'Qatari Riyal',           'QR',   2),
    ('KWD', 'Kuwaiti Dinar',          'KD',   3),
    ('BHD', 'Bahraini Dinar',         'BD',   3),
    ('OMR', 'Omani Rial',             'OMR',  3),
    ('JOD', 'Jordanian Dinar',        'JD',   3),
    ('TRY', 'Turkish Lira',           '₺',    2),
    ('JPY', 'Japanese Yen',           '¥',    0),
    ('CNY', 'Chinese Yuan',           '¥',    2),
    ('INR', 'Indian Rupee',           '₹',    2),
    ('CHF', 'Swiss Franc',            'CHF',  2),
    ('CAD', 'Canadian Dollar',        'C$',   2),
    ('AUD', 'Australian Dollar',      'A$',   2)
on conflict (code) do nothing;
