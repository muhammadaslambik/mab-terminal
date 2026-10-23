# Tambal public/index.html: ganti blok v7-js dengan v8.js dan perbaiki indikator OFFLINE. Idempoten.
$enc = New-Object System.Text.UTF8Encoding($false)
$root = Split-Path $PSScriptRoot -Parent
$p = Join-Path $root 'public\index.html'
$js = Join-Path $PSScriptRoot 'v8.js'
$h = [System.IO.File]::ReadAllText($p, $enc)
$n = [System.IO.File]::ReadAllText($js, $enc)
if ($h.Contains('id="v8-js"')) { 'sudah terpasang, tidak ada perubahan'; return }
$a = $h.IndexOf('<script id="v7-js">')
if ($a -lt 0) { 'blok v7-js tidak ditemukan, dibatalkan'; return }
$b = $h.IndexOf('</script>', $a)
if ($b -lt 0) { 'penutup script tidak ditemukan, dibatalkan'; return }
Copy-Item $p (Join-Path $env:TEMP 'index.html.v8.bak') -Force
$new = '<script id="v8-js">' + "`n" + $n + "`n" + '</script>'
$h = $h.Substring(0, $a) + $new + $h.Substring($b + 9)
$o = "try{HL.data=await api('/api/health');HL.st='ok'}catch(e){HL.st='err';HL.err=String(e&&e.message||e)}"
$w = "try{HL.data=await api('/api/health');HL.st='ok';HL.fails=0}catch(e){HL.fails=(HL.fails||0)+1;HL.err=String(e&&e.message||e);if(HL.fails>=2||HL.st==='idle')HL.st='err'}"
if ($h.Contains($o)) { $h = $h.Replace($o, $w); 'OFFLINE diperbaiki' } else { 'pola OFFLINE tidak ditemukan (dilewati)' }
[System.IO.File]::WriteAllText($p, $h, $enc)
'ok: ' + $h.Length
