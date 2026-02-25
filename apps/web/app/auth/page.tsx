import { Card } from "../../components/card";

export default function AuthPage() {
  return (
    <Card title="Auth + Onboarding">
      <p>Email + phone OTP flow should be implemented with Supabase Auth providers.</p>
      <ol className="list-decimal pl-6">
        <li>Sign in via OTP</li>
        <li>Create profile with prompts/preferences</li>
        <li>Accept community safety rules</li>
      </ol>
    </Card>
  );
}
