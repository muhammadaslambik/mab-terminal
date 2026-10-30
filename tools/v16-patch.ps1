# v16: URL per halaman (/indonesia, /amerika, /xauusd, /crypto, /news, /indonesia/analyzer?...) lewat History API.
# powershell -ExecutionPolicy Bypass -File tools\v16-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$block = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("Lyp2MTcqLwpjb25zdCBSVD1bJy8nLCcvZ2xvYmFsLWZsb3cnLCcvaW5kb25lc2lhJywnL2FtZXJpa2EnLCcveGF1dXNkJywnL2NyeXB0bycsJy9uZXdzJ107CmNvbnN0IEFOPVsKWydhbmRyeS1oYWtpbS9tdWx0aWJhZ2dlcicsJ0FuZHJ5IEhha2ltIMK3IE11bHRpYmFnZ2VyIChDYWNpbmctTmFnYSknLCdBbmRyeSBIYWtpbSDCtyBNdWx0aWJhZ2dlciAoV29ybS1EcmFnb24pJywnTXVsdGliYWdnZXIgPSBDYWNpbmctTmFnYToga29uc29saWRhc2kgc2VtcGl0IChjYWNpbmcpIGxhbHUgYnJlYWtvdXQgKG5hZ2EpLiBEYWZ0YXIgcGFudGF1YW4gZGkgYmF3YWggbnlhdGEsIGRhcmkgc2FyaW5nYW4gYmFja2VuZCAoVHJhZGluZ1ZpZXcsIFBhc2FyZGFuYSwgaW50ZWwgSURYKS4nLCdNdWx0aWJhZ2dlciA9IFdvcm0tRHJhZ29uOiB0aWdodCBjb25zb2xpZGF0aW9uICh3b3JtKSB0aGVuIGJyZWFrb3V0IChkcmFnb24pLiBUaGUgd2F0Y2hsaXN0IGJlbG93IGlzIHJlYWwsIGZyb20gdGhlIGJhY2tlbmQgc2NyZWVuIChUcmFkaW5nVmlldywgUGFzYXJkYW5hLCBJRFggaW50ZWwpLiddLApbJ2FuZHJ5LWhha2ltL3ZhbHVlLWludmVzdGluZycsJ0FuZHJ5IEhha2ltIMK3IFZhbHVlIEludmVzdGluZycsJ0FuZHJ5IEhha2ltIMK3IFZhbHVlIEludmVzdGluZycsJ0FuZHJ5IEhha2ltIHYuMTogdmFsdWUgaW52ZXN0aW5nLCBtZW5pbGFpIGRpc2tvbiBoYXJnYSB0ZXJoYWRhcCBuaWxhaSB3YWphci4nLCdBbmRyeSBIYWtpbSB2LjE6IHZhbHVlIGludmVzdGluZywganVkZ2luZyB0aGUgcHJpY2UgZGlzY291bnQgdG8gZmFpciB2YWx1ZS4nXSwKWydhbmRyeS1oYWtpbS9jb21iaW5hdGlvbicsJ0FuZHJ5IEhha2ltIMK3IEdhYnVuZ2FuJywnQW5kcnkgSGFraW0gwrcgQ29tYmluZWQnLCdBbmRyeSBIYWtpbSB2LjM6IGdhYnVuZ2FuIHZhbHVlIGludmVzdGluZyBkYW4gQ2FjaW5nLU5hZ2E7IGVudHJpIGhhbnlhIGppa2Ega2VkdWEgc2lueWFsIHNlbGFyYXMuJywnQW5kcnkgSGFraW0gdi4zOiB2YWx1ZSBpbnZlc3RpbmcgY29tYmluZWQgd2l0aCBXb3JtLURyYWdvbjsgZW50cnkgb25seSB3aGVuIGJvdGggc2lnbmFscyBhbGlnbi4nXSwKWydhc3Ryb25hY2NpJywnQXN0cm9uYWNjaSAoR2VtYSBHb2V5YXJkaSknLCdBc3Ryb25hY2NpIChHZW1hIEdvZXlhcmRpKScsJ0FzdHJvbmFjY2k6IHRpdGlrIGJhbGlrIGRhbiBoYXJtb25payBkZW5nYW4gbGV2ZWwgRmlib25hY2NpIHJldHJhY2VtZW50IDM4LDIlIGRhbiA2MSw4JS4nLCdBc3Ryb25hY2NpOiB0dXJuaW5nIHBvaW50cyBhbmQgaGFybW9uaWNzIHVzaW5nIEZpYm9uYWNjaSByZXRyYWNlbWVudCBsZXZlbHMgb2YgMzguMiUgYW5kIDYxLjglLiddLApbJ3JlbW9yYScsJ1JlbW9yYSAoSGVuZ2t5IEFkaW5hdGEpJywnUmVtb3JhIChIZW5na3kgQWRpbmF0YSknLCdSZW1vcmE6IG1lbWJhY2EgdGFwZSB0cmFuc2Frc2ksIHJhc2lvIEhBS0EgKGJlbGkgYWdyZXNpZikgdGVyaGFkYXAgSEFLSSAoanVhbCBhZ3Jlc2lmKS4gQnV0dWggZGF0YSB0YXBlIHlhbmcgdGlkYWsgdGVyc2VkaWEgZ3JhdGlzLicsJ1JlbW9yYTogcmVhZGluZyB0aGUgdHJhZGUgdGFwZSwgdGhlIHJhdGlvIG9mIEhBS0EgKGFnZ3Jlc3NpdmUgYnV5aW5nKSB0byBIQUtJIChhZ2dyZXNzaXZlIHNlbGxpbmcpLiBOZWVkcyB0YXBlIGRhdGEgdGhhdCBoYXMgbm8gZnJlZSBzb3VyY2UuJ10sClsnYmFzZWxpbmUnLCdCYXNlbGluZSBNQS9SU0kgKHBlbWJhbmRpbmcpJywnQmFzZWxpbmUgTUEvUlNJIChiZW5jaG1hcmspJywnUGVtYmFuZGluZyBzdGFuZGFyOiByYXRhLXJhdGEgYmVyZ2VyYWsgZGFuIFJTSSBkYXJpIHBlbnV0dXBhbiBoYXJpYW4gbnlhdGEsIGJ1a2FuIHRlb3JpIHBha2FyIHRlcnRlbnR1LicsJ0Egc3RhbmRhcmQgYmVuY2htYXJrOiBtb3ZpbmcgYXZlcmFnZSBhbmQgUlNJIGZyb20gcmVhbCBkYWlseSBjbG9zZXMsIG5vdCBhIHNwZWNpZmljIGV4cGVydCB0aGVvcnkuJ10sClsna2FsaW1hc2FkYScsJ0thbGltYXNhZGEgKEFrYWRlbWkgQ3J5cHRvKScsJ0thbGltYXNhZGEgKENyeXB0byBBY2FkZW15KScsJ0thbGltYXNhZGE6IGtvbmZpcm1hc2kgcG9sYSBkYW4gbGV2ZWwgYmFrdSAoc3VwcG9ydCBkYW4gcmVzaXN0YW5jZSkgZGVuZ2FuIGFyYWggcmF0YS1yYXRhIGJlcmdlcmFrLicsJ0thbGltYXNhZGE6IHBhdHRlcm4gY29uZmlybWF0aW9uIGFuZCBzdGFuZGFyZCBsZXZlbHMgKHN1cHBvcnQgYW5kIHJlc2lzdGFuY2UpIHdpdGggbW92aW5nIGF2ZXJhZ2UgZGlyZWN0aW9uLiddXTsKTlYuYW49bnVsbDsKZnVuY3Rpb24gdXJsU3RhdGUoKXtjb25zdCBwPShsb2NhdGlvbi5wYXRobmFtZS5yZXBsYWNlKC9cLyskLywnJyl8fCcvJykscGw9cC50b0xvd2VyQ2FzZSgpOwogaWYocGw9PT0nL2luZG9uZXNpYS9hbmFseXplcid8fHBsPT09Jy9pbmRvbmVzaWEvYW5hbHl6ZXInKXtsZXQgaz0nJzt0cnl7az1kZWNvZGVVUklDb21wb25lbnQobG9jYXRpb24uc2VhcmNoLnNsaWNlKDEpLnNwbGl0KCcmJylbMF0pLnJlcGxhY2UoLz0kLywnJykudG9Mb3dlckNhc2UoKX1jYXRjaChlKXt9aWYoaz09PSdhbmRyeS1oYWtpbS9jb21iaW5hdGlvbicpaz0nYW5kcnktaGFraW0vY29tYmluYXRpb24nO3JldHVybiB7aToyLGFuOkFOLnNvbWUoYT0+YVswXT09PWspP2s6JyonfX0KIGlmKHBsPT09Jy9iZXJpdGEnKXJldHVybiB7aTo2LGFuOm51bGx9OwogY29uc3Qgaj1SVC5maW5kSW5kZXgocj0+ci50b0xvd2VyQ2FzZSgpPT09cGwpO3JldHVybiB7aTpqPDA/MDpqLGFuOm51bGx9fQpjb25zdCB1cmxGb3I9KCk9PmN1cj09PTImJk5WLmFuPyhOVi5hbj09PScqJz8nL2luZG9uZXNpYS9hbmFseXplcic6Jy9pbmRvbmVzaWEvYW5hbHl6ZXI/JytOVi5hbik6KFJUW2N1cl18fCcvJyk7CmxldCBsYXN0VT1udWxsOwpmdW5jdGlvbiBzeW5jVXJsKCl7Y29uc3QgdT11cmxGb3IoKSxub3c9bG9jYXRpb24ucGF0aG5hbWUrbG9jYXRpb24uc2VhcmNoO3RyeXtpZihub3chPT11KXtpZihsYXN0VT09PW51bGx8fG5vdy50b0xvd2VyQ2FzZSgpPT09dS50b0xvd2VyQ2FzZSgpKWhpc3RvcnkucmVwbGFjZVN0YXRlKG51bGwsJycsdSk7ZWxzZSBoaXN0b3J5LnB1c2hTdGF0ZShudWxsLCcnLHUpfX1jYXRjaChlKXt9bGFzdFU9dTtjb25zdCBhPWN1cj09PTImJk5WLmFuP0FOLmZpbmQoeD0+eFswXT09PU5WLmFuKTpudWxsO2RvY3VtZW50LnRpdGxlPShNW2N1cl0/TVtjdXJdLnQ6JycpKyhhPycgwrcgJythWzFdOicnKSsnIOKAlCBNQUItVGVybWluYWwnfQpjb25zdCBkMTY9d2luZG93LmRyYXcwO3dpbmRvdy5kcmF3MD1mdW5jdGlvbigpe2NvbnN0IHI9ZDE2LmFwcGx5KHRoaXMsYXJndW1lbnRzKTtzeW5jVXJsKCk7cmV0dXJuIHJ9OwpmdW5jdGlvbiBhcHBseVVybCgpe2NvbnN0IHM9dXJsU3RhdGUoKTtjdXI9cy5pO05WLmFuPXMuYW47c2VsPTA7cmVzPW51bGw7eHM9W107Y2M9ZmFsc2U7eHA9ZmFsc2U7bW49ZmFsc2U7c2lkZT1mYWxzZTt0cnl7enIoKX1jYXRjaChlKXt9bGFzdFU9bG9jYXRpb24ucGF0aG5hbWUrbG9jYXRpb24uc2VhcmNoO2RyYXcoKX0KYWRkRXZlbnRMaXN0ZW5lcigncG9wc3RhdGUnLGFwcGx5VXJsKTsKZnVuY3Rpb24gcnRHbyhlLGgpe2lmKGUmJihlLmN0cmxLZXl8fGUubWV0YUtleXx8ZS5zaGlmdEtleXx8ZS5idXR0b249PT0xKSlyZXR1cm4gdHJ1ZTt0cnl7aGlzdG9yeS5wdXNoU3RhdGUobnVsbCwnJyxoKX1jYXRjaCh4KXt9YXBwbHlVcmwoKTtzY3JvbGxUbygwLDApO3JldHVybiBmYWxzZX0KWydnb1RvJywnZ29Ib21lJ10uZm9yRWFjaChuPT57Y29uc3Qgbz13aW5kb3dbbl07aWYodHlwZW9mIG89PT0nZnVuY3Rpb24nKXdpbmRvd1tuXT1mdW5jdGlvbiguLi5hKXtOVi5hbj1udWxsO3JldHVybiBvLmFwcGx5KHRoaXMsYSl9fSk7Cntjb25zdCBzMD11cmxTdGF0ZSgpO2N1cj1zMC5pO05WLmFuPXMwLmFufQpjb25zdCBhbkxpbmtzPWs9PmA8ZGl2IGNsYXNzPSJjYXJkIj48ZGl2IGNsYXNzPSJwaCI+JHtTKCdBTkFMSVNBIFBBS0FSJywnRVhQRVJUIEFOQUxZU0lTJyl9PC9kaXY+PGRpdiBjbGFzcz0idjh0IiBzdHlsZT0icG9zaXRpb246c3RhdGljO21hcmdpbjowO3BhZGRpbmc6MDtiYWNrZ3JvdW5kOm5vbmUiPjxkaXYgY2xhc3M9InRmcyI+JHtBTi5tYXAoYT0+YDxhIGNsYXNzPSJjaGlwICR7az09PWFbMF0/J29uJzonJ30iIHN0eWxlPSJ0ZXh0LWRlY29yYXRpb246bm9uZSIgaHJlZj0iL2luZG9uZXNpYS9hbmFseXplcj8ke2FbMF19IiBvbmNsaWNrPSJyZXR1cm4gdjcucnQoZXZlbnQsdGhpcy5nZXRBdHRyaWJ1dGUoJ2hyZWYnKSkiPiR7RShTKGFbMV0sYVsyXSkpfTwvYT5gKS5qb2luKCcnKX08L2Rpdj48L2Rpdj48L2Rpdj5gOwpmdW5jdGlvbiBhblBhZ2UoKXsKIGNvbnN0IGs9TlYuYW4sYT1BTi5maW5kKHg9PnhbMF09PT1rKSxpdD1JRFguZmluZCh4PT54WzBdPT09TlYuc2VsLmlkKXx8SURYWzBdLHg9cShpdFswXSkscD14JiZ4LnBlcmZ8fHt9OwogY29uc3QgdGFicz1gPGRpdiBjbGFzcz0idGFicyI+JHtJRFgubWFwKGw9PmA8c3BhbiBjbGFzcz0iJHtsWzBdPT09aXRbMF0/J29uJzonJ30iIG9uY2xpY2s9InY3LnNlbCgnaWQnLCcke2xbMF19JykiPiR7RShsWzBdKX08L3NwYW4+YCkuam9pbignJyl9PC9kaXY+YDsKIGNvbnN0IGdsPWs9PT0nYmFzZWxpbmUnP1MoJ0FOQUxJU0EgVEVLTklLQUwgSEFSSUFOJywnREFJTFkgVEVDSE5JQ0FMIEFOQUxZU0lTJyk6UygnUEVNQkFORElORzogQU5BTElTQSBURUtOSUtBTCBVTVVNJywnUkVGRVJFTkNFOiBHRU5FUkFMIFRFQ0hOSUNBTCBBTkFMWVNJUycpOwogY29uc3QgZ2VuPXg/YDxkaXYgY2xhc3M9ImNhcmQiPjxkaXYgY2xhc3M9InBoIj4ke2dsfSDigJQgJHtFKGl0WzBdKX08L2Rpdj48ZGl2IHN0eWxlPSJmb250LXNpemU6MjBweCI+PGIgc3R5bGU9ImNvbG9yOnZhcigtLXcpIj4ke25mKHgucHJpY2UpfTwvYj4gPHNwYW4gY2xhc3M9Im0iIHN0eWxlPSJmb250LXNpemU6MTNweCI+JHtFKHguY3VycmVuY3l8fCcnKX08L3NwYW4+IDxzcGFuIGNsYXNzPSIke2NsKHAuZDEpfSI+JHtzcChwLmQxKX08L3NwYW4+IDxzcGFuIGNsYXNzPSJtIiBzdHlsZT0iZm9udC1zaXplOjEycHgiPiR7d2liKHguYXNPZil9PC9zcGFuPjwvZGl2PiR7YW5IdG1sKHgpfTwvZGl2PmA6YDxkaXYgY2xhc3M9ImNhcmQgbSI+JHtFKGl0WzBdKX06ICR7UygndGlkYWsgdGVyc2VkaWEgZGFyaSBzdW1iZXInLCdub3QgYXZhaWxhYmxlIGZyb20gc291cmNlJyl9PC9kaXY+YDsKIGNvbnN0IGludHJvPWE/YDxkaXYgY2xhc3M9ImNhcmQiPjxkaXYgY2xhc3M9InBoIj4ke0UoUyhhWzFdLGFbMl0pKX08L2Rpdj48ZGl2IGNsYXNzPSJtIj4ke0UoUyhhWzNdLGFbNF0pKX08L2Rpdj5gOicnOwogbGV0IGJvZHk7CiBpZighYSlib2R5PWA8ZGl2IGNsYXNzPSJjYXJkIG0iPiR7UygnUGlsaWggc2FsYWggc2F0dSBhbmFsaXNhIHBha2FyIGRpIGF0YXMuJywnUGljayBvbmUgb2YgdGhlIGV4cGVydCBhbmFseXNlcyBhYm92ZS4nKX08L2Rpdj5gOwogZWxzZSBpZihrPT09J2FuZHJ5LWhha2ltL211bHRpYmFnZ2VyJylib2R5PWludHJvKyc8L2Rpdj4nKyh0eXBlb2YgY2FjSHRtbD09PSdmdW5jdGlvbic/Y2FjSHRtbCgpOicnKTsKIGVsc2UgaWYoaz09PSdiYXNlbGluZScpYm9keT1pbnRybysnPC9kaXY+Jyt0YWJzK2dlbjsKIGVsc2UgYm9keT1pbnRybytgPGRpdiBzdHlsZT0iY29sb3I6dmFyKC0tYSk7bWFyZ2luLXRvcDo4cHgiPiR7UygnTWV0b2RlIGluaSBiZWx1bSBkaWltcGxlbWVudGFzaWthbiBkZW5nYW4gZGF0YSBueWF0YSwgamFkaSBiZWx1bSBhZGEgc2lueWFsIGRhcmkgcGFrYXIgaW5pLiBZYW5nIHRhbXBpbCBkaSBiYXdhaCBoYW55YSBwZW1iYW5kaW5nLicsJ1RoaXMgbWV0aG9kIGlzIG5vdCB5ZXQgaW1wbGVtZW50ZWQgd2l0aCByZWFsIGRhdGEsIHNvIHRoZXJlIGlzIG5vIHNpZ25hbCBmcm9tIHRoaXMgZXhwZXJ0IHlldC4gV2hhdCBhcHBlYXJzIGJlbG93IGlzIGEgcmVmZXJlbmNlIG9ubHkuJyl9PC9kaXY+PC9kaXY+YCt0YWJzK2dlbjsKIHJldHVybiBoZWFkKFMoJ0FuYWxpc2EgUGFrYXIg4oCUIFNhaGFtIEluZG9uZXNpYScsJ0V4cGVydCBBbmFseXNpcyDigJQgSW5kb25lc2lhbiBTdG9ja3MnKSkrYDxkaXYgY2xhc3M9ImNhcmQiPjxhIGNsYXNzPSJjaGlwIiBzdHlsZT0idGV4dC1kZWNvcmF0aW9uOm5vbmUiIGhyZWY9Ii9pbmRvbmVzaWEiIG9uY2xpY2s9InJldHVybiB2Ny5ydChldmVudCx0aGlzLmdldEF0dHJpYnV0ZSgnaHJlZicpKSI+4oaQICR7UygnU2FoYW0gSW5kb25lc2lhJywnSW5kb25lc2lhbiBTdG9ja3MnKX08L2E+PC9kaXY+YCthbkxpbmtzKGspK2JvZHl9Cg==")).Replace("`r`n","`n").TrimEnd() + "`n"
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/indonesia/analisa")) {
  $bk1 = Join-Path $env:TEMP "v8.js.v16.bak"
  $bk2 = Join-Path $env:TEMP "index.html.v16.bak"
  if (-not (Test-Path -LiteralPath $bk1) -or -not (Test-Path -LiteralPath $bk2)) { throw "v16 lama terpasang tetapi cadangan di TEMP tidak ada. Berhenti." }
  Copy-Item -LiteralPath $bk1 -Destination $jsP -Force
  Copy-Item -LiteralPath $bk2 -Destination $htP -Force
  Write-Host "v16 lama dipulihkan dari cadangan, lanjut memasang versi baru"
  $js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
  $ht = [IO.File]::ReadAllText($htP, $enc)
}
if ($js.Contains("/indonesia/analyzer")) { Write-Host "SKIP: v16 versi baru sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v15*/")) { throw "v15 belum terpasang" }
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
$new = $js
$a1 = @'
window.v7={fxn:o=>{NV.fxn=o},
'@
$b1 = @'
@@BLOCK@@window.v7={rt:rtGo,nav:()=>{NV.an=null},fxn:o=>{NV.fxn=o},
'@
$a1 = $a1.TrimEnd()
$b1 = $b1.TrimEnd().Replace("@@BLOCK@@", $block)
$new = Rep $new $a1 $b1
$a2 = @'
id:()=>assetPage({key:'id',
'@
$b2 = @'
id:()=>NV.an?anPage():assetPage({key:'id',
'@
$a2 = $a2.TrimEnd()
$b2 = $b2.TrimEnd().Replace("@@BLOCK@@", $block)
$new = Rep $new $a2 $b2
$a3 = @'
after:()=>`<div class="v8t"
'@
$b3 = @'
after:()=>anLinks()+`<div class="v8t"
'@
$a3 = $a3.TrimEnd()
$b3 = $b3.TrimEnd().Replace("@@BLOCK@@", $block)
$new = Rep $new $a3 $b3
$a4 = @'
<a class="${j==cur?'on':''}" onclick="cur=${j};sel=0;
'@
$b4 = @'
<a class="${j==cur?'on':''}" onclick="v7.nav();cur=${j};sel=0;
'@
$a4 = $a4.TrimEnd()
$b4 = $b4.TrimEnd().Replace("@@BLOCK@@", $block)
$new = Rep $new $a4 $b4
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v16.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v16.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v16.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v16.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v16 terpasang. Cadangan di $env:TEMP (v8.js.v16.bak, index.html.v16.bak)"
