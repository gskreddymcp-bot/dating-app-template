import Link from "next/link";

const links = [
  ["Auth", "/auth"],
  ["Profile", "/profile"],
  ["Discover", "/discover"],
  ["Chat", "/chat"]
];

export default function HomePage() {
  return (
    <main className="space-y-6">
      <h1 className="text-3xl font-bold">verified-dating-app (Web)</h1>
      <ul className="grid gap-3 sm:grid-cols-2">
        {links.map(([label, href]) => (
          <li key={href}>
            <Link className="block rounded-lg border border-slate-700 p-4 hover:bg-slate-900" href={href}>
              {label}
            </Link>
          </li>
        ))}
      </ul>
    </main>
  );
}
