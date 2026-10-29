# v12: panel 6 Rotasi sektor (3 tab) di Arus Global. Jalankan dari folder frontend:
# powershell -ExecutionPolicy Bypass -File tools\v12-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$snip = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String("LyogLS0tLSBQYW5lbCA2IHYxMjogcm90YXNpIHNla3RvciAoVHJhZGluZ1ZpZXcgc2Nhbm5lciBsZXdhdCAvYXBpL21hcmtldC9zZWN0b3JzKSAtLS0tICovCmNvbnN0IFNFQz17c3Q6J2lkbGUnLGF0OjAsZGF0YTpudWxsLGVycjpudWxsLGJ1c3k6ZmFsc2V9OwpOVi5zZWM9J3VzJztOVi5zZWNwPSdkMSc7CmFzeW5jIGZ1bmN0aW9uIHNlY0xvYWQoKXtpZihTRUMuYnVzeSlyZXR1cm47U0VDLmJ1c3k9dHJ1ZTt0cnl7Y29uc3Qgcj1hd2FpdCBmZXRjaCgnL2FwaS9tYXJrZXQvc2VjdG9ycycse2NhY2hlOiduby1zdG9yZSd9KTtpZighci5vayl0aHJvdyBuZXcgRXJyb3IoJ0hUVFAgJytyLnN0YXR1cyk7Y29uc3Qgaj1hd2FpdCByLmpzb24oKTtpZighanx8IUFycmF5LmlzQXJyYXkoai51cyl8fCFBcnJheS5pc0FycmF5KGouaWR4KXx8IUFycmF5LmlzQXJyYXkoai53b3JsZCkpdGhyb3cgbmV3IEVycm9yKGomJmouZXJyb3I/U3RyaW5nKGouZXJyb3IpOidmb3JtYXQgZGF0YSB0aWRhayBkaWtlbmFsJyk7U0VDLmRhdGE9ajtTRUMuc3Q9J29rJztTRUMuZXJyPW51bGx9Y2F0Y2goZSl7U0VDLnN0PSdlcnInO1NFQy5lcnI9U3RyaW5nKGUmJmUubWVzc2FnZXx8ZSl9U0VDLmF0PURhdGUubm93KCk7U0VDLmJ1c3k9ZmFsc2U7aWYoaXNGbG93KCkpcmQoKX0Kc2V0SW50ZXJ2YWwoKCk9PntpZihpc0Zsb3coKSYmIVNFQy5idXN5JiYhZG9jdW1lbnQuaGlkZGVuJiZEYXRlLm5vdygpLVNFQy5hdD49KFNFQy5lcnI/MTAwMDA6NjAwMDApKXNlY0xvYWQoKX0sNTAwMCk7CmNvbnN0IFNFQ1Q9W1sndXMnLCdTZWt0b3IgQVMnLCdVUyBzZWN0b3JzJ10sWydpZCcsJ1Nla3RvciBJbmRvbmVzaWEnLCdJbmRvbmVzaWEgc2VjdG9ycyddLFsnd2QnLCdOZWdhcmEgJiBvYmxpZ2FzaScsJ0NvdW50cmllcyAmIGJvbmRzJ11dOwpjb25zdCBTRUNQPVtbJ3l0ZCcsJ1lURCcsJ1lURCddLFsnbTMnLCczTScsJzNNJ10sWydtMScsJzFNJywnMU0nXSxbJ3cxJywnMVcnLCcxVyddLFsnZDEnLCcxRCcsJzFEJ11dOwpmdW5jdGlvbiBmeFA2KCl7CiBjb25zdCBkPVNFQy5kYXRhLHRhYj1OVi5zZWMsaWQ9dGFiPT09J2lkJyxjb2xzPWlkP1NFQ1AuZmlsdGVyKGM9PmNbMF0hPT0neXRkJyYmY1swXSE9PSdtMycpOlNFQ1AscGs9Y29scy5zb21lKGM9PmNbMF09PT1OVi5zZWNwKT9OVi5zZWNwOidkMSc7CiBjb25zdCBjdGw9YDxkaXYgY2xhc3M9InY4dCIgc3R5bGU9InBvc2l0aW9uOnN0YXRpYzttYXJnaW46MCAwIDZweDtwYWRkaW5nOjA7YmFja2dyb3VuZDpub25lIj48ZGl2IGNsYXNzPSJ0ZnMiPiR7U0VDVC5tYXAodD0+YDxzcGFuIGNsYXNzPSJjaGlwICR7dGFiPT09dFswXT8nb24nOicnfSIgb25jbGljaz0idjcuc2VjdCgnJHt0WzBdfScpIj4ke1ModFsxXSx0WzJdKX08L3NwYW4+YCkuam9pbignJyl9PC9kaXY+PGRpdiBjbGFzcz0idGZzIj4ke2NvbHMuc2xpY2UoKS5yZXZlcnNlKCkubWFwKGM9PmA8c3BhbiBjbGFzcz0iY2hpcCAke3BrPT09Y1swXT8nb24nOicnfSIgb25jbGljaz0idjcuc2VjcCgnJHtjWzBdfScpIj4ke1MoY1sxXSxjWzJdKX08L3NwYW4+YCkuam9pbignJyl9PC9kaXY+PC9kaXY+YDsKIGxldCBib2R5OwogaWYoIWQpYm9keT1gPGRpdiBjbGFzcz0iJHtTRUMuc3Q9PT0nZXJyJz8ncic6J20nfSI+JHtTRUMuc3Q9PT0nZXJyJz9FKFNFQy5lcnIpOlMoJ01lbXVhdCBkYXRhIHNla3RvcuKApicsJ0xvYWRpbmcgc2VjdG9yIGRhdGHigKYnKX08L2Rpdj5gOwogZWxzZXsKICBjb25zdCBzcmM9aWQ/ZC5pZHg6dGFiPT09J3dkJz9kLndvcmxkOmQudXMscm93cz1zcmMubWFwKHg9Pih7bmFtZTppZD94LnNlY3Rvcjp4Lm5hbWUsc3ViOmlkP3gubisnICcrUygnc2FoYW0nLCdzdG9ja3MnKSsnIMK3IFJwJytNYXRoLnJvdW5kKHgubWNhcC8xZTEyKSsnIFQnOngudCx2Onh9KSkuc29ydCgoYSxiKT0+KGlzTihiLnZbcGtdKT9iLnZbcGtdOi0xZTkpLShpc04oYS52W3BrXSk/YS52W3BrXTotMWU5KSksY209e307CiAgY29scy5mb3JFYWNoKGM9PntjbVtjWzBdXT1NYXRoLm1heCgxZS05LC4uLnJvd3MubWFwKHI9PmlzTihyLnZbY1swXV0pP01hdGguYWJzKHIudltjWzBdXSk6MCkpfSk7CiAgY29uc3QgY2VsbD0odixrKT0+e2lmKCFpc04odikpcmV0dXJuICc8dGQgY2xhc3M9ImZ4biI+4oCUPC90ZD4nO2NvbnN0IGFsPS4wOCsuNzIqTWF0aC5taW4oMSxNYXRoLmFicyh2KS9jbVtrXSk7cmV0dXJuIGA8dGQgc3R5bGU9ImJhY2tncm91bmQ6JHt2Pj0wP2ByZ2JhKDk1LDIxNCwxMzgsJHthbH0pYDpgcmdiYSgyNDAsMTMwLDEwOCwke2FsfSlgfTske2s9PT1waz8nb3V0bGluZToxcHggc29saWQgI2Q5YTQ0MTsnOicnfSI+JHtmMih2KX08L3RkPmB9OwogIGJvZHk9cm93cy5sZW5ndGg/YDxkaXYgc3R5bGU9Im92ZXJmbG93LXg6YXV0byI+PHRhYmxlIGNsYXNzPSJmeGgiPjx0cj48dGg+PC90aD4ke2NvbHMubWFwKGM9PmA8dGg+JHtjWzFdfTwvdGg+YCkuam9pbignJyl9PC90cj4ke3Jvd3MubWFwKHI9PmA8dHI+PHRkIGNsYXNzPSJmYyI+JHtFKHIubmFtZSl9PHNwYW4gY2xhc3M9ImZ4c3ViIiBzdHlsZT0id2hpdGUtc3BhY2U6bm9ybWFsIj4ke0Uoci5zdWJ8fCcnKX08L3NwYW4+PC90ZD4ke2NvbHMubWFwKGM9PmNlbGwoci52W2NbMF1dLGNbMF0pKS5qb2luKCcnKX08L3RyPmApLmpvaW4oJycpfTwvdGFibGU+PC9kaXY+YDpgPGRpdiBjbGFzcz0ibSI+JHtTKCdEYXRhIGJlbHVtIHRlcnNlZGlhIHVudHVrIHRhYiBpbmkuJywnTm8gZGF0YSBmb3IgdGhpcyB0YWIuJyl9PC9kaXY+YDsKICBib2R5Kz1gPGRpdiBjbGFzcz0ibSIgc3R5bGU9ImZvbnQtc2l6ZToxMnB4O21hcmdpbi10b3A6NnB4Ij4ke1MoJ0RpdXJ1dGthbiBtZW51cnV0IHBlcmlvZGUgdGVycGlsaWguIFdhcm5hID0gYmVzYXIgcGVydWJhaGFuIHJlbGF0aWYgZGFsYW0ga29sb21ueWEgc2VuZGlyaTsgYmFjYSBkYXJpIGthbmFuIGtlIGtpcmkgKDFEIOKGkiBZVEQpIHVudHVrIG1lbGloYXQgcm90YXNpLiBJbmkgcGVydWJhaGFuIEhBUkdBLCBidWthbiBhcnVzIGRhbmEuICcsJ1NvcnRlZCBieSB0aGUgc2VsZWN0ZWQgcGVyaW9kLiBDb2xvciA9IHNpemUgb2YgY2hhbmdlIHJlbGF0aXZlIHRvIGl0cyBvd24gY29sdW1uOyByZWFkIHJpZ2h0IHRvIGxlZnQgKDFEIOKGkiBZVEQpIHRvIHNlZSByb3RhdGlvbi4gVGhpcyBpcyBQUklDRSBjaGFuZ2UsIG5vdCBmdW5kIGZsb3cuICcpfSR7aWQ/UygnU2VrdG9yIEluZG9uZXNpYSA9IHJhdGEtcmF0YSB0ZXJ0aW1iYW5nIGthcGl0YWxpc2FzaSBzZWx1cnVoIHNhaGFtIElEWCBkZW5nYW4ga2xhc2lmaWthc2kgc2VrdG9yIFRyYWRpbmdWaWV3IChidWthbiBJRFgtSUMpLiAnLCdJbmRvbmVzaWEgc2VjdG9ycyA9IG1hcmtldC1jYXAtd2VpZ2h0ZWQgYXZlcmFnZSBvZiBhbGwgSURYIHN0b2NrcyB1c2luZyBUcmFkaW5nVmlldyBzZWN0b3IgY2xhc3NpZmljYXRpb24gKG5vdCBJRFgtSUMpLiAnKTp0YWI9PT0nd2QnP1MoJ05lZ2FyYSBkYW4gb2JsaWdhc2kgbWVtYWthaSBFVEYgQVMgKGRhbGFtIGRvbGFyKSBzZWJhZ2FpIHByb2tzaTogRVdKLCBGWEksIEVXWiwgRVdHLCBFV1UsIEVXWSwgRVdULCBFSURPLCBUTFQsIElFRi4gJywnQ291bnRyaWVzIGFuZCBib25kcyB1c2UgVVMtbGlzdGVkIEVURnMgKGluIFVTRCkgYXMgcHJveGllczogRVdKLCBGWEksIEVXWiwgRVdHLCBFV1UsIEVXWSwgRVdULCBFSURPLCBUTFQsIElFRi4gJyk6UygnU2VrdG9yIEFTIG1lbWFrYWkgMTEgRVRGIHNla3RvciBTUERSIChYTEssIFhMRiwgZHN0Likgc2ViYWdhaSBwcm9rc2kuICcsJ1VTIHNlY3RvcnMgdXNlIHRoZSAxMSBTUERSIHNlY3RvciBFVEZzIChYTEssIFhMRiwgZXRjLikgYXMgcHJveGllcy4gJyl9JHtTKCdQYXNhciBBUyBoYW55YSBiZXJnZXJhayBzYWF0IGJ1cnNhIGJ1a2EuIFN1bWJlcjogVHJhZGluZ1ZpZXcgc2Nhbm5lciAoZ3JhdGlzLCB0aWRhayByZXNtaSkuIERpcGVyYmFydWkgJywnVGhlIFVTIG1hcmtldCBvbmx5IG1vdmVzIHdoaWxlIG9wZW4uIFNvdXJjZTogVHJhZGluZ1ZpZXcgc2Nhbm5lciAoZnJlZSwgdW5vZmZpY2lhbCkuIFVwZGF0ZWQgJyl9JHt3aWIoZC51cGRhdGVkQXQpfS4ke2QuZXJyb3JzJiZkLmVycm9ycy5sZW5ndGg/YCA8c3BhbiBzdHlsZT0iY29sb3I6dmFyKC0tYSkiPiR7RShkLmVycm9ycy5qb2luKCc7ICcpKX08L3NwYW4+YDonJ308L2Rpdj5gfQogcmV0dXJuIGA8ZGl2IGNsYXNzPSJjYXJkIj48ZGl2IGNsYXNzPSJwaCI+JHtTKCdST1RBU0kgU0VLVE9SIFNBSEFNIERVTklBJywnV09STEQgU1RPQ0sgU0VDVE9SIFJPVEFUSU9OJyl9PHNwYW4gY2xhc3M9ImZ4cyI+JHtTKCdlc3RpbWFzaSBkYXJpIGhhcmdhLCBidWthbiBhcnVzIGRhbmEgbnlhdGEnLCdlc3RpbWF0ZWQgZnJvbSBwcmljZSwgbm90IHJlYWwgZnVuZCBmbG93cycpfTwvc3Bhbj48L2Rpdj4ke2N0bH0ke2JvZHl9PC9kaXY+YH0K")).Replace("`r`n","`n").TrimEnd() + "`n"
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("Panel 6 v12")) { Write-Host "SKIP: v12 sudah terpasang"; exit 0 }
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
function flowNew(){
'@
$a2 = @'
if(FX.st==='idle'&&!FX.busy)setTimeout(fxLoad,0);
'@
$a3 = @'
+p5+p6+PAGES.flowOld()}
'@
$a4 = @'
fxr:()=>{window.rdLoad(true);fxLoad()},
'@
$a1 = $a1.TrimEnd(); $a2 = $a2.TrimEnd(); $a3 = $a3.TrimEnd(); $a4 = $a4.TrimEnd()
$new = $js
$new = Rep $new $a1 ($snip + $a1)
$new = Rep $new $a2 ($a2 + "if(SEC.st==='idle'&&!SEC.busy)setTimeout(secLoad,0);")
$new = Rep $new $a3 "+p5+fxP6()+PAGES.flowOld()}"
$new = Rep $new $a4 "fxr:()=>{window.rdLoad(true);fxLoad();secLoad()},sect:k=>{NV.sec=k;rd()},secp:p=>{NV.secp=p;rd()},"

Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v12.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v12.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v12.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v12.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v12 terpasang. Cadangan di $env:TEMP (v8.js.v12.bak, index.html.v12.bak)"
