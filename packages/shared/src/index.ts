import { z } from "zod";

export const verificationStatus = z.enum(["pending", "verified", "rejected"]);

export const profileSchema = z.object({
  id: z.string().uuid(),
  bio: z.string().min(1).max(500),
  prompts: z.array(z.string().max(200)).max(5),
  interests: z.array(z.string()).max(20)
});

export const messageSchema = z.object({
  matchId: z.string().uuid(),
  senderId: z.string().uuid(),
  content: z.string().min(1).max(1000)
});

export type Profile = z.infer<typeof profileSchema>;
export type VerificationStatus = z.infer<typeof verificationStatus>;

export const FLAGGED_KEYWORDS = ["scam", "bitcoin", "wire transfer", "explicit"];

export function containsFlaggedKeyword(input: string): boolean {
  const normalized = input.toLowerCase();
  return FLAGGED_KEYWORDS.some((word) => normalized.includes(word));
}
