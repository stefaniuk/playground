<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>URI-Encode v3 (Encode URI to Unicode String)</title>
<meta name="description" content="Universal tool that converts URL into a Unicode string" />
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
<tr><td width="920" class="rolbuz"><span class="page1title">URI-Encode v3 (Encode URI to Unicode String) <br />Universal tool that converts URL into a Unicode string</span></td></tr>
</table></td></tr></table>
</div><div class="maincode">
<script language=JavaScript>
var encodeUascii = function (string) {

	function rotate_left(n,s) {
		var t4 = ( n<<s ) | (n>>>(32-s));
		return t4;
	};


var regUascii = document.codForm.regUascii.value.toLowerCase()
var codeUascii = ""

if (regUascii == "") {
        alert("UASCII_BOX1")
}
else {
        var regLength = regUascii.length
        for (i = 0; i < regLength; i++) {
                var charNum = "000"
                var curChar = regUascii.charAt(i)
                if (curChar == "A") {
                        charNum = "065"
                }
                if (curChar == "a") {
                        charNum = "097"
                }
                if (curChar == "B") {
                        charNum = "066"
                }
                if (curChar == "b") {
                        charNum = "098"
                }
                if (curChar == "C") {
                        charNum = "067"
                }
                if (curChar == "c") {
                        charNum = "099"
                }
                if (curChar == "D") {
                        charNum = "068"
                }
                if (curChar == "d") {
                        charNum = "100"
                }
                if (curChar == "E") {
                        charNum = "069"
                }
                if (curChar == "e") {
                        charNum = "101"
                }
                if (curChar == "F") {
                        charNum = "070"
                }
                if (curChar == "f") {
                        charNum = "102"
                }
                if (curChar == "G") {
                        charNum = "071"
                }
                if (curChar == "g") {
                        charNum = "103"
                }
                if (curChar == "H") {
                        charNum = "072"
                }
                if (curChar == "h") {
                        charNum = "104"
                }
                if (curChar == "I") {
                        charNum = "073"
                }
                if (curChar == "i") {
                        charNum = "105"
                }
                if (curChar == "J") {
                        charNum = "074"
                }
                if (curChar == "j") {
                        charNum = "106"
                }
                if (curChar == "K") {
                        charNum = "075"
                }
                if (curChar == "k") {
                        charNum = "107"
                }
                if (curChar == "L") {
                        charNum = "076"
                }
                if (curChar == "l") {
                        charNum = "108"
                }
                if (curChar == "M") {
                        charNum = "077"
                }
                if (curChar == "m") {
                        charNum = "109"
                }
                if (curChar == "N") {
                        charNum = "078"
                }
                if (curChar == "n") {
                        charNum = "110"
                }
                if (curChar == "O") {
                        charNum = "079"
                }
                if (curChar == "o") {
                        charNum = "111"
                }
                if (curChar == "P") {
                        charNum = "080"
                }
                if (curChar == "p") {
                        charNum = "112"
                }
                if (curChar == "Q") {
                        charNum = "081"
                }
                if (curChar == "q") {
                        charNum = "113"
                }
                if (curChar == "R") {
                        charNum = "082"
                }
                if (curChar == "r") {
                        charNum = "114"
                }
                if (curChar == "S") {
                        charNum = "083"
                }
                if (curChar == "s") {
                        charNum = "115"
                }
                if (curChar == "T") {
                        charNum = "084"
                }
                if (curChar == "t") {
                        charNum = "116"
                }
                if (curChar == "U") {
                        charNum = "085"
                }
                if (curChar == "u") {
                        charNum = "117"
                }
                if (curChar == "V") {
                        charNum = "086"
                }
                if (curChar == "v") {
                        charNum = "118"
                }
                if (curChar == "W") {
                        charNum = "087"
                }
                if (curChar == "w") {
                        charNum = "119"
                }
                if (curChar == "X") {
                        charNum = "088"
                }
                if (curChar == "x") {
                        charNum = "120"
                }
                if (curChar == "Y") {
                        charNum = "089"
                }
                if (curChar == "y") {
                        charNum = "121"
                }
                if (curChar == "Z") {
                        charNum = "090"
                }
                if (curChar == "z") {
                        charNum = "122"
                }
                if (curChar == "0") {
                        charNum = "048"
                }
                if (curChar == "1") {
                        charNum = "049"
                }
                if (curChar == "2") {
                        charNum = "050"
                }
                if (curChar == "3") {
                        charNum = "051"
                }
                if (curChar == "4") {
                        charNum = "052"
                }
                if (curChar == "5") {
                        charNum = "053"
                }
                if (curChar == "6") {
                        charNum = "054"
                }
                if (curChar == "7") {
                        charNum = "055"
                }
                if (curChar == "8") {
                        charNum = "056"
                }
                if (curChar == "9") {
                        charNum = "057"
                }
                if (curChar == "&") {
                        charNum = "038"
                }
                if (curChar == " ") {
                        charNum = "032"
                }
                if (curChar == "_") {
                        charNum = "095"
                }
                if (curChar == "-") {
                        charNum = "045"
                }
                if (curChar == "@") {
                        charNum = "064"
                }
                if (curChar == ".") {
                        charNum = "046"
                }
                if (charNum == "000") {
                        codeUascii += curChar
                }
                else {
                        codeUascii += "&#" + charNum + ";"               
                }
        }
        document.codForm.codeUascii.value = codeUascii
}

}
</script>
<table width="920" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td class="mainpage" valign="top" bgcolor="#E4E4E4">
<table width="910" border="0" cellspacing="0" cellpadding="0">
<tr><td width="533" valign="top"><table width="910" border="0" cellspacing="0" cellpadding="0">
<tr><td class="ctitle" valign="middle">Type or paste in the text you want to URL encode</td></tr>
<tr><td valign="top"><textarea class="m2write" name="regUascii"></textarea></td></tr>
<tr><td class="ctitle" valign="middle">Select all the text that appears in the box below and paste it into your HTML page where you would want the script to be.</td></tr>
<tr><td valign="top"><textarea class="m4write"  name="codeUascii" readonly="readonly"></textarea></td></tr> 
</table></td></tr></table></td></tr></tr>
<tr><td class="infobot"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="15%"><input type="button" class="button" value="encode" onclick="encodeUascii()" /></td>
<td width="15%"><INPUT class="button" type=reset value="clear" name="clear"></td>
<td width="70%">URI-Encode is a tool that converts URL into a Unicode string which means the text looks scrambled when your source code is viewed, but when executed as a web page, appears to be normal.</td>
</tr>
</table></td>
</tr>
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
<td width="184" height="81" valign="middle" class="moredut2">URI-Encode v3<br />Encode to Unicode String</td>
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
<div style="float:left;">[ ONLINE: 19 USERS ]<br>Copyright &copy; 2007-2011 Crypo<br>All rights reserved</div>
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