# v21: perbaikan scroll kolom berita desktop (menggantikan perilaku v20 untuk desktop).
#  - kolom nonaktif: tidak menahan gulir, halaman bebas digulir
#  - kolom aktif (setelah diklik): roda mouse HANYA menggulir kolom, tidak pernah bocor ke halaman (termasuk di batas atas/bawah)
#  - keluar dari mode hanya lewat klik di luar kolom atau tombol "Tutup" di dalam kolom
#  - status aktif dan posisi gulir bertahan saat halaman digambar ulang oleh pembaruan data
# powershell -ExecutionPolicy Bypass -File tools\v21-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v21*/")) { Write-Host "SKIP: v21 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v20*/")) { throw "v20 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }

# --- anchor 1: CSS kolom (tanpa overscroll-behavior pada kolom nonaktif; tombol Tutup) ---
$a1 = @'
.nsc{max-height:62vh;overflow:hidden;overscroll-behavior:contain;cursor:pointer;border-radius:6px}.nsc.act{overflow:auto;cursor:auto;box-shadow:0 0 0 1px var(--a)}
'@
$b1 = @'
.nsc{max-height:62vh;overflow:hidden;cursor:pointer;border-radius:6px}.nsc.act{overflow:auto;cursor:auto;overscroll-behavior:contain;box-shadow:0 0 0 1px var(--a)}.nsxw{display:none}.nsc.act .nsxw{display:block;position:sticky;top:0;z-index:3;height:0;text-align:right;overflow:visible}.nsx{background:var(--p);color:var(--a);border:1px solid var(--a);border-radius:6px;padding:2px 10px;font:600 12px system-ui;cursor:pointer;margin:2px 4px 0 0}
'@
# --- anchor 2: nwBody desktop memanggil nwCol ---
$a2 = @'
if(!nwMob())return `<div class="nsc" title="${S('Klik di dalam kolom untuk mulai menggulir','Click inside the column to start scrolling')}">${rows(list,lim)}</div>`;
'@
$b2 = @'
if(!nwMob())return nwCol(title,cat,list,lim);
'@
# --- anchor 3: pendengar klik v20 mencatat kolom aktif ---
$a3 = @'
window.addEventListener('click',ev=>{const t=ev.target,ce=t&&t.closest?t.closest('.nsc'):null;document.querySelectorAll('.nsc.act').forEach(x=>{if(x!==ce)x.classList.remove('act')});if(ce)ce.classList.add('act');
'@
$b3 = @'
window.addEventListener('click',ev=>{const t=ev.target,ce=t&&t.closest?t.closest('.nsc'):null;document.querySelectorAll('.nsc.act').forEach(x=>{if(x!==ce)x.classList.remove('act')});if(ce)ce.classList.add('act');{const nk=ce?ce.getAttribute('data-k'):null;if(nk!==NV.nsa)NV.nss=ce?ce.scrollTop:0;NV.nsa=nk}
'@
# --- anchor 4: definisi nwCol, pendengar roda dan gulir ---
$a4 = @'
NV.nwf='indonesia';NV.nwm=false;
'@
$b4 = @'
/*v21*/NV.nsa=null;NV.nss=0;
NV.nwf='indonesia';NV.nwm=false;
function nwCol(title,cat,list,lim){const key=(M[cur]?M[cur].pg:'')+'|'+cat+'|'+title,on=NV.nsa===key;if(on)setTimeout(()=>{const c=document.querySelector('.nsc.act');if(c)c.scrollTop=NV.nss||0},0);return `<div class="nsc${on?' act':''}" data-k="${E(key)}" title="${S('Klik di dalam kolom untuk mulai menggulir','Click inside the column to start scrolling')}"><div class="nsxw"><button class="nsx" onclick="v7.nsx()">\u2715 ${S('Tutup','Close')}</button></div>${rows(list,lim)}</div>`}
window.addEventListener('wheel',ev=>{const t=ev.target,c=t&&t.closest?t.closest('.nsc.act'):null;if(!c||ev.ctrlKey||c.scrollHeight<=c.clientHeight)return;ev.preventDefault();const k=ev.deltaMode===1?16:ev.deltaMode===2?c.clientHeight:1;c.scrollTop+=ev.deltaY*k;NV.nss=c.scrollTop},{passive:false,capture:true});
window.addEventListener('scroll',ev=>{const c=ev.target;if(c&&c.classList&&c.classList.contains('nsc')&&c.classList.contains('act'))NV.nss=c.scrollTop},true);
'@
# --- anchor 5: handler v7.nsx (tombol Tutup) ---
$a5 = @'
window.v7={nwm:()=>
'@
$b5 = @'
window.v7={nsx:()=>{NV.nsa=null;NV.nss=0;document.querySelectorAll('.nsc.act').forEach(x=>x.classList.remove('act'))},nwm:()=>
'@
$pairs = @()
foreach ($p in @(@($a1,$b1), @($a2,$b2), @($a3,$b3), @($a4,$b4), @($a5,$b5))) {
  $pairs += ,@($p[0].TrimEnd().Replace("`r`n","`n"), $p[1].TrimEnd().Replace("`r`n","`n"))
}
foreach ($p in $pairs) {
  $n = ([regex]::Matches($js, [regex]::Escape($p[0]))).Count
  if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n : $($p[0].Substring(0,[Math]::Min(60,$p[0].Length)))" }
}
$new = $js
foreach ($p in $pairs) { $new = $new.Replace($p[0], $p[1]) }
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v21.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v21.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v21.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v21.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v21 terpasang. Cadangan di $env:TEMP (v8.js.v21.bak, index.html.v21.bak)"
