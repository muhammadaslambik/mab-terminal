# v18 (CSS saja): chip analisa tidak lagi melebar (penyebab layar HP mengecil) dan footer HP selebar layar. Melengkapi v17 versi lama.
# powershell -ExecutionPolicy Bypass -File tools\v18-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v18*/")) { Write-Host "SKIP: v18 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v17*/")) { throw "v17 belum terpasang" }
if (-not $js.Contains("/indonesia/analyzer")) { throw "v16 (versi analyzer) belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }
$a1 = @'
const PAGES={
'@
$b1 = @'
/*v18*/{const s=document.createElement('style');s.id='v18-css';s.textContent='.v8t .tfs{max-width:100%}@media(max-width:720px){#crb{max-width:none!important;min-width:0!important}}';document.head.appendChild(s)}
const PAGES={
'@
$a1 = $a1.TrimEnd(); $b1 = $b1.TrimEnd()
$n = ([regex]::Matches($js, [regex]::Escape($a1))).Count
if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n" }
$new = $js.Replace($a1, $b1)
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v18.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v18.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v18.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v18.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v18 terpasang. Cadangan di $env:TEMP (v8.js.v18.bak, index.html.v18.bak)"
