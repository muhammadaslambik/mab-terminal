# v15: label diagram tidak terpotong (margin dinamis) + keterangan kecil di bawah kode pada HP.
# powershell -ExecutionPolicy Bypass -File tools\v15-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v15*/")) { Write-Host "SKIP: v15 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v13*/")) { throw "v13 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }
function Rep($t, $a, $b) {
  $n = ([regex]::Matches($t, [regex]::Escape($a))).Count
  if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n : $a" }
  return $t.Replace($a, $b)
}
$new = $js
$a1 = @'
W=nw?360:760,LM=nw?92:150,P=nw?4:6,NW=10,MH=13,
'@
$b1 = @'
ww=c=>Math.max(...c.map(x=>((x.n||'')+' '+(x.t||'')).length)),LM=nw?100:Math.min(260,Math.max(90,ww(cols[0])*6.8+16)),RM=nw?100:Math.min(260,Math.max(90,ww(cols[cols.length-1])*6.8+16)),W=nw?360:Math.max(760,LM+RM+400),P=nw?4:6,NW=10,MH=nw&&cols.some(c=>c.some(x=>x.s))?26:13,
'@
$new = Rep $new $a1.TrimEnd() $b1.TrimEnd()
$a2 = @'
xs=cols.map((_,i)=>LM+(W-2*LM-NW)*i/(n-1))
'@
$b2 = @'
xs=cols.map((_,i)=>LM+(W-LM-RM-NW)*i/(n-1))
'@
$new = Rep $new $a2.TrimEnd() $b2.TrimEnd()
$a3 = @'
font-size="12" fill="#e9dfcf" style="paint-order:stroke;stroke:#241810;stroke-width:3px">${E(x.n)} ${E(x.t||'')}</text>`}));return `<svg class="fxsv"
'@
$b3 = @'
dy="${x.s&&fxNarrow()?-5:0}" font-size="12" fill="#e9dfcf" style="paint-order:stroke;stroke:#241810;stroke-width:3px">${E(x.n)} ${E(x.t||'')}</text>${x.s&&fxNarrow()?`<text x="${f?x.x-6:x.x+NW+6}" y="${x.y+x.h/2+4}" dy="7" text-anchor="${f?'end':'start'}" font-size="9.5" fill="#b9ac96" style="paint-order:stroke;stroke:#241810;stroke-width:3px">${E(String(x.s).length>20?String(x.s).slice(0,19)+'\u2026':x.s)}</text>`:''}`}));return `<svg class="fxsv"
'@
$new = Rep $new $a3.TrimEnd() $b3.TrimEnd()
$a4 = @'
v:-x.z,t:x.t,c:'#f0826c'}
'@
$b4 = @'
v:-x.z,s:x.s,t:x.t,c:'#f0826c'}
'@
$new = Rep $new $a4.TrimEnd() $b4.TrimEnd()
$a5 = @'
v:x.z,t:x.t,c:'#5fd68a'}
'@
$b5 = @'
v:x.z,s:x.s,t:x.t,c:'#5fd68a'}
'@
$new = Rep $new $a5.TrimEnd() $b5.TrimEnd()
$a6 = @'
.map(e=>({n:e.label,z:e.perf[tf],t:f2(e.perf[tf])}))
'@
$b6 = @'
.map(e=>({n:e.label,s:fxNarrow()&&CUR[e.label]?S(CUR[e.label][0],CUR[e.label][1]):undefined,z:e.perf[tf],t:f2(e.perf[tf])}))
'@
$new = Rep $new $a6.TrimEnd() $b6.TrimEnd()
$a7 = @'
items.push({n:fxNarrow()?a.id:a.label,z:v/n,t:f2(v)})
'@
$b7 = @'
items.push({n:fxNarrow()?a.id:a.label,s:fxNarrow()?a.label:undefined,z:v/n,t:f2(v)})
'@
$new = Rep $new $a7.TrimEnd() $b7.TrimEnd()
$a8 = @'
{const full=id?x.sector:x.name;return {n:nw?(id?full.slice(0,9):x.t):full,z:x[pk],t:f2(x[pk])}}
'@
$b8 = @'
{const nm=id?(IDXN[x.sector]?S(IDXN[x.sector][0],x.sector):x.sector):x.name;return nw?{n:id?'':x.t,s:nm,z:x[pk],t:f2(x[pk])}:{n:nm,z:x[pk],t:f2(x[pk])}}
'@
$new = Rep $new $a8.TrimEnd() $b8.TrimEnd()
$a9 = @'
function fxP6(){/*v13*/
'@
$b9 = @'
/*v15*/const IDXN={'Finance':['Keuangan'],'Technology Services':['Layanan Teknologi'],'Energy Minerals':['Mineral Energi'],'Non-Energy Minerals':['Mineral Non-Energi'],'Utilities':['Utilitas'],'Communications':['Komunikasi'],'Health Services':['Layanan Kesehatan'],'Process Industries':['Industri Proses'],'Consumer Non-Durables':['Konsumer Non-Awet'],'Producer Manufacturing':['Manufaktur Produsen'],'Retail Trade':['Perdagangan Eceran'],'Health Technology':['Teknologi Kesehatan'],'Distribution Services':['Layanan Distribusi'],'Industrial Services':['Layanan Industri'],'Transportation':['Transportasi'],'Consumer Durables':['Konsumer Awet'],'Consumer Services':['Layanan Konsumer'],'Commercial Services':['Layanan Komersial'],'Miscellaneous':['Lain-lain'],'Electronic Technology':['Teknologi Elektronik']};const CUR={USD:['Dolar AS','US Dollar'],EUR:['Euro','Euro'],JPY:['Yen Jepang','Japanese Yen'],GBP:['Poundsterling','British Pound'],AUD:['Dolar Australia','Australian Dollar'],CAD:['Dolar Kanada','Canadian Dollar'],CHF:['Franc Swiss','Swiss Franc'],NZD:['Dolar Selandia Baru','NZ Dollar'],XAU:['Emas','Gold'],BTC:['Bitcoin','Bitcoin']};
function fxP6(){/*v13*/
'@
$new = Rep $new $a9.TrimEnd() $b9.TrimEnd()
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v15.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v15.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v15.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v15.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v15 terpasang. Cadangan di $env:TEMP (v8.js.v15.bak, index.html.v15.bak)"
