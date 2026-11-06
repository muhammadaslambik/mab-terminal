# v24: menu hamburger (mobile): jarak atas mengikuti tinggi header sebenarnya, sehingga item pertama (Beranda) tidak tertutup header.
# Desktop tidak berubah (padding inline dikosongkan di luar mobile).
# powershell -ExecutionPolicy Bypass -File tools\v24-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v24*/")) { Write-Host "SKIP: v24 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v23*/")) { throw "v23 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }

$a1 = @'
function navFoot(){const n=document.getElementById('nav');if(!n||n.querySelector('.nvf'))return;
'@
$b1 = @'
/*v24*/function navPad(){const n=document.getElementById('nav'),h=document.querySelector('header');if(!n||!h)return;n.style.paddingTop=nwMob()?(h.offsetHeight+8)+'px':''}
try{addEventListener('resize',navPad)}catch(e){}
function navFoot(){const n=document.getElementById('nav');navPad();if(!n||n.querySelector('.nvf'))return;
'@
$a1 = $a1.TrimEnd().Replace("`r`n","`n")
$b1 = $b1.TrimEnd().Replace("`r`n","`n")
$n = ([regex]::Matches($js, [regex]::Escape($a1))).Count
if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n" }
$new = $js.Replace($a1, $b1)
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v24.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v24.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v24.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v24.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v24 terpasang. Cadangan di $env:TEMP (v8.js.v24.bak, index.html.v24.bak)"
