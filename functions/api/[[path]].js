// Proxy Pages -> Worker. Token API_TOKEN hanya ada di sisi server (secret Pages), tidak pernah ke browser.
// Hanya GET dan hanya rute daftar-putih; parameter lain (mis. refresh=1) dibuang supaya pengunjung tidak bisa memicu hitung ulang.
const BACKEND = "https://api.mab-terminal.workers.dev";
const ROUTES = {
  "/api/health": [],
  "/api/idx/cacing": [],
  "/api/market/overview": [],
  "/api/market/news": [],
  "/api/idx/rumor": ["matched"],
  "/api/signals": ["market", "symbols"],
};
const J = (obj, status = 200) =>
  new Response(JSON.stringify(obj), {
    status,
    headers: { "content-type": "application/json; charset=utf-8", "cache-control": "no-store" },
  });

export async function onRequest({ request, env }) {
  if (request.method !== "GET") return J({ error: "Method tidak diizinkan" }, 405);
  const url = new URL(request.url);
  const path = url.pathname.replace(/\/+$/, "");
  const allowed = ROUTES[path];
  if (!allowed) return J({ error: "Rute tidak tersedia" }, 404);
  // Buang BOM/spasi/baris baru di ujung (sisa tempel atau pipa) supaya token cocok dengan Worker
  const token = String(env.API_TOKEN || "").replace(/^\uFEFF/, "").trim();
  if (!token) return J({ error: "API_TOKEN belum dipasang di proyek Pages" }, 500);

  const q = new URLSearchParams();
  for (const k of allowed) {
    const v = url.searchParams.get(k);
    if (v === null) continue;
    if (k === "matched" && v !== "1") continue;
    if (k === "market" && v !== "idx" && v !== "crypto") continue;
    if (k === "symbols" && !/^[A-Za-z0-9,]{1,60}$/.test(v)) continue;
    q.set(k, v);
  }
  const qs = q.toString() ? `?${q}` : "";
  try {
    const r = await fetch(`${BACKEND}${path}${qs}`, { headers: { Authorization: `Bearer ${token}` } });
    if (!r.ok) return J({ error: `Backend HTTP ${r.status}` }, 502);
    return new Response(await r.text(), {
      status: 200,
      headers: { "content-type": "application/json; charset=utf-8", "cache-control": "no-store" },
    });
  } catch (_e) {
    return J({ error: "Backend tidak terjangkau" }, 502);
  }
}
