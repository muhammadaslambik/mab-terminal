# v26: halaman Analisa Pakar di mobile (<=720px) dirapikan; desktop tidak berubah.
#  - deret 7 tombol pakar diganti satu dropdown (juga di kartu "Analisa Pakar" halaman Saham Indonesia)
#  - tombol kembali + dropdown + deskripsi pakar digabung dalam satu kartu
#  - judul dipendekkan, judul/badge/tombol "Muat ulang" dikecilkan agar muat satu baris
# powershell -ExecutionPolicy Bypass -File tools\v26-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v26*/")) { Write-Host "SKIP: v26 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v25*/")) { throw "v25 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }

# --- anchor 0: blok baru disisipkan sebelum gaya v22 ---
$a0 = @'
/*v22*/{const s=document.createElement('style');s.id='v22-css';
'@
$b0 = @'
/*v26*/{const s=document.createElement('style');s.id='v26-css';s.textContent='@media(max-width:720px){.ansel{flex:1;min-width:0;width:100%;color-scheme:dark;background:var(--p);color:var(--t);border:1px solid var(--b);border-radius:10px;padding:8px 10px;font:13px system-ui}.bar h2{font-size:16px!important}.bar .livb{font-size:9px!important;padding:1px 5px!important}.bar button{padding:6px 12px!important;font-size:12px!important}}';document.head.appendChild(s)}
function anSel(k){const a=AN.find(z=>z[0]===k);return `<div class="card" style="padding:10px"><select class="ansel" onchange="v7.anx(this.value)" aria-label="${E(S('Pilih pakar','Choose expert'))}">${a?'':`<option value="" selected disabled>${S('Analisa pakar: pilih...','Expert analysis: choose...')}</option>`}${AN.map(z=>`<option value="${E(z[0])}"${z[0]===k?' selected':''}>${E(S(z[1],z[2]))}</option>`).join('')}</select></div>`}
function anPageM(){const k=NV.an,a=AN.find(z=>z[0]===k),it=IDX.find(z=>z[0]===NV.sel.id)||IDX[0],x=q(it[0]),p=x&&x.perf||{};
 const top=`<div class="card" style="padding:10px"><div style="display:flex;gap:8px;align-items:center"><a class="chip" style="text-decoration:none;white-space:nowrap" href="/indonesia" onclick="return v7.rt(event,this.getAttribute('href'))">\u2190 ${S('Saham','Stocks')}</a><select class="ansel" onchange="v7.anx(this.value)" aria-label="${E(S('Pilih pakar','Choose expert'))}">${a?'':`<option value="" selected disabled>${S('Pilih pakar...','Choose expert...')}</option>`}${AN.map(z=>`<option value="${E(z[0])}"${z[0]===k?' selected':''}>${E(S(z[1],z[2]))}</option>`).join('')}</select></div>${a?`<div class="m" style="font-size:11.5px;line-height:1.4;margin-top:6px">${E(S(a[3],a[4]))}</div>`:''}</div>`;
 const tabs=`<div class="tabs">${IDX.map(l=>`<span class="${l[0]===it[0]?'on':''}" onclick="v7.sel('id','${l[0]}')">${E(l[0])}</span>`).join('')}</div>`;
 const gl=k==='baseline'?S('ANALISA TEKNIKAL HARIAN','DAILY TECHNICAL ANALYSIS'):S('PEMBANDING: ANALISA TEKNIKAL UMUM','REFERENCE: GENERAL TECHNICAL ANALYSIS');
 const gen=x?`<div class="card"><div class="ph">${gl} \u00B7 ${E(it[0])}</div><div style="font-size:18px"><b style="color:var(--w)">${nf(x.price)}</b> <span class="m" style="font-size:12px">${E(x.currency||'')}</span> <span class="${cl(p.d1)}">${sp(p.d1)}</span></div><div class="m" style="font-size:11px;margin-bottom:4px">${wib(x.asOf)}</div>${anHtml(x)}</div>`:`<div class="card m">${E(it[0])}: ${S('tidak tersedia dari sumber','not available from source')}</div>`;
 let body;if(!a)body=`<div class="card m">${S('Pilih salah satu pakar di atas.','Pick an expert above.')}</div>`;else if(k==='andry-hakim/multibagger')body=typeof cacHtml==='function'?cacHtml():'';else if(k==='baseline')body=tabs+gen;else body=`<div style="color:var(--a);font-size:12px;margin:0 0 8px">${S('Belum diimplementasikan dengan data nyata, jadi belum ada sinyal dari pakar ini. Di bawah hanya pembanding.','Not yet implemented with real data, so there is no signal from this expert yet. Below is a reference only.')}</div>`+tabs+gen;
 return head(S('Analisa Pakar','Expert Analysis'))+top+body}
/*v22*/{const s=document.createElement('style');s.id='v22-css';
'@
# --- anchor 1: anLinks (deret tombol pakar) jadi dropdown di mobile ---
$a1 = @'
const anLinks=k=>
'@
$b1 = @'
const anLinks=k=>nwMob()?anSel(k):anLinks0(k);const anLinks0=k=>
'@
# --- anchor 2: halaman analisa pakar mobile ---
$a2 = @'
function anPage(){
'@
$b2 = @'
function anPage(){if(nwMob())return anPageM();
'@
# --- anchor 3: handler pilih pakar ---
$a3 = @'
window.v7={hac:k=>
'@
$b3 = @'
window.v7={anx:k=>{if(k)rtGo(null,'/indonesia/analyzer?'+k)},hac:k=>
'@
$pairs = @()
foreach ($p in @(@($a0,$b0), @($a1,$b1), @($a2,$b2), @($a3,$b3))) {
  $pairs += ,@($p[0].TrimEnd().Replace("`r`n","`n"), $p[1].TrimEnd().Replace("`r`n","`n"))
}
foreach ($p in $pairs) {
  $n = ([regex]::Matches($js, [regex]::Escape($p[0]))).Count
  if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n : $($p[0].Substring(0,[Math]::Min(60,$p[0].Length)))" }
}
$new = $js
foreach ($p in $pairs) { $new = $new.Replace($p[0], $p[1]) }
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v26.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v26.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v26.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v26.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v26 terpasang. Cadangan di $env:TEMP (v8.js.v26.bak, index.html.v26.bak)"
