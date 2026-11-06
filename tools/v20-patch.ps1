# v20: (1) Mobile, halaman Berita: tombol melayang kanan-bawah berisi menu Indonesia/Amerika/Dunia/Crypto/XAUUSD/Sumber berita, halaman fokus ke satu pilihan dan menampilkan semua beritanya; klik di luar menu menutupnya.
#      (2) Desktop: kolom berita kembali bisa digulir di dalam kolom, tetapi hanya setelah kolom diklik; klik di luar kolom menonaktifkannya.
#      Halaman lain di mobile tetap memakai tombol "Tampilkan semua" dari v19.
# powershell -ExecutionPolicy Bypass -File tools\v20-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v20*/")) { Write-Host "SKIP: v20 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v19*/")) { throw "v19 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }

# --- anchor 1: definisi baru (deteksi mobile, menu fokus, gaya, pendengar klik) ---
$a1 = @'
/*v19*/const NXN=5;NV.nx={};
'@
$b1 = @'
/*v19*/const NXN=5;NV.nx={};
/*v20*/const nwMob=()=>{try{return matchMedia('(max-width:720px)').matches}catch(e){return false}};
NV.nwf='indonesia';NV.nwm=false;
const NWF=[['indonesia','Indonesia','Indonesia'],['amerika','Amerika','America'],['dunia','Dunia','World'],['crypto','Crypto','Crypto'],['xauusd','XAUUSD','XAUUSD'],['sumber','Sumber berita','News sources']];
{const s=document.createElement('style');s.id='v20-css';s.textContent='.nsc{max-height:62vh;overflow:hidden;overscroll-behavior:contain;cursor:pointer;border-radius:6px}.nsc.act{overflow:auto;cursor:auto;box-shadow:0 0 0 1px var(--a)}';document.head.appendChild(s)}
function nwFab(){const f=NV.nwf,o=NWF.find(x=>x[0]===f)||NWF[0];return `<div id="nwfab" style="position:fixed;right:14px;bottom:52px;z-index:15;display:flex;flex-direction:column;align-items:flex-end;gap:8px"><div id="nwfm" style="display:${NV.nwm?'block':'none'};background:var(--p);border:1px solid var(--a);border-radius:12px;padding:6px;box-shadow:0 6px 20px rgba(0,0,0,.6);min-width:170px">${NWF.map(x=>`<div onclick="v7.nwf('${x[0]}')" style="padding:10px 12px;border-radius:8px;font-size:14px;cursor:pointer;${x[0]===f?'background:var(--a);color:#120d07;font-weight:700':'color:var(--t)'}">${S(x[1],x[2])}</div>`).join('')}</div><button onclick="v7.nwm()" style="background:var(--a);color:#120d07;border:0;border-radius:24px;padding:12px 16px;font:700 14px system-ui;box-shadow:0 4px 14px rgba(0,0,0,.6);cursor:pointer">\u2630 ${S(o[1],o[2])}</button></div>`}
function nwFocus(){const f=NV.nwf;return (f==='sumber'?srcTable():newsCard(CATL[f],f,NEWS[f](),99999,true))+'<div style="height:72px"></div>'+nwFab()}
window.addEventListener('click',ev=>{const t=ev.target,ce=t&&t.closest?t.closest('.nsc'):null;document.querySelectorAll('.nsc.act').forEach(x=>{if(x!==ce)x.classList.remove('act')});if(ce)ce.classList.add('act');if(NV.nwm&&!(t&&t.closest&&t.closest('#nwfab'))){NV.nwm=false;const m=document.getElementById('nwfm');if(m)m.style.display='none'}},true);
try{matchMedia('(max-width:720px)').addEventListener('change',()=>{if(isV7())rd()})}catch(e){}
'@
# --- anchor 2: nwBody: desktop = kolom gulir (aktif saat diklik); mobile = v19 (atau semua isi bila lim sangat besar) ---
$a2 = @'
function nwBody(title,cat,list,lim){const all=list.slice(0,lim),key=
'@
$b2 = @'
function nwBody(title,cat,list,lim){if(!nwMob())return `<div class="nsc" title="${S('Klik di dalam kolom untuk mulai menggulir','Click inside the column to start scrolling')}">${rows(list,lim)}</div>`;if(lim>=99999)return rows(list,lim);const all=list.slice(0,lim),key=
'@
# --- anchor 3: halaman Berita (tampilan Tabel) di mobile = mode fokus ---
$a3 = @'
else body=`<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,380px),1fr));gap:14px">${CATS.map(c=>newsCard(CATL[c],c,NEWS[c](),60,true))
'@
$b3 = @'
else if(nwMob())body=nwFocus();else body=`<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,380px),1fr));gap:14px">${CATS.map(c=>newsCard(CATL[c],c,NEWS[c](),60,true))
'@
# --- anchor 4: handler v7.nwm / v7.nwf ---
$a4 = @'
window.v7={nx:k=>
'@
$b4 = @'
window.v7={nwm:()=>{NV.nwm=!NV.nwm;const m=document.getElementById('nwfm');if(m)m.style.display=NV.nwm?'block':'none'},nwf:k=>{NV.nwf=k;NV.nwm=false;rd();scrollTo(0,0)},nx:k=>
'@
$pairs = @()
foreach ($p in @(@($a1,$b1), @($a2,$b2), @($a3,$b3), @($a4,$b4))) {
  $pairs += ,@($p[0].TrimEnd().Replace("`r`n","`n"), $p[1].TrimEnd().Replace("`r`n","`n"))
}
foreach ($p in $pairs) {
  $n = ([regex]::Matches($js, [regex]::Escape($p[0]))).Count
  if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n : $($p[0].Substring(0,[Math]::Min(60,$p[0].Length)))" }
}
$new = $js
foreach ($p in $pairs) { $new = $new.Replace($p[0], $p[1]) }
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v20.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v20.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v20.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v20.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v20 terpasang. Cadangan di $env:TEMP (v8.js.v20.bak, index.html.v20.bak)"
