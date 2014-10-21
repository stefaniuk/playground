<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>RC4 Encryption</title>
<meta name="description" content="Rivest for RSA Security: generates a pseudorandom stream of 256 bytes." />
<meta name="keywords" content="crypo, free online encryption services, OpenPGP, GnuPG, PGP, RSA, AES, Rijndael, Gilant, gilant, gilant holding, public key encryption, online encryption, data encryption, text encryption, file encryption, encrypt, decrypt, security, privacy, security software, downloads, free, reviews, ArrayAnti Key Logger-Anti Monitoring, Anti Spam, Anti Virus, Backup, Encryption-Cryptography, File Encryption, Email Encryption, Disk Encryption, File Recovery, Firewall, Key Logger-Monitoring, Lockdown, Password Related, Password Generator, Password Manager, Password Recovery, Privacy, Secure Shred, Spyware Removal, Trojan Removal, All In One Security Suites, Steganography">
<meta name="generator" content="Crypo CMS">
<meta name="author" content="GilantHolding">
<meta name="googlebot" content ="index,follow">
<meta name="robots" content="index,follow">
<meta name="revisit-after" content="1 Days">
<meta name="resource-type" content="document">
<meta name="distribution" content="global">
<meta name="classification" content="software">
<meta name="rating" content="General">
<meta name="language" content="en-us">

<link rel="shortcut icon" href="favicon.ico"> 
<link rel="icon" type="image/ico" href="favicon.ico">
<link rel="stylesheet" href="css/main.css" type="text/css">
<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>



</head>
<!-- maincode -->
<body>
<form name="rc4">
<div class="toplog">
<table width="920" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td width="500" height="55" bgcolor="#000000" valign="top"><a href="http://www.crypo.com" title="Crypo.Com | Free Online Encryption Services" target="_parent"><img src="pix/eng_logo.jpg" width="500" height="55" border="0" /></a></td>
<td width="420" bgcolor="#000000" class="menu" align="right"><g:plusone></g:plusone></td>
</tr>
</table>
</div><div class="topmenu">
<table width="920" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td height="40" valign="middle" class="pagetitle">&nbsp;</td>
</tr>
<tr><td valign="top"><table width="920" border="0" cellspacing="0" cellpadding="0">
<tr><td width="920" class="rolbuz"><span class="page1title">RC4 Encryption <br />Rivest for RSA Security: generates a pseudorandom stream of 256 bytes.</span></td></tr>
</table></td></tr></table>
</div><div class="maincode">
		<script language="JavaScript">
var dg=''
function makeArray(n) {
 for (var i=1; i<=n; i++) {
  this[i]=0
 }
 return this
}
function rc4(key, text) {
 var i, x, y, t, x2;
 status("rc4")
 s=makeArray(0);

 for (i=0; i<256; i++) {
  s[i]=i
 }
 y=0
 for (x=0; x<256; x++) {
  y=(key.charCodeAt(x % key.length) + s[x] + y) % 256
  t=s[x]; s[x]=s[y]; s[y]=t
 }
 x=0;  y=0;
 var z=""
 for (x=0; x<text.length; x++) {
  x2=x % 256
  y=( s[x2] + y) % 256
  t=s[x2]; s[x2]=s[y]; s[y]=t
  z+= String.fromCharCode((text.charCodeAt(x) ^ s[(s[x2] + s[y]) % 256]))
 }
 return z
}
function badd(a,b) { // binary add
 var r=''
 var c=0
 while(a || b) {
  c=chop(a)+chop(b)+c
  a=a.slice(0,-1); b=b.slice(0,-1)
  if(c & 1) {
   r="1"+r
  } else {
   r="0"+r
  }
  c>>=1
 }
 if(c) {r="1"+r}
 return r
}
function chop(a) {
 if(a.length) {
  return parseInt(a.charAt(a.length-1))
 } else {
  return 0
 }
}
function bsub(a,b) { // binary subtract
 var r=''
 var c=0
 while(a) {
  c=chop(a)-chop(b)-c
  a=a.slice(0,-1); b=b.slice(0,-1)
  if(c==0) {
   r="0"+r
  }
  if(c == 1) {
   r="1"+r
   c=0
  }
  if(c == -1) {
   r="1"+r
   c=1
  }
  if(c==-2) {
   r="0"+r
   c=1
  }
 }
 if(b || c) {return ''}
 return bnorm(r)
}
function bnorm(r) { // trim off leading 0s
 var i=r.indexOf('1')
 if(i == -1) {
  return '0'
 } else {
  return r.substr(i)
 }
}
function bmul(a,b) { // binary multiply
 var r=''; var p=''
 while(a) {
  if(chop(a) == '1') {
   r=badd(r,b+p)
  }
  a=a.slice(0,-1)
  p+='0'
 }
 return r;
}
function bmod(a,m) { // binary modulo
 return bdiv(a,m).mod
}
function bdiv(a,m) { // binary divide & modulo
 // this.q = quotient this.mod=remainder
 var lm=m.length, al=a.length
 var p='',d
 this.q=''
 for(n=0; n<al; n++) {
  p=p+a.charAt(n);
  if(p.length<lm || (d=bsub(p,m)) == '') {
   this.q+='0'
  } else {
   if(this.q.charAt(0)=='0') {
    this.q='1'
   } else {
    this.q+="1"
   }
   p=d
  }
 }
 this.mod=bnorm(p)
 return this
}
function bmodexp(x,y,m) { // binary modular exponentiation
 var r='1'
 status("bmodexp "+x+" "+y+" "+m)

 while(y) {
  if(chop(y) == 1) {
   r=bmod(bmul(r,x),m)
  }
  y=y.slice(0,y.length-1)
  x=bmod(bmul(x,x),m)
 }
 return bnorm(r)
}
function modexp(x,y,m) { // modular exponentiation
 // convert packed bits (text) into strings of 0s and 1s
 return b2t(bmodexp(t2b(x),t2b(y),t2b(m)))
}
function i2b(i) { // convert integer to binary
 var r=''
 while(i) {
  if(i & 1) { r="1"+r} else {r="0"+r}
  i>>=1;
 }
 return r? r:'0'
}
function t2b(s) {
 var r=''
 if(s=='') {return '0'}
 while(s.length) {
  var i=s.charCodeAt(0)
  s=s.substr(1)
  for(n=0; n<8; n++) {
   r=((i & 1)? '1':'0') + r
   i>>=1;
  }
 }
 return bnorm(r)
}
function b2t(b) {
 var r=''; var v=0; var m=1
 while(b.length) {
  v|=chop(b)*m
  b=b.slice(0,-1)
  m<<=1
  if(m==256 || b=='') {
   r+=String.fromCharCode(v)
   v=0; m=1
  }
 }
 return r
}
b64s='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"'
function textToBase64(t) {
 status("t 2 b64")
 var r=''; var m=0; var a=0; var tl=t.length-1; var c
 for(n=0; n<=tl; n++) {
  c=t.charCodeAt(n)
  r+=b64s.charAt((c << m | a) & 63)
  a = c >> (6-m)
  m+=2
  if(m==6 || n==tl) {
   r+=b64s.charAt(a)
   if((n%45)==44) {r+="\n"}
   m=0
   a=0
  }
 }
 return r
}
function base64ToText(t) {
 status("b64 2 t")
 var r=''; var m=0; var a=0; var c
 for(n=0; n<t.length; n++) {
  c=b64s.indexOf(t.charAt(n))
  if(c >= 0) {
   if(m) {
    r+=String.fromCharCode((c << (8-m))&255 | a)
   }
   a = c >> m
   m+=2
   if(m==8) { m=0 }
  }
 }
 return r
}

function rand(n) {  return Math.floor(Math.random() * n) }
function rstring(s,l) {
 var r=""
 var sl=s.length
 while(l-->0) {
  r+=s.charAt(rand(sl))
 }
 //status("rstring "+r)
 return r
}
function key2(k) {
 var l=k.length
 var kl=l
 var r=''
 while(l--) {
  r+=k.charAt((l*3)%kl)
 }
 return r
}
function rsaEncrypt(keylen,key,mod,text) {
 // I read that rc4 with keys larger than 256 bytes doesn't significantly
 // increase the level of rc4 encryption because it's sbuffer is 256 bytes
 // makes sense to me, but what do i know...

 status("encrypt")
 if(text.length >= keylen) {
  var sessionkey=rc4(rstring(text,keylen),rstring(text,keylen))

  // session key must be less than mod, so mod it
  sessionkey=b2t(bmod(t2b(sessionkey),t2b(mod)))
  alert("sessionkey="+sessionkey)

  // return the rsa encoded key and the encrypted text
  // i'm double encrypting because it would seem to me to
  // lessen known-plaintext attacks, but what do i know
  return modexp(sessionkey,key,mod) +
   rc4(key2(sessionkey),rc4(sessionkey,text))
 } else {

  // don't need a session key
  return modexp(text,key,mod)
 }
}
function rsaDecrypt(keylen,key,mod,text) {
 status("decrypt")
 if(text.length <= keylen) {
  return modexp(text,key,mod)
 } else {

  // sessionkey is first keylen bytes
  var sessionkey=text.substr(0,keylen)
  text=text.substr(keylen)

  // un-rsa the session key
  sessionkey=modexp(sessionkey,key,mod)
  alert("sessionkey="+sessionkey)

  // double decrypt the text
  return rc4(sessionkey,rc4(key2(sessionkey,text),text))
 }
}
function trim2(d) { return d.substr(0,d.lastIndexOf('1')+1) }
function bgcd(u,v) { // return greatest common divisor
 // algorythm from http://algo.inria.fr/banderier/Seminar/Vallee/index.html
 var d, t
 while(1) {
  d=bsub(v,u)
  //alert(v+" - "+u+" = "+d)
  if(d=='0') {return u}
  if(d) {
   if(d.substr(-1)=='0') {
    v=d.substr(0,d.lastIndexOf('1')+1) // v=(v-u)/2^val2(v-u)
   } else v=d
  } else {
   t=v; v=u; u=t // swap u and v
  }
 }
}

function isPrime(p) {
 var n,p1,p12,t
 p1=bsub(p,'1')
 t=p1.length-p1.lastIndexOf('1')
 p12=trim2(p1)
 for(n=0; n<2; n+=mrtest(p,p1,p12,t)) {
  if(n<0) return 0
 }
 return 1
}
function mrtest(p,p1,p12,t) {
 // Miller-Rabin test from forum.swathmore.edu/dr.math/
 var n,a,u
  a='1'+rstring('01',Math.floor(p.length/2)) // random a
  //alert("mrtest "+p+", "+p1+", "+a+"-"+p12)
  u=bmodexp(a,p12,p)
  if(u=='1') {return 1}
  for(n=0;n<t;n++) {
   u=bmod(bmul(u,u),p)
   //dg+=u+" "
   if(u=='1') return -100
   if(u==p1) return 1
  }
  return -100
}
pfactors='11100011001110101111000110001101'
 // this number is 3*5*7*11*13*17*19*23*29*31*37
function prime(bits) {
 // return a prime number of bits length
 var p='1'+rstring('001',bits-2)+'1'
 while( ! isPrime(p)) {
  p=badd(p,'10'); // add 2
 }
 alert("p is "+p)
 return p
}
function genkey(bits) {
 q=prime(bits)
 do {
  p=q
  q=prime(bits)
 } while(bgcd(p,q)!='1')
 p1q1=bmul(bsub(p,'1'),bsub(q,'1'))
 // now we need a d, e,  and an n so that:
 //  p1q1*n-1=de  -> bmod(bsub(bmul(d,e),'1'),p1q1)='0'
 // or more specifically an n so that d & p1q1 are rel prime and factor e
 n='1'+rstring('001',Math.floor(bits/3)+2)
 alert('n is '+n)
 factorMe=badd(bmul(p1q1,n),'1')
 alert('factor is '+factorMe)
 //e=bgcd(factorMe,p1q1)
 //alert('bgcd='+e)
 e='1'
 // is this always 1?
 //r=bdiv(factorMe,e)
 //alert('r='+r.q+" "+r.mod)
 //if(r.mod != '0') {alert('Mod Error!')}
 //factorMe=r.q
 d=bgcd(factorMe,'11100011001110101111000110001101')
 alert('d='+d)
 if(d == '1' && e == '1') {alert('Factoring failed '+factorMe+' p='+p+' q='+q)}
 e=bmul(e,d)
 r=bdiv(factorMe,d)
 d=r.q
 if(r.mod != '0') {alert('Mod Error 2!')}

 this.mod=b2t(bmul(p,q))
 this.pub=b2t(e)
 this.priv=b2t(d)
}
function status(a) { }//alert(a)}
</script>
<script language="JavaScript">
<!--
function rc4encrypt() {
document.rc4.text.value=textToBase64(rc4(document.rc4.key.value,document.rc4.text.value))
}
function rc4decrypt() {
document.rc4.text.value=(rc4(document.rc4.key.value,base64ToText(document.rc4.text.value)))
}
-->
</script>
<table width="920" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td class="mainpage" valign="top" bgcolor="#E4E4E4"><table width="910" border="0" cellspacing="0" cellpadding="0"><tr><td width="533" valign="top"><table width="910" border="0" cellspacing="0" cellpadding="0">
<tr><td class="ctitle" valign="middle">Type or paste in the text you want to encrypt or decrypt</td></tr>
<tr><td valign="top"><textarea class="m1write" name="text"></textarea></td></tr>
<tr><td class="ctitle" valign="middle">Enter KeyPass (1-200) maxlength = 200 symbols</td></tr>
<tr><td><input  class="p1write" type="text" name="key" maxlength="200" value="Enter Your KeyPass"/></td></tr>
</table></td></tr></table></td></tr></tr><tr><td class="infobot"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td width="15%"><input name="B1" type="button" class="button" value="encrypt" onclick="rc4.value=rc4encrypt(text.value,key.value);" name="CaeserEncryptBut" /></td><td width="15%"><input name="B2" type="button" class="button" value="decrypt" onclick="rc4.value=rc4decrypt(text.value,key.value);" name="decode" /></td><td width="15%"><input class="button" type="reset" value="clear" name="clear" /></td><td width="55%">The RSA Data Security works on an array of 256 bytes to generate a pseudo random number sequence which is used as keystream to encrypt data.</td></tr></table></td></tr><tr><td height="40"></td></tr>
</table><table width="920" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td class="pageinformer">
<script type="text/javascript">
google_ad_client = "pub-7396876183362408";
google_ad_slot = "2481527259";
google_ad_width = 728;
google_ad_height = 15;
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"> </script>
</td></tr>
<tr><td class="pageinformer">
<script type="text/javascript">
google_ad_client = "pub-3833782367690428";
google_ad_slot = "5118175201";
google_ad_width = 728;
google_ad_height = 90;
</script>
<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
</td></tr>
<tr><td height="1"></td></tr>
<tr><td valign="top" height="20"></td></tr>
<tr><td class="xtitle" valign="middle">Advertisement</td></tr>
<tr><td><a href="http://www.e3iphone.com" target="_blank" onClick="javascript:pageTracker._trackPageview('/banner/www.e3iphone.com');"><img src="e3iphone.jpg" width="920" height="100" border="0" /></a></td></tr>
<tr><td valign="top" height="20"></td></tr>

<!-- URL Encoder -->
<tr><td class="ztitle" valign="middle">Hide URL Link and email address</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_urle.php' >URL-Encode v1<br />Encode to Unicode String</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_urle2.php' >URL-Encode v2<br />Encode to Unicode String</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_uril.php' >URI-Encode v3<br />Encode to Unicode String</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_urld.php' >URL-Decoder<br />Decode Unicode String</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_eme.php' >Email-ASCII<br />Email Address Encode</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr>
<!-- Hash Generator -->
<tr><td class="xtitle" valign="middle">Hash Generator</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_sha1.php' >SHA1<br />Hash Generator</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_crc32.php' >CRC32<br />Hash Generator</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_md2.php' >MD2<br />Hash Generator</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_md4.php' >MD4<br />Hash Generator</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_md5.php' >MD5<br />Hash Generator</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr>
<!-- Password Generator -->
<tr><td class="ztitle" valign="middle">One'Pass Generator</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_pass1g.php' >Unique-Password<br />Generator v1</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_pass2g.php' >Unique-Password<br />Generator v2</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_pass3g.php' >Unique-Password<br />Generator v3</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_pass4g.php' >Unique-Password<br />Generator v4</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_pass5g.php' >Unique-Password<br />Generator v5</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr>
<!-- PassPhrase Generator -->
<tr><td class="ztitle" valign="middle">PassPhrase Generator</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_ppg1.php' >PassPhrase<br />Generator v1</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_ppg2.php' >PassPhrase<br />Generator v2</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_ppg3.php' >PassPhrase<br />Generator v3</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_ppg4.php' >PassPhrase<br />Generator v4</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_ppg5.php' >PassPhrase<br />Generator v5</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_ppg6.php' >PassPhrase<br />Generator v6</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_ppg7.php' >PassPhrase<br />Generator v7</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_ppg8.php' >PassPhrase<br />Generator v8</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_ppg9.php' >PassPhrase<br />Generator v9</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_ppg10.php' >PassPhrase<br />Generator v10</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr>
<!-- Multi-PassPhrase Generator -->
<tr><td class="ztitle" valign="middle">Mega-PassPhrase Generator</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_mppg1.php' >Mega-PassPhrase<br />Generator v1</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_mppg2.php' >Mega-PassPhrase<br />Generator v2</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_mppg3.php' >Mega-PassPhrase<br />Generator v3</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_mppg4.php' >Mega-PassPhrase<br />Generator v4</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_mppg5.php' >Mega-PassPhrase<br />Generator v5</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_mppg6.php' >Mega-PassPhrase<br />Generator v6</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_mppg7.php' >Mega-PassPhrase<br />Generator v7</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_mppg8.php' >Mega-PassPhrase<br />Generator v8</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_mppg9.php' >Mega-PassPhrase<br />Generator v9</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_mppg10.php' >Mega-PassPhrase<br />Generator v10</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_mppg11.php' >Mega-PassPhrase<br />Generator v11</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_mppg12.php' >Mega-PassPhrase<br />Generator v12</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_mppg13.php' >Mega-PassPhrase<br />Generator v13</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_mppg14.php' >Mega-PassPhrase<br />Generator v14</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_mppg15.php' >Mega-PassPhrase<br />Generator v15</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr>
<!-- ASCII Encoder -->
<tr><td class="ztitle" valign="middle">ASCII Encode/Decode</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_uascii.php' >U-ASCII<br />Encode</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_tasciie.php' >T-ASCII<br />Encode</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_tasciid.php' >T-ASCII<br />Decoder</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_fasciie.php' >F-ASCII<br />Encode</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_fasciid.php' >F-ASCII<br />Decode</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr>
<!-- File Ecrypter -->
<tr><td class="xtitle" valign="middle">Encrypt online message</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_aer256e.php' >AER-256<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_armon64e.php' >ARMON-64<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_atom128e.php' >ATOM-128<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_base64e.php' >BASE-64<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_esab46e.php' >ESAB-46<br />Encrypt message</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_ezip64e.php' >EZIP-64<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_feron74e.php' >FERON-74<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_gila7e.php' >GILA7<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_hazz15e.php' >HAZZ-15<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_megan35e.php' >MEGAN-35<br />Encrypt message</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_okto3e.php' >OKTO3<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_tigo3fxe.php' >TIGO-3FX<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_tripo5e.php' >TRIPO-5<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_zara128e.php' >ZARA-128<br />Encrypt message</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_zong22e.php' >ZONG22<br />Encrypt message</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr>
<!-- File Decrypter -->
<tr><td class="xtitle" valign="middle">Decrypt online message</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_aer256d.php' >AER-256<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_armon64d.php' >ARMON-64<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_atom128d.php' >ATOM-128<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_base64d.php' >BASE-64<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_esab46d.php' >ESAB-46<br />Decrypt message</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_ezip64d.php' >EZIP-46<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_feron74d.php' >FERON-74<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_gila7d.php' >GILA7<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_hazz15d.php' >HAZZ-15<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_megan35d.php' >MEGAN-35<br />Decrypt message</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_okto3d.php' >OKTO3<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_tigo3fxd.php' >TIGO-3FX<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_tripo5d.php' >TRIPO-5<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_zara128d.php' >ZARA-128<br />Decrypt message</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_zong22d.php' >ZONG22<br />Decrypt message</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr>
<!-- Encrypt or Decrypt message -->
<tr><td class="xtitle" valign="middle">Encrypt or Decrypt message</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_aer256p.php' >AER-256 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_armon64p.php' >ARMON-64 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_atom128c.php' >ATOM-128 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_base64c.php' >BASE-64 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_esab46c.php' >ESAB-46 + <br />Encrypt / Decrypt</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_ezip64p.php' >EZIP-64 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_feron74c.php' >FERON-74 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_gila7c.php' >GILA7 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_hazz15c.php' >HAZZ-15 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_megan35c.php' >MEGAN-35 + <br />Encrypt / Decrypt</a></td>
</tr>
<tr>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_okto3p.php' >OKTO3 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_tigo3fxc.php' >TIGO-3FX + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_tripo5c.php' >TRIPO-5 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="moredut"><a href='eng_zara128p.php' >ZARA-128 + <br />Encrypt / Decrypt</a></td>
<td width="184" height="81" valign="middle" class="moreduz"><a href='eng_zong22c.php' >ZONG22 + <br />Encrypt / Decrypt</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="5"></td></tr> 
<!-- Multibit Ecryption -->
<tr><td class="xtitle" valign="middle">Multibit Encryption</td></tr>
<tr>
<td class="moreapp" valign="top"><table width="920"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_des.php' >DES Algorithm<br />Strong Encryption</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_ripemd.php' >RIPEMD-160<br />Hash Generator</a></td>
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_caesar.php' >Caesar Shift Code<br />Encrypt Message</a></td>
<td width="184" height="81" valign="middle" class="morebut2">RC4 Encryption<br />Stream Cipher</td>
<td width="184" height="81" valign="middle" class="morebuz"><a href='eng_reverser.php' >REVERSER<br />Reverse any Text</a></td>
</tr>
</table>
</td>
</tr>
<tr><td height="40"></td></tr>
<tr><td valign="middle" class="partners">advertisement</td></tr>
</table>
</div>
<div class="botpartner">
<table width="920" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
<td><a href="http://www.crypo.info" target="_blank" onClick="javascript:pageTracker._trackPageview('/banner/www.crypo.info');"><img src="img/crypo-920x100-info.jpg" width="920" height="100" border="0" /></a></td>
</tr>

<!-- begin:copyra -->
<tr><td valign="middle" bgcolor="#000000" class="menu" height="55">
<div style="float:left;">[ ONLINE: 47 USERS ]<br>Copyright &copy; 2007-2011 Crypo<br>All rights reserved</div>
<div style="float:right;margin-right:-11px;margin-top:-4px; height:44px; position:relative; outline:hidden; overflow:hidden; border:none;">
<div style="float:right;margin-right:-1px;margin-top:-1px;"><img src="http://s09.flagcounter.com/count/26B/bg=000000/txt=FFFFFF/border=000000/columns=8/maxflags=24/viewers=3/labels=1/" alt="visitors" border="0"></div>
</div>
</td></tr>
<!-- end:copyra -->

</table>
</div>
</form>

<!-- begin:informer -->
<script type="text/javascript" src="http://www.jsi.eusn.net/js/3399721951/informer.js" ></script>
<!-- end:informer -->

<!-- begin:analytics -->
<script type="text/javascript"> var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www."); document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E")); </script><script type="text/javascript"> try { var pageTracker = _gat._getTracker("UA-5637761-2"); pageTracker._trackPageview(); } catch(err) {} </script> 
<!-- end:analytics -->

</body>
</html>