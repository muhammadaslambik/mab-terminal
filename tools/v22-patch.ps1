# v22: header mobile lebih ringkas.
#  - layar <=720px: tombol "Beranda" dan ikon grid/menu strip di header disembunyikan (Beranda tetap ada di menu hamburger)
#  - header satu baris bila muat (hamburger + judul di kiri; akun, ID/EN, jam di kanan), turun ke dua baris hanya bila layar sempit
#  - rongga di atas header: hapus viewport-fit=cover agar halaman tidak didorong turun setinggi status bar
#  Desktop tidak berubah (semua aturan CSS ada di dalam @media(max-width:720px)).
# powershell -ExecutionPolicy Bypass -File tools\v22-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v22*/")) { Write-Host "SKIP: v22 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v21*/")) { throw "v21 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }

# --- anchor JS: sisipkan gaya v22 sebelum gaya v18 (setelah v11, jadi menang di cascade) ---
$a1 = @'
/*v18*/{const s=document.createElement('style');s.id='v18-css';
'@
$b1 = @'
/*v22*/{const s=document.createElement('style');s.id='v22-css';s.textContent='@media(max-width:720px){#hmb,#mtb,#mst{display:none!important}header{padding:6px 10px!important;gap:4px 8px!important}header>div:first-child{flex:1 1 auto!important;flex-wrap:nowrap!important}header>div:last-child{flex:0 1 auto!important;justify-content:flex-end!important}#ttl{white-space:nowrap}}';document.head.appendChild(s)}
/*v18*/{const s=document.createElement('style');s.id='v18-css';
'@
$a1 = $a1.TrimEnd().Replace("`r`n","`n")
$b1 = $b1.TrimEnd().Replace("`r`n","`n")
$n = ([regex]::Matches($js, [regex]::Escape($a1))).Count
if ($n -ne 1) { throw "Anchor JS harus cocok 1 kali, ditemukan $n" }

# --- anchor HTML: meta viewport ---
$m0 = '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">'
$m1 = '<meta name="viewport" content="width=device-width, initial-scale=1">'
$nm = ([regex]::Matches($ht, [regex]::Escape($m0))).Count
if ($nm -ne 1) { throw "Meta viewport harus cocok 1 kali, ditemukan $nm" }

$new = $js.Replace($a1, $b1)
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v22.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v22.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
$newHt = $newHt.Replace($m0, $m1)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v22.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v22.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v22 terpasang. Cadangan di $env:TEMP (v8.js.v22.bak, index.html.v22.bak)"
