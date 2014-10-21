<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>MD4 Hash Generator </title>
<meta name="description" content="Message-Digest 4 is a widely-used cryptographic hash function with a 128-bit hash value." />
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
<body onLoad="show5()">
<form name="codForm">
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
<tr><td width="920" class="rolbuz"><span class="page1title">MD4 Hash Generator  <br />Message-Digest 4 is a widely-used cryptographic hash function with a 128-bit hash value.</span></td></tr>
</table></td></tr></table>
</div><div class="maincode">
<script language=JavaScript>
var hexcase = 0   /* hex output format. 0 - lowercase; 1 - uppercase        */
var b64pad  = ""  /* base-64 pad character. "=" for strict RFC compliance   */
var chrsz   = 8   /* bits per input character. 8 - ASCII; 16 - Unicode      */

function hex_md4(s){ return binl2hex(core_md4(str2binl(s), s.length * chrsz)) }
function b64_md4(s){ return binl2b64(core_md4(str2binl(s), s.length * chrsz)) }
function hex_hmac_md4(key, data) { return binl2hex(core_hmac_md4(key, data)) }
function b64_hmac_md4(key, data) { return binl2b64(core_hmac_md4(key, data)) }

function calcMD4(s){ return binl2hex(core_md4(str2binl(s), s.length * chrsz)) }

function md4_vm_test()
{
  return hex_md4("abc") == "a448017aaf21d8525fc10ae87aa6729d"
}

function core_md4(x, len)
{
  /* append padding */
  x[len >> 5] |= 0x80 << (len % 32)
  x[(((len + 64) >>> 9) << 4) + 14] = len
  
  var a =  1732584193
  var b = -271733879
  var c = -1732584194
  var d =  271733878

  for(var i = 0; i < x.length; i += 16)
  {
    var olda = a
    var oldb = b
    var oldc = c
    var oldd = d

    a = ff(a, b, c, d, x[i+ 0], 3 )
    d = ff(d, a, b, c, x[i+ 1], 7 )
    c = ff(c, d, a, b, x[i+ 2], 11)
    b = ff(b, c, d, a, x[i+ 3], 19)
    a = ff(a, b, c, d, x[i+ 4], 3 )
    d = ff(d, a, b, c, x[i+ 5], 7 )
    c = ff(c, d, a, b, x[i+ 6], 11)
    b = ff(b, c, d, a, x[i+ 7], 19)
    a = ff(a, b, c, d, x[i+ 8], 3 )
    d = ff(d, a, b, c, x[i+ 9], 7 )
    c = ff(c, d, a, b, x[i+10], 11)
    b = ff(b, c, d, a, x[i+11], 19)
    a = ff(a, b, c, d, x[i+12], 3 )
    d = ff(d, a, b, c, x[i+13], 7 )
    c = ff(c, d, a, b, x[i+14], 11)
    b = ff(b, c, d, a, x[i+15], 19)

    a = gg(a, b, c, d, x[i+ 0], 3 )
    d = gg(d, a, b, c, x[i+ 4], 5 )
    c = gg(c, d, a, b, x[i+ 8], 9 )
    b = gg(b, c, d, a, x[i+12], 13)
    a = gg(a, b, c, d, x[i+ 1], 3 )
    d = gg(d, a, b, c, x[i+ 5], 5 )
    c = gg(c, d, a, b, x[i+ 9], 9 )
    b = gg(b, c, d, a, x[i+13], 13)
    a = gg(a, b, c, d, x[i+ 2], 3 )
    d = gg(d, a, b, c, x[i+ 6], 5 )
    c = gg(c, d, a, b, x[i+10], 9 )
    b = gg(b, c, d, a, x[i+14], 13)
    a = gg(a, b, c, d, x[i+ 3], 3 )
    d = gg(d, a, b, c, x[i+ 7], 5 )
    c = gg(c, d, a, b, x[i+11], 9 )
    b = gg(b, c, d, a, x[i+15], 13)

    a = hh(a, b, c, d, x[i+ 0], 3 )
    d = hh(d, a, b, c, x[i+ 8], 9 )
    c = hh(c, d, a, b, x[i+ 4], 11)
    b = hh(b, c, d, a, x[i+12], 15)
    a = hh(a, b, c, d, x[i+ 2], 3 )
    d = hh(d, a, b, c, x[i+10], 9 )
    c = hh(c, d, a, b, x[i+ 6], 11)
    b = hh(b, c, d, a, x[i+14], 15)
    a = hh(a, b, c, d, x[i+ 1], 3 )
    d = hh(d, a, b, c, x[i+ 9], 9 )
    c = hh(c, d, a, b, x[i+ 5], 11)
    b = hh(b, c, d, a, x[i+13], 15)
    a = hh(a, b, c, d, x[i+ 3], 3 )
    d = hh(d, a, b, c, x[i+11], 9 )
    c = hh(c, d, a, b, x[i+ 7], 11)
    b = hh(b, c, d, a, x[i+15], 15)

    a = safe_add(a, olda)
    b = safe_add(b, oldb)
    c = safe_add(c, oldc)
    d = safe_add(d, oldd)

  }
  return Array(a, b, c, d)

  /*
   * These functions implement the basic operation for each round of the
   * algorithm.
   */
  function cmn(q, a, b, x, s, t)
  {
    return safe_add(rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b);
  }
  function ff(a, b, c, d, x, s)
  {
    return cmn((b & c) | ((~b) & d), a, 0, x, s, 0);
  }
  function gg(a, b, c, d, x, s)
  {
    return cmn((b & c) | (b & d) | (c & d), a, 0, x, s, 1518500249);
  }
  function hh(a, b, c, d, x, s)
  {
    return cmn(b ^ c ^ d, a, 0, x, s, 1859775393);
  }
}

/*
 * Calculate the HMAC-MD4, of a key and some data
 */
function core_hmac_md4(key, data)
{
  var bkey = str2binl(key) 
  if(bkey.length > 16) bkey = core_md4(bkey, key.length * chrsz)

  var ipad = Array(16), opad = Array(16)
  for(var i = 0; i < 16; i++) 
  {
    ipad[i] = bkey[i] ^ 0x36363636
    opad[i] = bkey[i] ^ 0x5C5C5C5C
  }

  var hash = core_md4(ipad.concat(str2binl(data)), 512 + data.length * chrsz)
  return core_md4(opad.concat(hash), 512 + 128)
}

/*
 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
 * to work around bugs in some JS interpreters.
 */
function safe_add(x, y)
{
  var lsw = (x & 0xFFFF) + (y & 0xFFFF)
  var msw = (x >> 16) + (y >> 16) + (lsw >> 16)
  return (msw << 16) | (lsw & 0xFFFF)
}

/*
 * Bitwise rotate a 32-bit number to the left.
 */
function rol(num, cnt)
{
  return (num << cnt) | (num >>> (32 - cnt))
}

/*
 * Convert a string to an array of little-endian words
 * If chrsz is ASCII, characters >255 have their hi-byte silently ignored.
 */
function str2binl(str)
{
  var bin = Array()
  var mask = (1 << chrsz) - 1
  for(var i = 0; i < str.length * chrsz; i += chrsz)
    bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (i%32)
  return bin
}

/*
 * Convert an array of little-endian words to a hex string.
 */
function binl2hex(binarray)
{
  var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef"
  var str = ""
  for(var i = 0; i < binarray.length * 4; i++)
  {
    str += hex_tab.charAt((binarray[i>>2] >> ((i%4)*8+4)) & 0xF) +
           hex_tab.charAt((binarray[i>>2] >> ((i%4)*8  )) & 0xF)
  }
  return str
}

/*
 * Convert an array of little-endian words to a base-64 string
 */
function binl2b64(binarray)
{
  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  var str = ""
  for(var i = 0; i < binarray.length * 4; i += 3)
  {
    var triplet = (((binarray[i   >> 2] >> 8 * ( i   %4)) & 0xFF) << 16)
                | (((binarray[i+1 >> 2] >> 8 * ((i+1)%4)) & 0xFF) << 8 )
                |  ((binarray[i+2 >> 2] >> 8 * ((i+2)%4)) & 0xFF)
    for(var j = 0; j < 4; j++)
    {
      if(i * 8 + j * 6 > binarray.length * 32) str += b64pad
      else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F)
    }
  }
  return str;
}
gAddPrefix = false;


function hashcalcMD4(strHash) {
	return(calcMD4(strHash));
}

</script>
<table width="920" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td class="mainpage" valign="top" bgcolor="#E4E4E4">
<table width="910" border="0" cellspacing="0" cellpadding="0">
<tr><td width="533" valign="top"><table width="910" border="0" cellspacing="0" cellpadding="0">
<tr><td class="ctitle" valign="middle">Enter a String to be Converted into a MD4 (checksum)</td></tr>
<tr><td valign="top"><textarea class="m3write" onKeyUp="this.form.md4hash.value = hashcalcMD4(this.form.input.value)" name="input" id="input"></textarea></td></tr>
</table></td></tr></table></td></tr></tr>
<tr><td class="infobox"><input type=text class="b3text" value="MD4:" maxlength="8" readonly="readonly"><input type=text class="pass2dm" name="md4hash" readonly="readonly"></td></tr>
<tr><td height="40"></td></tr>
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
<td width="184" height="81" valign="middle" class="moredut2">MD4<br />Hash Generator</td>
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
<td width="184" height="81" valign="middle" class="morebut"><a href='eng_rc4.php' >RC4 Encryption<br />Stream Cipher</a></td>
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
<div style="float:left;">[ ONLINE: 26 USERS ]<br>Copyright &copy; 2007-2011 Crypo<br>All rights reserved</div>
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