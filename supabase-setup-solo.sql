-- ============================================================
-- WIJNBIBLIOTHEEK SOLO v1.67 — COMPLEET DATABASE SCRIPT
-- Voer dit uit in Supabase SQL Editor (qjlgbyzogovfxdkadvan)
-- Dit script is idempotent: je kunt het veilig meerdere keren draaien
-- ============================================================

-- ── 1. EXTRA KOLOMMEN OP WIJNEN ──
ALTER TABLE wijnen ADD COLUMN IF NOT EXISTS formaat TEXT DEFAULT 'standard';
ALTER TABLE wijnen ADD COLUMN IF NOT EXISTS drink_van INTEGER;
ALTER TABLE wijnen ADD COLUMN IF NOT EXISTS drink_tot INTEGER;
ALTER TABLE wijnen ADD COLUMN IF NOT EXISTS kaart_locatie_id UUID;

-- ── 2. LOCATIES TABEL ──
CREATE TABLE IF NOT EXISTS locaties (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  naam TEXT NOT NULL,
  beschrijving TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ── 3. WIJN_LOCATIES TABEL ──
CREATE TABLE IF NOT EXISTS wijn_locaties (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  wijn_id UUID NOT NULL REFERENCES wijnen(id) ON DELETE CASCADE,
  locatie_id UUID NOT NULL REFERENCES locaties(id) ON DELETE CASCADE,
  voorraad INTEGER DEFAULT 0,
  positie TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ── 4. INDEX VOOR PERFORMANCE ──
CREATE INDEX IF NOT EXISTS idx_wijn_locaties_wijn ON wijn_locaties(wijn_id);
CREATE INDEX IF NOT EXISTS idx_wijn_locaties_locatie ON wijn_locaties(locatie_id);

-- ── 5. RLS UITSCHAKELEN (solo versie, geen auth) ──
ALTER TABLE locaties DISABLE ROW LEVEL SECURITY;
ALTER TABLE wijn_locaties DISABLE ROW LEVEL SECURITY;

-- ============================================================
-- KLAAR! Geen RLS nodig voor de solo versie.
-- ============================================================
