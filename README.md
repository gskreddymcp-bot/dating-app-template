# verified-dating-app

Production-oriented monorepo for a verified dating platform with:
- **Mobile app** (Expo React Native + TypeScript)
- **Web app** (Next.js for user-facing dashboard/discovery)
- **Admin console** (Next.js + Tailwind + shadcn-style components)
- **Backend** (Supabase Postgres/Auth/Storage/Edge Functions)

## Monorepo layout

- `apps/mobile` – Expo client
- `apps/web` – User web application
- `apps/admin` – Moderation and operations console
- `packages/shared` – Shared types, validation, and domain logic
- `supabase` – SQL migrations, seed data, edge functions
- `docs` – Mermaid diagrams for architecture and safety flows
- `.github/workflows` – CI and security checks

## Quick start

### 1) Prerequisites
- Node 20+
- pnpm 9+
- Expo CLI
- Supabase CLI (optional, recommended)

### 2) Install
```bash
pnpm install
```

### 3) Configure env
```bash
cp .env.example .env
```
Populate all keys.

### 4) Run Supabase locally
```bash
supabase start
supabase db reset
```

### 5) Start all apps
```bash
pnpm dev
```

## Feature matrix

- ✅ Auth + onboarding (email/phone OTP optional)
- ✅ Profile (bio, prompts, photos, preferences)
- ✅ Discovery feed with filters
- ✅ Like/pass and match creation
- ✅ Chat with throttle + keyword flagging
- ✅ Report/block + moderation case creation
- ✅ Verification workflow (selfie upload + status)
- ✅ Admin console (users, reports, cases, bans, audit)
- ✅ RLS on all user-owned rows
- ✅ Stripe subscription plumbing + webhook stub
- ✅ Expo push + email fallback stubs
- ✅ CI + typecheck + tests + security workflows

## Database + security highlights

- Strict Row Level Security enabled on every table
- User-owned table policies enforce `auth.uid()` ownership
- Storage access expected through signed URLs only
- RPC rate limiting function for messages
- Keyword flagging for unsafe message patterns
- Moderation action logging via `audit_logs`

## Testing

```bash
pnpm lint
pnpm typecheck
pnpm test
```

## Deployment notes

- Deploy web/admin to Vercel
- Deploy mobile with EAS
- Deploy Supabase edge functions with `supabase functions deploy`
- Configure Stripe webhook to `supabase/functions/v1/stripe-webhook`

## Diagrams

- `docs/architecture.mmd`
- `docs/moderation-flow.mmd`
