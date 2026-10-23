# Perbarui blok v8-js di public/index.html dengan v8.js terbaru (v8.1) dan perbaiki indikator OFFLINE (coba ulang 5 dtk sebelum OFFLINE). Idempoten.
$enc = New-Object System.Text.UTF8Encoding($false)
$root = Split-Path $PSScriptRoot -Parent
$p = Join-Path $root 'public\index.html'
$js = Join-Path $PSScriptRoot 'v8.js'
$h = [System.IO.File]::ReadAllText($p, $enc)
$n = [System.IO.File]::ReadAllText($js, $enc)
$a = $h.IndexOf('<script id="v8-js">')
if ($a -lt 0) { 'blok v8-js tidak ditemukan, dibatalkan'; return }
$b = $h.IndexOf('</script>', $a)
if ($b -lt 0) { 'penutup script tidak ditemukan, dibatalkan'; return }
$cur = $h.Substring($a, $b - $a)
if ($cur.Contains('/* v8.1:')) { 'blok sudah v8.1' }
else {
  Copy-Item $p (Join-Path $env:TEMP 'index.html.v81.bak') -Force
  $new = '<script id="v8-js">' + "`n" + $n + "`n"
  $h = $h.Substring(0, $a) + $new + $h.Substring($b)
  'blok v8 diganti ke v8.1'
}
$o = "catch(e){HL.fails=(HL.fails||0)+1;HL.err=String(e&&e.message||e);if(HL.fails>=2||HL.st==='idle')HL.st='err'}"
$w = "catch(e){HL.fails=(HL.fails||0)+1;HL.err=String(e&&e.message||e);if(HL.fails>=2)HL.st='err';else setTimeout(hlLoad,5000)}"
if ($h.Contains($o)) { $h = $h.Replace($o, $w); 'OFFLINE: coba ulang 5 dtk dipasang' } elseif ($h.Contains($w)) { 'OFFLINE sudah diperbarui' } else { 'pola OFFLINE tidak ditemukan (dilewati)' }
[System.IO.File]::WriteAllText($p, $h, $enc)
'ok: ' + $h.Length
