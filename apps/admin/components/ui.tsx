import { ReactNode } from "react";

export function Button({ children }: { children: ReactNode }) {
  return <button className="rounded-md bg-zinc-100 px-3 py-2 text-zinc-900">{children}</button>;
}

export function Panel({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section className="rounded-lg border border-zinc-800 bg-zinc-900 p-4">
      <h2 className="mb-3 font-semibold">{title}</h2>
      {children}
    </section>
  );
}
