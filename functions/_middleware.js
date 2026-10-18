// Gerbang kata sandi (HTTP Basic) untuk seluruh situs dan /api.
// - SITE_USERS  : akun per orang, format "nama:sandi;nama2:sandi2" (nama tidak boleh mengandung ':' atau ';').
// - SITE_PASSWORD: sandi admin; berlaku dengan nama pengguna apa pun.
// Gagal tertutup: bila keduanya kosong, semua permintaan ditolak (termasuk deployment preview).
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
function clean(v) {
  return String(v || "").replace(/^\uFEFF/, "").trim();
}
function parseUsers(raw) {
  const m = new Map();
  for (const part of clean(raw).split(";")) {
    const t = part.trim();
    const i = t.indexOf(":");
    if (i < 1) continue;
    const u = t.slice(0, i).trim().toLowerCase();
    const p = t.slice(i + 1).trim();
    if (u && p) m.set(u, p);
  }
  return m;
}

export async function onRequest({ request, env, next }) {
  const admin = clean(env.SITE_PASSWORD);
  const users = parseUsers(env.SITE_USERS);
  if (!admin && users.size === 0) return new Response("Gerbang belum dikonfigurasi", { status: 500, headers: noStore });

  const h = request.headers.get("Authorization") || "";
  let ok = false;
  if (h.startsWith("Basic ")) {
    try {
      const dec = atob(h.slice(6).trim());
      const i = dec.indexOf(":");
      if (i >= 0) {
        const user = dec.slice(0, i).trim().toLowerCase();
        const pass = dec.slice(i + 1).trim(); // sisa baris baru dari tempel clipboard tidak boleh menggagalkan login
        const expected = users.get(user);
        // Kedua pembanding selalu dijalankan agar waktu respons tidak membocorkan apakah nama pengguna ada.
        const okUser = expected ? await safeEqual(pass, expected) : await safeEqual(pass, "\u0000");
        const okAdmin = admin ? await safeEqual(pass, admin) : false;
        ok = (!!expected && okUser) || okAdmin;
      }
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
