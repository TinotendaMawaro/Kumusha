CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS public.registrations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz NOT NULL DEFAULT now(),
  player_name text NOT NULL,
  player_dob date NOT NULL,
  age_group text NOT NULL,
  position text NOT NULL,
  experience text,
  guardian_name text NOT NULL,
  contact_phone text NOT NULL,
  contact_email text NOT NULL,
  consent_terms boolean NOT NULL DEFAULT false,
  tracksuit_size text NOT NULL,
  jersey_size text NOT NULL,
  squad_number integer NOT NULL,
  status text NOT NULL DEFAULT 'pending'
);

ALTER TABLE public.registrations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public registration insert" ON public.registrations;
CREATE POLICY "Allow public registration insert"
  ON public.registrations
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role all" ON public.registrations;
CREATE POLICY "Allow service role all"
  ON public.registrations
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

GRANT INSERT ON public.registrations TO anon, authenticated;
GRANT SELECT ON public.registrations TO service_role;

CREATE INDEX IF NOT EXISTS idx_registrations_created_at
  ON public.registrations (created_at DESC);
