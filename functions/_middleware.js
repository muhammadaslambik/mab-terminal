// Gerbang kata sandi (HTTP Basic) untuk seluruh situs dan /api. Kata sandi = secret Pages SITE_PASSWORD; nama pengguna diabaikan.
// Gagal tertutup: bila SITE_PASSWORD belum dipasang, semua permintaan ditolak (termasuk deployment preview).
const enc = new TextEncoder();
const noStore = { "cache-control": "no-store" };

async function sha256(s) {
  return new Uint8Array(await crypto.subtle.digest("SHA-256", enc.encode(s)));
}
async function safeEqual(a, b) {
  const [x, y] = await Promise.all([sha256(a), sha256(b)]);
  let d = 0;
  for (let i = 0; i < x.length; i++) d |= x[i] ^ y[i];
  return d === 0;
}

export async function onRequest({ request, env, next }) {
  const secret = String(env.SITE_PASSWORD || "").replace(/^\uFEFF/, "").trim();
  if (!secret) return new Response("SITE_PASSWORD belum dipasang", { status: 500, headers: noStore });
  const h = request.headers.get("Authorization") || "";
  let ok = false;
  if (h.startsWith("Basic ")) {
    try {
      const dec = atob(h.slice(6).trim());
      const i = dec.indexOf(":");
      ok = i >= 0 && (await safeEqual(dec.slice(i + 1), secret));
    } catch (_e) {
      ok = false;
    }
  }
  if (!ok) {
    return new Response("Perlu login", {
      status: 401,
      headers: { ...noStore, "www-authenticate": 'Basic realm="MAB-Terminal", charset="UTF-8"' },
    });
  }
  return next();
}
