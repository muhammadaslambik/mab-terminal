# v25 (semua khusus mobile <=720px, desktop tidak berubah):
#  1) Beranda: kartu Indonesia/Amerika/Dunia/Crypto/XAUUSD jadi accordion (tertutup bawaan), tombol Buka/Tutup di sampingnya + "Buka semua".
#  2) Diagram alir (Berita: sentimen; Performa antar kelas aset; halaman aset): digambar ulang agar muat selebar layar, tanpa geser horizontal.
#  3) Tombol "Analisa Pakar" di pojok kanan-bawah semua halaman; menu berisi semua pakar, fokus pada halaman yang dibuka; klik di luar menutupnya.
# powershell -ExecutionPolicy Bypass -File tools\v25-patch.ps1
$ErrorActionPreference = "Stop"
$root = "E:\0\MAB Project\MAB-Terminal\mab-terminal"
$jsP = Join-Path $root "tools\v8.js"
$htP = Join-Path $root "public\index.html"
$enc = New-Object System.Text.UTF8Encoding($false)
$js = [IO.File]::ReadAllText($jsP, $enc).Replace("`r`n", "`n")
$ht = [IO.File]::ReadAllText($htP, $enc)
if ($js.Contains("/*v25*/")) { Write-Host "SKIP: v25 sudah terpasang"; exit 0 }
if (-not $js.Contains("/*v24*/")) { throw "v24 belum terpasang" }
$open = '<script id="v8-js">'
$i = $ht.IndexOf($open)
if ($i -lt 0) { throw "Blok v8-js tidak ditemukan di index.html" }
$s = $i + $open.Length
$e = $ht.IndexOf('</script>', $s)
if ($e -lt 0) { throw "Penutup blok v8-js tidak ditemukan" }
$blk = $ht.Substring($s, $e - $s).Replace("`r`n", "`n")
if ($blk.Trim() -ne $js.Trim()) { throw "Blok v8-js di index.html BEDA dengan tools\v8.js. Berhenti, tidak ada yang diubah." }

# --- anchor 0: blok baru disisipkan sebelum gaya v22 ---
$a0 = @'
/*v22*/{const s=document.createElement('style');s.id='v22-css';
'@
$b0 = @'
/*v25*/{const s=document.createElement('style');s.id='v25-css';s.textContent='#exfab{display:none}@media(max-width:720px){#exfab{position:fixed;right:14px;bottom:16px;z-index:16;display:flex;flex-direction:column;align-items:flex-end;gap:8px}#exm{display:none;width:min(360px,calc(100vw - 28px));max-height:62vh;overflow:auto;background:var(--p);border:1px solid var(--a);border-radius:12px;padding:10px;box-shadow:0 6px 20px rgba(0,0,0,.6);font-size:13px;line-height:1.45}#exb{background:var(--a);color:#120d07;border:0;border-radius:24px;padding:12px 16px;font:700 14px system-ui;box-shadow:0 4px 14px rgba(0,0,0,.6);cursor:pointer}.exd{border-top:1px solid var(--b);padding:6px 0}.exd>summary{cursor:pointer;color:var(--w);font-size:13px}.exd .m{font-size:12px}#nwfab{bottom:70px!important}}';document.head.appendChild(s)}
NV.hac={};NV.exo=false;NV.exk='';
function homeAcc(){const all=CATS.every(c=>NV.hac[c]);return `<div style="grid-column:1/-1;display:flex;justify-content:flex-end"><button class="vb" onclick="v7.hall()">${all?S('Tutup semua \u25B4','Close all \u25B4'):S('Buka semua \u25BE','Open all \u25BE')}</button></div>`+CATS.map(c=>{const o=!!NV.hac[c],l=NEWS[c](),k=cnt(l),t=l.length||1,net=Math.round((k.positif-k.negatif)/t*100),hd=`<div style="display:flex;align-items:center;justify-content:space-between;gap:8px"><div><span class="ph" style="margin:0">${CATL[c]}</span> <span class="m" style="font-size:12px">${l.length} ${S('berita','items')} \u00B7 ${S('skor','score')} <b class="${cl(net)}">${net>0?'+':''}${net}</b></span></div><button class="vb" onclick="v7.hac('${c}')">${o?S('Tutup \u25B4','Close \u25B4'):S('Buka \u25BE','Open \u25BE')}</button></div>`;if(!o)return `<div class="card">${hd}</div>`;const fg=c!=='indonesia';return `<div class="card">${hd}<div style="margin-top:6px">${sentSum(l)}</div>${fg?`<div class="v8t" style="position:static;margin:8px 0 6px;padding:0;background:none"><div class="tfs">${trTog()}</div></div>`:''}${fg&&NV.tr?`<div class="m" style="color:var(--a);margin-bottom:6px">${S('Terjemahan mesin, bisa keliru. Cek judul asli.','Machine translation, may be wrong. Check the original title.')}</div>`:''}${rows(l.slice(0,30),30)}${NV.mode==='swing'?srcWarn(c):''}</div>`}).join('')}
function sankeyM(cols,links){const W=360,FS=10,CW=5.6,P=4,NW=8,MH=12,n=cols.length,lab=x=>String(x.n)+(x.t?' '+x.t:''),fit=(x,mw)=>{const full=lab(x);if(full.length*CW<=mw)return full;const tail=x.t?' '+x.t:'',keep=Math.max(3,Math.floor(mw/CW)-tail.length-1);return String(x.n).slice(0,keep)+'\u2026'+tail},side=c=>Math.min(128,Math.max(56,Math.max(...c.map(x=>lab(x).length))*CW+10)),LM=side(cols[0]),RM=side(cols[n-1]),tot=Math.max(...cols.map(c=>c.reduce((s,x)=>s+x.v,0)))||1,K=220/tot,xs=cols.map((_,i)=>LM+(W-LM-RM-NW)*i/(n-1));
 cols.forEach(c=>c.forEach(x=>{x.h=Math.max(x.v*K,MH)}));const hs=cols.map(c=>c.reduce((s,x)=>s+x.h,0)+P*(c.length-1)),H=Math.max(...hs)+20;cols.forEach((c,ci)=>{let y=(H-hs[ci])/2;c.forEach(x=>{x.y=y;x.x=xs[ci];x.oo=0;x.io=0;y+=x.h+P})});
 let s='';links.slice().sort((p,r)=>p.a[0]-r.a[0]||p.a[1]-r.a[1]||p.b[1]-r.b[1]).forEach(l=>{const A=cols[l.a[0]][l.a[1]],B=cols[l.b[0]][l.b[1]],h=l.v*K;if(!(h>0))return;const x0=A.x+NW,x1=B.x,m=(x0+x1)/2,y0=A.y+A.oo,y1=B.y+B.io;A.oo+=h;B.io+=h;s+=`<path d="M${x0},${y0}C${m},${y0} ${m},${y1} ${x1},${y1}L${x1},${y1+h}C${m},${y1+h} ${m},${y0+h} ${x0},${y0+h}Z" fill="${l.c}" fill-opacity=".38"><title>${E(A.n)} \u2192 ${E(B.n)}: ${E(l.t||String(+l.v.toFixed(1)))}</title></path>`});
 let nd='';cols.forEach((c,ci)=>c.forEach(x=>{const f=ci===0,mid=!f&&ci<n-1,room=f?LM-10:mid?(xs[ci+1]-xs[ci])-NW-12:RM-10;nd+=`<rect x="${x.x}" y="${x.y}" width="${NW}" height="${x.h}" rx="3" fill="${x.c}"/><text x="${f?x.x-5:x.x+NW+5}" y="${x.y+x.h/2+3.5}" text-anchor="${f?'end':'start'}" font-size="${FS}" fill="#e9dfcf" style="paint-order:stroke;stroke:#241810;stroke-width:3px">${E(fit(x,room))}</text>`}));return `<svg viewBox="0 0 ${W} ${H}" style="display:block;width:100%;height:auto">${s}${nd}</svg>`}
function exFocus(){const pg=M[cur]?M[cur].pg:'',cf={id:[IDX,'id'],us:[USS,'us'],xau:[XAU,'xau'],cry:[CRY,'cry']}[pg];if(!cf)return {pg:pg,label:'',x:null};const it=cf[0].find(z=>z[0]===NV.sel[cf[1]])||cf[0][0];return {pg:pg,label:it[0],x:q(it[0])}}
function exBody(a,f){const k=a[0],idx=f.pg==='id';let st,body='';if(k==='baseline'){st=[S('Data nyata','Real data'),'var(--g)'];body=f.x?anHtml(f.x):`<div class="m">${f.label?S('Data harga aset ini tidak tersedia dari sumber.','Price data for this asset is not available from the source.'):S('Buka halaman aset (Saham Indonesia, Amerika, XAUUSD, Crypto) untuk analisa ini.','Open an asset page (Indonesian Stocks, US Stocks, XAUUSD, Crypto) for this analysis.')}</div>`}else if(k==='andry-hakim/multibagger'){st=idx?[S('Data nyata','Real data'),'var(--g)']:[S('Khusus saham Indonesia','Indonesian stocks only'),'var(--m)'];body=idx?`<a class="chip" style="text-decoration:none" href="/indonesia/analyzer?${k}" onclick="return v7.rt(event,this.getAttribute('href'))">${S('Buka daftar pantauan','Open watchlist')}</a>`:''}else{st=[S('Belum tersedia','Not available yet'),'var(--a)'];body=`<div style="color:var(--a)">${S('Belum diimplementasikan dengan data nyata, jadi belum ada sinyal dari pakar ini.','Not yet implemented with real data, so there is no signal from this expert yet.')}</div>`}return `<details class="exd"><summary>${E(S(a[1],a[2]))} <span style="font-size:11px;color:${st[1]}">${E(st[0])}</span></summary><div class="m" style="margin:4px 0">${E(S(a[3],a[4]))}</div>${body}</details>`}
function exBuild(){const m=document.getElementById('exm');if(!m)return;const f=exFocus();m.innerHTML=`<div class="ph" style="margin:0 0 6px">${S('ANALISA PAKAR','EXPERT ANALYSIS')}${f.label?' \u00B7 '+E(f.label):''}</div>`+(f.label?'':`<div class="m" style="margin-bottom:6px">${S('Halaman ini tidak punya satu aset tertentu. Buka Saham Indonesia, Saham Amerika, XAUUSD, atau Crypto untuk analisa per aset.','This page has no single asset. Open Indonesian Stocks, US Stocks, XAUUSD or Crypto for per-asset analysis.')}</div>`)+AN.map(a=>exBody(a,f)).join('')}
function exPaint(){const m=document.getElementById('exm'),b=document.getElementById('exb');if(!m||!b)return;b.textContent=S('Analisa Pakar','Expert Analysis');m.style.display=NV.exo?'block':'none'}
function exSync(){if(!document.body)return;if(!document.getElementById('exfab')){const d=document.createElement('div');d.id='exfab';d.innerHTML='<div id="exm"></div><button id="exb" onclick="v7.exm()"></button>';document.body.appendChild(d)}const f=exFocus(),k=f.pg+'|'+f.label+'|'+(NV.an||'');if(k!==NV.exk){NV.exk=k;NV.exo=false}exPaint()}
window.addEventListener('click',ev=>{const t=ev.target;if(NV.exo&&!(t&&t.closest&&t.closest('#exfab'))){NV.exo=false;exPaint()}},true);
/*v22*/{const s=document.createElement('style');s.id='v22-css';
'@
# --- anchor 1: sankey generik memakai versi mobile di layar kecil ---
$a1 = @'
function sankey(cols,links){const W=760,
'@
$b1 = @'
function sankey(cols,links){if(nwMob())return sankeyM(cols,links);const W=760,
'@
# --- anchor 2: Beranda mobile = accordion ---
$a2 = @'
nw=CATS.map(c=>newsCard(CATL[c],c,NEWS[c](),c==='indonesia'?6:4)).join('');
'@
$b2 = @'
nw=nwMob()?homeAcc():CATS.map(c=>newsCard(CATL[c],c,NEWS[c](),c==='indonesia'?6:4)).join('');
'@
# --- anchor 3: handler v7 ---
$a3 = @'
window.v7={nsx:()=>
'@
$b3 = @'
window.v7={hac:k=>{NV.hac[k]=!NV.hac[k];rd()},hall:()=>{const all=CATS.every(c=>NV.hac[c]);CATS.forEach(c=>{NV.hac[c]=!all});rd()},exm:()=>{NV.exo=!NV.exo;if(NV.exo)exBuild();exPaint()},nsx:()=>
'@
# --- anchor 4: tombol Analisa Pakar dipasang/diperbarui setiap menggambar ---
$a4 = @'
function navFoot(){const n=document.getElementById('nav');navPad();if(!n||n.querySelector('.nvf'))return;
'@
$b4 = @'
function navFoot(){const n=document.getElementById('nav');navPad();exSync();if(!n||n.querySelector('.nvf'))return;
'@
$pairs = @()
foreach ($p in @(@($a0,$b0), @($a1,$b1), @($a2,$b2), @($a3,$b3), @($a4,$b4))) {
  $pairs += ,@($p[0].TrimEnd().Replace("`r`n","`n"), $p[1].TrimEnd().Replace("`r`n","`n"))
}
foreach ($p in $pairs) {
  $n = ([regex]::Matches($js, [regex]::Escape($p[0]))).Count
  if ($n -ne 1) { throw "Anchor harus cocok 1 kali, ditemukan $n : $($p[0].Substring(0,[Math]::Min(60,$p[0].Length)))" }
}
$new = $js
foreach ($p in $pairs) { $new = $new.Replace($p[0], $p[1]) }
Copy-Item -LiteralPath $jsP -Destination (Join-Path $env:TEMP "v8.js.v25.bak") -Force
Copy-Item -LiteralPath $htP -Destination (Join-Path $env:TEMP "index.html.v25.bak") -Force
$newBlk = $blk.Replace($js.Trim(), $new.Trim())
$newHt = $ht.Substring(0, $s) + $newBlk + $ht.Substring($e)
[IO.File]::WriteAllText($jsP, $new, $enc)
[IO.File]::WriteAllText($htP, $newHt, $enc)
& node --check $jsP
if ($LASTEXITCODE -ne 0) {
  Copy-Item -LiteralPath (Join-Path $env:TEMP "v8.js.v25.bak") -Destination $jsP -Force
  Copy-Item -LiteralPath (Join-Path $env:TEMP "index.html.v25.bak") -Destination $htP -Force
  throw "node --check gagal; berkas dikembalikan dari cadangan"
}
Write-Host "OK: v25 terpasang. Cadangan di $env:TEMP (v8.js.v25.bak, index.html.v25.bak)"
