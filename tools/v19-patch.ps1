# v19: kolom berita tidak punya scroll sendiri. Tertutup = 5 berita teratas; tombol "Tampilkan semua" / "Tutup" membuka dan menutup. Berlaku di semua halaman yang memakai newsCard.
# powershell -ExecutionPolicy Bypass -File tools\v19-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v19*/")) { Write-Host "SKIP: v19 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v18*/")) { throw "v18 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }

# --- anchor 1: badan daftar berita di newsCard (hapus max-height + overflow) ---
$a1 = @'
<div style="max-height:62vh;overflow:auto">${rows(list,lim)}</div>
'@
$b1 = @'
${nwBody(title,cat,list,lim)}
'@
# --- anchor 2: fungsi nwBody disisipkan sebelum PAGES ---
$a2 = @'
const PAGES={
'@
$b2 = @'
/*v19*/const NXN=5;NV.nx={};
function nwBody(title,cat,list,lim){const all=list.slice(0,lim),key=(M[cur]?M[cur].pg:'')+'|'+cat+'|'+title,open=!!NV.nx[key];if(all.length<=NXN)return rows(all,lim);const shown=open?all:all.slice(0,NXN),k=encodeURIComponent(key).replace(/'/g,'%27');return rows(shown,lim)+`<div style="margin-top:8px"><button class="vb" onclick="v7.nx(decodeURIComponent('${k}'))">${open?S('Tutup \u25B4','Close \u25B4'):S('Tampilkan semua ('+all.length+') \u25BE','Show all ('+all.length+') \u25BE')}</button></div>`}
const PAGES={
'@
# --- anchor 3: handler v7.nx ---
$a3 = @'
window.v7={rt:rtGo,
'@
$b3 = @'
window.v7={nx:k=>{NV.nx[k]=!NV.nx[k];rd()},rt:rtGo,
'@
$pairs = @(@($a1.TrimEnd(), $b1.TrimEnd()), @($a2.TrimEnd(), $b2.TrimEnd()), @($a3.TrimEnd(), $b3.TrimEnd()))
foreach ($p in $pairs) {
  $n = ([regex]::Matches($js, [regex]::Escape($p[0]))).Count
  if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n : $($p[0].Substring(0,[Math]::Min(50,$p[0].Length)))" }
}
$new = $js
foreach ($p in $pairs) { $new = $new.Replace($p[0], $p[1]) }
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v19.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v19.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v19.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v19.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v19 terpasang. Cadangan di $env:TEMP (v8.js.v19.bak, index.html.v19.bak)"
