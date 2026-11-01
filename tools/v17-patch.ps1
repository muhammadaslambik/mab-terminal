# v17 (CSS saja): chip analisa tidak lagi melebar (penyebab layar HP mengecil), Beranda dan ikon menu disembunyikan di HP, dropdown akun tidak terpotong, footer HP selebar layar.
# powershell -ExecutionPolicy Bypass -File tools\v17-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v17*/")) { Write-Host "SKIP: v17 sudah terpasang"; exit 0 }
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
/*v17*/{const s=document.createElement('style');s.id='v17-css';s.textContent='.v8t .tfs{max-width:100%}@media(max-width:720px){#hmb,#mtb{display:none!important}#pmn{left:0!important;right:auto!important;transform:none!important}#crb{max-width:none!important;min-width:0!important}}';document.head.appendChild(s)}
const PAGES={
'@
$a1 = $a1.TrimEnd(); $b1 = $b1.TrimEnd()
$n = ([regex]::Matches($js, [regex]::Escape($a1))).Count
if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n" }
$new = $js.Replace($a1, $b1)
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v17.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v17.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v17.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v17.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v17 terpasang. Cadangan di $env:TEMP (v8.js.v17.bak, index.html.v17.bak)"
