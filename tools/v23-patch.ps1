# v23:
#  1) Mobile (<=720px): footer berjalan (disclaimer + nama pembuat) disembunyikan dari bawah halaman dan dipindah ke dasar menu hamburger,
#     statis, font kecil. Teksnya disalin dari #crb yang sudah ada (tidak diketik ulang). Desktop tidak berubah.
#  2) Mobile: kontrol Swing/Investasi, Tabel/Grafik/Diagram Alir, Judul Asli/Terjemahan, dan grup chip serupa dirapikan jadi
#     kontrol segmented (pil) yang hemat ruang; catatan panjang dilipat jadi "Catatan" (desktop tetap terbuka seperti semula).
#  3) Tabel instrumen: tiap instrumen diberi keterangan kecil (misal IHSG = Indeks Harga Saham Gabungan (Indonesia)); di mobile
#     kolom waktu dipadatkan (hanya usia data).
# powershell -ExecutionPolicy Bypass -File tools\v23-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v23*/")) { Write-Host "SKIP: v23 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v22*/")) { throw "v22 belum terpasang" }
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
/*v23*/{const s=document.createElement('style');s.id='v23-css';s.textContent='.nvf{display:none}.ctn>summary{cursor:pointer;color:var(--m)}.qdr td{padding:0 5px 7px!important;font-size:10.5px;line-height:1.3;color:var(--m);text-align:left!important;font-weight:400}.qm td,tr.qm{border-bottom:0!important}@media(min-width:721px){.ctn>summary{display:none}}@media(max-width:720px){#crb{display:none!important}#app{padding-bottom:0!important}#nwfab{bottom:16px!important}nav{display:flex!important;flex-direction:column}.nvf{display:block;margin:auto -6px -6px;position:sticky;bottom:0;padding:8px 12px calc(8px + env(safe-area-inset-bottom,0px));background:var(--p);border-top:1px solid var(--b);color:var(--m);font:10.5px/1.4 system-ui}.nvf div+div{margin-top:4px}.ctn{font-size:11.5px;line-height:1.4}.ctn>summary{font-size:11.5px;padding:2px 0}.ctn[open]>summary{margin-bottom:4px}.v8t{gap:6px 8px!important}.v8t .tfs:not(:has(a.chip)){display:inline-flex!important;flex-wrap:nowrap!important;gap:0!important;border:1px solid var(--b);border-radius:10px;overflow-x:auto;max-width:100%;scrollbar-width:none}.v8t .tfs:not(:has(a.chip))>.chip{border:0!important;border-radius:0!important;padding:5px 9px!important;font-size:12px;line-height:1.3;white-space:nowrap;background:transparent}.v8t .tfs:not(:has(a.chip))>.chip+.chip{border-left:1px solid var(--b)!important}.v8t .tfs:not(:has(a.chip))>.chip.on{background:var(--a)!important;color:#120d07!important;font-weight:700}.qw{display:none}}';document.head.appendChild(s)}
let crbT=null;
function crbParts(){if(crbT)return crbT;const c=document.getElementById('crb');if(!c)return [];const t=(c.textContent||'').replace(/\s+/g,' ').trim(),u=[];t.split(/(?=Disclaimer:|Dibuat oleh)/).map(x=>x.trim()).filter(Boolean).forEach(p=>{if(!u.includes(p))u.push(p)});if(u.length)crbT=u;return u}
function navFoot(){const n=document.getElementById('nav');if(!n||n.querySelector('.nvf'))return;const p=crbParts();if(!p.length)return;const d=document.createElement('div');d.className='nvf';p.forEach(t=>{const e=document.createElement('div');e.textContent=t;d.appendChild(e)});n.appendChild(d)}
function nwNotes(o){if(!o.mode&&!o.info)return '';const c=(o.mode?`<div>${modeNote()}</div>`:'')+(o.info?`<div style="margin-top:6px">${o.info}</div>`:'');return `<details class="ctn m"${nwMob()?'':' open'}><summary>${S('Catatan','Notes')}</summary>${c}</details>`}
const FXN={USD:['Dolar AS','US Dollar'],EUR:['Euro','Euro'],JPY:['Yen Jepang','Japanese Yen'],GBP:['Poundsterling','British Pound'],AUD:['Dolar Australia','Australian Dollar'],CAD:['Dolar Kanada','Canadian Dollar'],CHF:['Franc Swiss','Swiss Franc'],NZD:['Dolar Selandia Baru','NZ Dollar'],IDR:['Rupiah','Rupiah'],CNY:['Yuan China','Chinese Yuan'],SGD:['Dolar Singapura','Singapore Dollar'],INR:['Rupee India','Indian Rupee'],KRW:['Won Korea','Korean Won'],MYR:['Ringgit Malaysia','Malaysian Ringgit'],HKD:['Dolar Hong Kong','Hong Kong Dollar']};
const QDM={'^JKSE':['Indeks Harga Saham Gabungan (Indonesia)','Jakarta Composite Index (Indonesia)'],'^GSPC':['Indeks 500 saham perusahaan terbesar AS','Index of the 500 largest US companies'],'^IXIC':['Indeks Nasdaq (banyak saham teknologi AS)','Nasdaq index (many US tech stocks)'],'^DJI':['Indeks 30 saham raksasa AS (Dow Jones)','Index of 30 large US stocks (Dow Jones)'],'^STOXX50E':['Indeks 50 saham terbesar zona Euro','Index of the 50 largest Eurozone stocks'],'^FTSE':['Indeks 100 saham terbesar Bursa London (Inggris)','Index of the 100 largest London stocks (UK)'],'^GDAXI':['Indeks 40 saham terbesar Jerman (DAX)','Index of the 40 largest German stocks (DAX)'],'^FCHI':['Indeks 40 saham terbesar Prancis (CAC 40)','Index of the 40 largest French stocks (CAC 40)'],'000001.SS':['Indeks saham Bursa Shanghai (China)','Shanghai Stock Exchange index (China)'],'^HSI':['Indeks saham utama Hong Kong (Hang Seng)','Main Hong Kong stock index (Hang Seng)'],'^N225':['Indeks 225 saham Bursa Tokyo (Jepang)','Tokyo 225-stock index (Japan)'],'^KS11':['Indeks saham utama Korea Selatan (KOSPI)','Main South Korea stock index (KOSPI)'],'^TWII':['Indeks saham utama Taiwan','Main Taiwan stock index'],'^STI':['Indeks saham utama Singapura','Main Singapore stock index'],'^KLSE':['Indeks saham utama Malaysia','Main Malaysia stock index'],'^AXJO':['Indeks 200 saham terbesar Australia (ASX 200)','Index of the 200 largest Australian stocks (ASX 200)'],'^BSESN':['Indeks 30 saham besar Bursa Bombay (Sensex, India)','Bombay 30-stock index (Sensex, India)'],'^NSEI':['Indeks 50 saham terbesar India (Nifty 50)','Index of the 50 largest Indian stocks (Nifty 50)'],'^BVSP':['Indeks saham utama Brasil (Bovespa)','Main Brazil stock index (Bovespa)'],'^TNX':['Imbal hasil obligasi pemerintah AS tenor 10 tahun','Yield on 10-year US government bonds'],'US10Y':['Imbal hasil obligasi pemerintah AS tenor 10 tahun','Yield on 10-year US government bonds'],'DX-Y.NYB':['Indeks Dolar AS: kekuatan dolar vs mata uang utama','US Dollar Index: dollar strength vs major currencies'],'DXY':['Indeks Dolar AS: kekuatan dolar vs mata uang utama','US Dollar Index: dollar strength vs major currencies'],'GC=F':['Emas berjangka (per troy ounce, dolar AS)','Gold futures (per troy ounce, USD)'],'XAU':['Emas berjangka (per troy ounce, dolar AS)','Gold futures (per troy ounce, USD)'],'SI=F':['Perak berjangka (per troy ounce, dolar AS)','Silver futures (per troy ounce, USD)'],'XAG':['Perak berjangka (per troy ounce, dolar AS)','Silver futures (per troy ounce, USD)'],'CL=F':['Minyak mentah WTI berjangka (per barel)','WTI crude oil futures (per barrel)'],'WTI':['Minyak mentah WTI berjangka (per barel)','WTI crude oil futures (per barrel)'],'BZ=F':['Minyak mentah Brent berjangka (per barel)','Brent crude oil futures (per barrel)'],'NG=F':['Gas alam berjangka','Natural gas futures'],'HG=F':['Tembaga berjangka','Copper futures'],'XAUUSD=X':['Harga emas spot dalam dolar AS per troy ounce','Spot gold price in USD per troy ounce'],'USDIDR=X':['Kurs Dolar AS ke Rupiah (naik = rupiah melemah)','US Dollar to Rupiah (rising = weaker rupiah)'],'BTC-USD':['Bitcoin, aset kripto terbesar','Bitcoin, the largest crypto asset'],'ETH-USD':['Ethereum, platform kontrak pintar','Ethereum, smart-contract platform'],'SOL-USD':['Solana, jaringan blockchain cepat','Solana, a fast blockchain network'],'BNB-USD':['BNB, koin ekosistem Binance','BNB, the Binance ecosystem coin'],'PAXG-USD':['Token emas digital (1 token = 1 troy ounce emas)','Digital gold token (1 token = 1 troy ounce of gold)'],'AAPL':['Apple: iPhone dan perangkat teknologi','Apple: iPhone and tech devices'],'NVDA':['Nvidia: chip grafis dan AI','Nvidia: graphics and AI chips'],'MSFT':['Microsoft: perangkat lunak dan cloud','Microsoft: software and cloud'],'TSLA':['Tesla: mobil listrik','Tesla: electric cars'],'AMZN':['Amazon: e-commerce dan cloud','Amazon: e-commerce and cloud'],'BBCA.JK':['Bank Central Asia: perbankan swasta','Bank Central Asia: private banking'],'BBRI.JK':['Bank Rakyat Indonesia: perbankan BUMN','Bank Rakyat Indonesia: state-owned bank'],'BMRI.JK':['Bank Mandiri: perbankan BUMN','Bank Mandiri: state-owned bank'],'TLKM.JK':['Telkom Indonesia: telekomunikasi BUMN','Telkom Indonesia: state-owned telecom'],'ASII.JK':['Astra International: otomotif dan konglomerasi','Astra International: automotive and conglomerate'],'GOTO.JK':['GoTo: ekosistem Gojek dan Tokopedia','GoTo: Gojek and Tokopedia ecosystem']};
function qdesc(x){const sy=String(x.symbol||''),id=String(x.id||''),m=QDM[sy]||QDM[id];if(m)return S(m[0],m[1]);let r=/^([A-Z]{3})([A-Z]{3})=X$/.exec(sy);if(r&&FXN[r[1]]&&FXN[r[2]])return S('Kurs '+FXN[r[1]][0]+' terhadap '+FXN[r[2]][0],FXN[r[1]][1]+' vs '+FXN[r[2]][1]);if(/\.JK$/.test(sy))return S('Saham di Bursa Efek Indonesia','Stock on the Indonesia Stock Exchange');if(/-USD$/.test(sy))return S('Aset kripto dalam dolar AS','Crypto asset priced in US dollars');return ''}
/*v22*/{const s=document.createElement('style');s.id='v22-css';
'@
# --- anchor 1: catatan di kartu kontrol jadi collapsible di mobile ---
$a1 = @'
${o.mode?`<div class="m">${modeNote()}</div>`:''}${o.info?`<div class="m" style="margin-top:6px">${o.info}</div>`:''}
'@
$b1 = @'
${nwNotes(o)}
'@
# --- anchor 2: footer dipasang ke menu hamburger setiap kali menggambar ---
$a2 = @'
const r=d16.apply(this,arguments);syncUrl();return r}
'@
$b2 = @'
const r=d16.apply(this,arguments);syncUrl();navFoot();return r}
'@
# --- anchor 3: baris instrumen (kelas qm bila ada keterangan) ---
$a3 = @'
const p=x.perf||{},old=ageH(x.asOf)>36;return `<tr><td><b style="color:var(--w)">${E(label||id)}</b><br><span class="m" style="font-size:12px">${E(x.symbol)}</span></td>
'@
$b3 = @'
const p=x.perf||{},old=ageH(x.asOf)>36,qd=qdesc(x);return `<tr${qd?' class="qm"':''}><td><b style="color:var(--w)">${E(label||id)}</b><br><span class="m" style="font-size:12px">${E(x.symbol)}</span></td>
'@
# --- anchor 4: sel waktu (mobile hanya usia data) + baris keterangan ---
$a4 = @'
${wib(x.asOf)}<br><span class="m" style="font-size:12px">${ago(x.asOf)}</span></td></tr>`}).join('')}</table></div>`}
'@
$b4 = @'
<span class="qw">${wib(x.asOf)}<br></span><span class="m" style="font-size:12px">${ago(x.asOf)}</span></td></tr>${qd?`<tr class="qdr"><td colspan="7">${E(qd)}</td></tr>`:''}`}).join('')}</table></div>`}
'@
$pairs = @()
foreach ($p in @(@($a0,$b0), @($a1,$b1), @($a2,$b2), @($a3,$b3), @($a4,$b4))) {
  $pairs += ,@($p[0].TrimEnd().Replace("`r`n","`n"), $p[1].TrimEnd().Replace("`r`n","`n"))
}
foreach ($p in $pairs) {
  $n = ([regex]::Matches($js, [regex]::Escape($p[0]))).Count
  if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n : $($p[0].Substring(0,[Math]::Min(60,$p[0].Length)))" }
}
$new = $js
foreach ($p in $pairs) { $new = $new.Replace($p[0], $p[1]) }
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v23.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v23.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v23.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v23.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v23 terpasang. Cadangan di $env:TEMP (v8.js.v23.bak, index.html.v23.bak)"
