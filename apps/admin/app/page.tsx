import Link from "next/link";

export default function AdminHome() {
  return (
    <main className="space-y-4">
      <h1 className="text-3xl font-bold">Admin Console</h1>
      <div className="grid gap-3 sm:grid-cols-2">
        <Link href="/users" className="rounded border border-zinc-700 p-3">Users</Link>
        <Link href="/reports" className="rounded border border-zinc-700 p-3">Reports</Link>
        <Link href="/cases" className="rounded border border-zinc-700 p-3">Moderation Cases</Link>
        <Link href="/audit" className="rounded border border-zinc-700 p-3">Audit Logs</Link>
      </div>
    </main>
  );
}
