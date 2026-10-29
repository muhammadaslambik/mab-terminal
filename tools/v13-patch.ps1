# v13: panel 6 jadi diagram alir (ganti isi fxP6). Jalankan dari folder frontend:
# powershell -ExecutionPolicy Bypass -File tools\v13-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$snip = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("ZnVuY3Rpb24gZnhQNigpey8qdjEzKi8KIGNvbnN0IGQ9U0VDLmRhdGEsdGFiPU5WLnNlYyxpZD10YWI9PT0naWQnLGNvbHM9aWQ/U0VDUC5maWx0ZXIoYz0+Y1swXSE9PSd5dGQnJiZjWzBdIT09J20zJyk6U0VDUCxwaz1jb2xzLnNvbWUoYz0+Y1swXT09PU5WLnNlY3ApP05WLnNlY3A6J2QxJzsKIGNvbnN0IGN0bD1gPGRpdiBjbGFzcz0idjh0IiBzdHlsZT0icG9zaXRpb246c3RhdGljO21hcmdpbjowIDAgNnB4O3BhZGRpbmc6MDtiYWNrZ3JvdW5kOm5vbmUiPjxkaXYgY2xhc3M9InRmcyI+JHtTRUNULm1hcCh0PT5gPHNwYW4gY2xhc3M9ImNoaXAgJHt0YWI9PT10WzBdPydvbic6Jyd9IiBvbmNsaWNrPSJ2Ny5zZWN0KCcke3RbMF19JykiPiR7Uyh0WzFdLHRbMl0pfTwvc3Bhbj5gKS5qb2luKCcnKX08L2Rpdj48ZGl2IGNsYXNzPSJ0ZnMiPiR7Y29scy5zbGljZSgpLnJldmVyc2UoKS5tYXAoYz0+YDxzcGFuIGNsYXNzPSJjaGlwICR7cGs9PT1jWzBdPydvbic6Jyd9IiBvbmNsaWNrPSJ2Ny5zZWNwKCcke2NbMF19JykiPiR7UyhjWzFdLGNbMl0pfTwvc3Bhbj5gKS5qb2luKCcnKX08L2Rpdj48L2Rpdj5gOwogbGV0IGJvZHk7CiBpZighZClib2R5PWA8ZGl2IGNsYXNzPSIke1NFQy5zdD09PSdlcnInPydyJzonbSd9Ij4ke1NFQy5zdD09PSdlcnInP0UoU0VDLmVycik6UygnTWVtdWF0IGRhdGEgc2VrdG9y4oCmJywnTG9hZGluZyBzZWN0b3IgZGF0YeKApicpfTwvZGl2PmA7CiBlbHNlewogIGNvbnN0IG53PWZ4TmFycm93KCksc3JjPWlkP2QuaWR4OnRhYj09PSd3ZCc/ZC53b3JsZDpkLnVzLGl0ZW1zPXNyYy5maWx0ZXIoeD0+aXNOKHhbcGtdKSYmTWF0aC5hYnMoeFtwa10pPj0wLjAwNSkubWFwKHg9Pntjb25zdCBmdWxsPWlkP3guc2VjdG9yOngubmFtZTtyZXR1cm4ge246bnc/KGlkP2Z1bGwuc2xpY2UoMCw5KTp4LnQpOmZ1bGwsejp4W3BrXSx0OmYyKHhbcGtdKX19KTsKICBib2R5PShpdGVtcy5sZW5ndGg/ZnhTayhpdGVtcyk6YDxkaXYgY2xhc3M9Im0iPiR7UygnRGF0YSBiZWx1bSB0ZXJzZWRpYSB1bnR1ayB0YWIgaW5pLicsJ05vIGRhdGEgZm9yIHRoaXMgdGFiLicpfTwvZGl2PmApK2A8ZGl2IGNsYXNzPSJtIiBzdHlsZT0iZm9udC1zaXplOjEycHg7bWFyZ2luLXRvcDo2cHgiPiR7UygnS2lyaSA9IHNla3RvciB5YW5nIHR1cnVuLCBrYW5hbiA9IHlhbmcgbmFpayBwYWRhIHBlcmlvZGUgdGVycGlsaWggKGxlYmFyIGJhbG9rID0gYmVzYXIgcGVydWJhaGFuIGhhcmdhKS4gUGl0YSBoYW55YSBpbHVzdHJhc2kgcGVyYmFuZGluZ2FuLCBidWthbiBhcnVzIGRhbmEgbnlhdGEuICcsJ0xlZnQgPSBzZWN0b3JzIGZhbGxpbmcsIHJpZ2h0ID0gcmlzaW5nIG92ZXIgdGhlIHNlbGVjdGVkIHBlcmlvZCAoYmFyIHNpemUgPSBzaXplIG9mIHRoZSBwcmljZSBjaGFuZ2UpLiBSaWJib25zIG9ubHkgaWxsdXN0cmF0ZSB0aGUgY29tcGFyaXNvbiwgbm90IHJlYWwgZnVuZCBmbG93cy4gJyl9JHtpZD9TKCdTZWt0b3IgSW5kb25lc2lhID0gcmF0YS1yYXRhIHRlcnRpbWJhbmcga2FwaXRhbGlzYXNpIHNlbHVydWggc2FoYW0gSURYIGRlbmdhbiBrbGFzaWZpa2FzaSBzZWt0b3IgVHJhZGluZ1ZpZXcgKGJ1a2FuIElEWC1JQykuICcsJ0luZG9uZXNpYSBzZWN0b3JzID0gbWFya2V0LWNhcC13ZWlnaHRlZCBhdmVyYWdlIG9mIGFsbCBJRFggc3RvY2tzIHVzaW5nIFRyYWRpbmdWaWV3IHNlY3RvciBjbGFzc2lmaWNhdGlvbiAobm90IElEWC1JQykuICcpOnRhYj09PSd3ZCc/UygnTmVnYXJhIGRhbiBvYmxpZ2FzaSBtZW1ha2FpIEVURiBBUyAoZGFsYW0gZG9sYXIpIHNlYmFnYWkgcHJva3NpOiBFV0osIEZYSSwgRVdaLCBFV0csIEVXVSwgRVdZLCBFV1QsIEVJRE8sIFRMVCwgSUVGLiAnLCdDb3VudHJpZXMgYW5kIGJvbmRzIHVzZSBVUy1saXN0ZWQgRVRGcyAoaW4gVVNEKSBhcyBwcm94aWVzOiBFV0osIEZYSSwgRVdaLCBFV0csIEVXVSwgRVdZLCBFV1QsIEVJRE8sIFRMVCwgSUVGLiAnKTpTKCdTZWt0b3IgQVMgbWVtYWthaSAxMSBFVEYgc2VrdG9yIFNQRFIgKFhMSywgWExGLCBkc3QuKSBzZWJhZ2FpIHByb2tzaS4gJywnVVMgc2VjdG9ycyB1c2UgdGhlIDExIFNQRFIgc2VjdG9yIEVURnMgKFhMSywgWExGLCBldGMuKSBhcyBwcm94aWVzLiAnKX0ke1MoJ1Bhc2FyIEFTIGhhbnlhIGJlcmdlcmFrIHNhYXQgYnVyc2EgYnVrYS4gU3VtYmVyOiBUcmFkaW5nVmlldyBzY2FubmVyIChncmF0aXMsIHRpZGFrIHJlc21pKS4gRGlwZXJiYXJ1aSAnLCdUaGUgVVMgbWFya2V0IG9ubHkgbW92ZXMgd2hpbGUgb3Blbi4gU291cmNlOiBUcmFkaW5nVmlldyBzY2FubmVyIChmcmVlLCB1bm9mZmljaWFsKS4gVXBkYXRlZCAnKX0ke3dpYihkLnVwZGF0ZWRBdCl9LiR7ZC5lcnJvcnMmJmQuZXJyb3JzLmxlbmd0aD9gIDxzcGFuIHN0eWxlPSJjb2xvcjp2YXIoLS1hKSI+JHtFKGQuZXJyb3JzLmpvaW4oJzsgJykpfTwvc3Bhbj5gOicnfTwvZGl2PmB9CiByZXR1cm4gYDxkaXYgY2xhc3M9ImNhcmQiPjxkaXYgY2xhc3M9InBoIj4ke1MoJ1JPVEFTSSBTRUtUT1IgU0FIQU0gRFVOSUEnLCdXT1JMRCBTVE9DSyBTRUNUT1IgUk9UQVRJT04nKX08c3BhbiBjbGFzcz0iZnhzIj4ke1MoJ2RpYWdyYW0gYWxpciDCtyBlc3RpbWFzaSBkYXJpIGhhcmdhLCBidWthbiBhcnVzIGRhbmEgbnlhdGEnLCdmbG93IGRpYWdyYW0gwrcgZXN0aW1hdGVkIGZyb20gcHJpY2UsIG5vdCByZWFsIGZ1bmQgZmxvd3MnKX08L3NwYW4+PC9kaXY+JHtjdGx9JHtib2R5fTwvZGl2PmB9Cg==")).Replace("`r`n","`n").TrimEnd() + "`n"
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v13*/")) { Write-Host "SKIP: v13 sudah terpasang"; exit 0 }
if (-not $js.Contains("Panel 6 v12")) { throw "v12 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }
$m1 = 'function fxP6(){'
$m2 = 'function flowNew(){'
if (([regex]::Matches($js, [regex]::Escape($m1))).Count -ne 1) { throw "Penanda fxP6 harus 1 kali" }
if (([regex]::Matches($js, [regex]::Escape($m2))).Count -ne 1) { throw "Penanda flowNew harus 1 kali" }
$si = $js.IndexOf($m1); $ei = $js.IndexOf($m2)
if ($ei -le $si) { throw "Urutan penanda salah" }
$new = $js.Substring(0, $si) + $snip + $js.Substring($ei)

Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v13.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v13.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v13.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v13.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v13 terpasang. Cadangan di $env:TEMP (v8.js.v13.bak, index.html.v13.bak)"
