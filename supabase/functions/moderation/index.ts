import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  const payload = await req.json();
  const text = String(payload?.content ?? "").toLowerCase();
  const flagged = /(scam|bitcoin|wire transfer|explicit)/.test(text);

  return Response.json({ flagged, reason: flagged ? "keyword_match" : null });
});
