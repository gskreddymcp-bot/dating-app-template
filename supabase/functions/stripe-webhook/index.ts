import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") return new Response("Method not allowed", { status: 405 });

  const signature = req.headers.get("stripe-signature");
  if (!signature) return new Response("Missing stripe signature", { status: 400 });

  // Stub: validate webhook signature and update subscriptions table.
  const event = await req.json();

  return Response.json({ received: true, type: event?.type ?? "unknown" });
});
