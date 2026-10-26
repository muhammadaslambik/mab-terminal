# v11-patch.ps1 - bilah atas dan footer rapi di HP (CSS saja)
$ErrorActionPreference = 'Stop'
Set-Location 'E:\0\MAB Project\MAB-Terminal\mab-terminal'
$blk = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('Y29uc3QgdjExcz1kb2N1bWVudC5jcmVhdGVFbGVtZW50KCdzdHlsZScpO3YxMXMuaWQ9J3YxMS1jc3MnO3YxMXMudGV4dENvbnRlbnQ9JyNjcmJ7bGVmdDowIWltcG9ydGFudDtyaWdodDowIWltcG9ydGFudDt3aWR0aDphdXRvIWltcG9ydGFudDtiYWNrZ3JvdW5kOnZhcigtLWJnKSFpbXBvcnRhbnQ7Ym9yZGVyLXRvcDoxcHggc29saWQgdmFyKC0tYik7ei1pbmRleDoxMn0jYXBwe3BhZGRpbmctYm90dG9tOjM2cHh9QG1lZGlhKG1heC13aWR0aDo3MjBweCl7aGVhZGVye2ZsZXgtd3JhcDp3cmFwIWltcG9ydGFudDtnYXA6NnB4IDhweCFpbXBvcnRhbnQ7cGFkZGluZzo4cHggMTBweCFpbXBvcnRhbnR9aGVhZGVyPmRpdjpmaXJzdC1jaGlsZHtmbGV4OjEgMSAxMDAlIWltcG9ydGFudDtmbGV4LXdyYXA6d3JhcDtnYXA6NnB4IDhweCFpbXBvcnRhbnQ7bWluLXdpZHRoOjB9aGVhZGVyPmRpdjpmaXJzdC1jaGlsZD5zcGFuLCNnbWZ7ZGlzcGxheTpub25lIWltcG9ydGFudH0jdHRse2ZvbnQtc2l6ZToxNHB4fWhlYWRlcj5kaXY6bGFzdC1jaGlsZHtmbGV4OjEgMSAxMDAlIWltcG9ydGFudDtqdXN0aWZ5LWNvbnRlbnQ6c3BhY2UtYmV0d2Vlbn0jbXN0e21heC13aWR0aDoxMDAlfX0nO2RvY3VtZW50LmhlYWQuYXBwZW5kQ2hpbGQodjExcyk7'))
$jsPath = (Resolve-Path 'tools\v8.js').Path
$htPath = (Resolve-Path 'public\index.html').Path
$js = [IO.File]::ReadAllText($jsPath).Replace("`r`n","`n")
$ht = [IO.File]::ReadAllText($htPath).Replace("`r`n","`n")
if ($js.Contains('v11-css')) { 'v11 sudah terpasang. Tidak ada yang diubah.'; return }
$anchor = 'const PAGES={'
$n = ([regex]::Matches($js,[regex]::Escape($anchor))).Count
if ($n -ne 1) { throw "Anchor const PAGES={ harus tepat 1, ditemukan $n" }
$js2 = $js.Replace($anchor, $blk + "`n" + $anchor)
$tag = '<script id="v8-js">'
$i = $ht.IndexOf($tag); if ($i -lt 0) { throw 'Tag v8-js tidak ditemukan' }
$a = $i + $tag.Length
$z = $ht.IndexOf('</script>',$a); if ($z -lt 0) { throw 'Penutup </script> tidak ditemukan' }
$old = $ht.Substring($a,$z-$a)
if ($old.Trim() -ne $js.Trim()) { throw 'Blok v8-js di index.html TIDAK sama dengan tools\v8.js. Tidak ada yang diubah.' }
$lead = $old.Substring(0,$old.Length-$old.TrimStart().Length)
$trail = $old.Substring($old.TrimEnd().Length)
$ht2 = $ht.Substring(0,$a) + $lead + $js2.Trim() + $trail + $ht.Substring($z)
Copy-Item $jsPath "$env:TEMP\v8.js.v11.bak" -Force
Copy-Item $htPath "$env:TEMP\index.html.v11.bak" -Force
$u8 = New-Object Text.UTF8Encoding($false)
[IO.File]::WriteAllText($jsPath,$js2,$u8)
[IO.File]::WriteAllText($htPath,$ht2,$u8)
"v8.js: $((Get-Item $jsPath).Length) byte; index.html: $((Get-Item $htPath).Length) byte"
"v11-css di v8.js: $(([regex]::Matches([IO.File]::ReadAllText($jsPath),'v11-css')).Count); di index.html: $(([regex]::Matches([IO.File]::ReadAllText($htPath),'v11-css')).Count)"
if (Get-Command node -ErrorAction SilentlyContinue) { node --check $jsPath; "node --check v8.js: kode keluar $LASTEXITCODE" }
'Selesai.'
