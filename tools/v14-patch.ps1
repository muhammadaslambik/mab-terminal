# v14: Peta Uang Dunia diurut: MASUK KUAT di atas, NETRAL tengah, KELUAR KUAT di bawah.
# powershell -ExecutionPolicy Bypass -File tools\v14-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v14*/")) { Write-Host "SKIP: v14 sudah terpasang"; exit 0 }
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
$a1 = @'
.filter(Boolean).map(a=>{const dead=closed
'@
$b1 = @'
.filter(Boolean).sort((p,q)=>{/*v14*/const k=a=>closed&&a.group==='etf'?-1e9:(isN(aSc(a,tf))?aSc(a,tf):-1e8);return k(q)-k(p)||((q.chg&&q.chg[tf])||0)-((p.chg&&p.chg[tf])||0)}).map(a=>{const dead=closed
'@
$a2 = @'
(estimasi kasar). Ini arah harga
'@
$b2 = @'
(estimasi kasar). Urutan: masuk kuat di atas, netral di tengah, keluar kuat di bawah. Ini arah harga
'@
$a3 = @'
(rough estimate). This is price direction
'@
$b3 = @'
(rough estimate). Order: strong in at the top, neutral in the middle, strong out at the bottom. This is price direction
'@
$new = $js
$new = Rep $new $a1.TrimEnd() $b1.TrimEnd()
$new = Rep $new $a2.TrimEnd() $b2.TrimEnd()
$new = Rep $new $a3.TrimEnd() $b3.TrimEnd()
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v14.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v14.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v14.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v14.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v14 terpasang. Cadangan di $env:TEMP (v8.js.v14.bak, index.html.v14.bak)"
