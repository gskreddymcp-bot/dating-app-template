import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") return new Response("Method not allowed", { status: 405 });

  const body = await req.json();

  // Expo push stub; fallback to email (Resend) stub.
  return Response.json({
    push: {
      attempted: true,
      tokenPresent: Boolean(body?.expoPushToken)
    },
    emailFallback: {
      attempted: true,
      recipient: body?.email ?? null
    }
  });
});
