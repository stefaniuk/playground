<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CAESAR Shift Code</title>
<meta name="description" content="The Caesar Shift can be made more complicated by having a different shift for different letters" />
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
<form name="CaeserForm">
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
<tr><td width="920" class="rolbuz"><span class="page1title">CAESAR Shift Code <br />The Caesar Shift can be made more complicated by having a different shift for different letters</span></td></tr>
</table></td></tr></table>
</div><div class="maincode">
		<script>
var MCarr=new Array(
"*","|",".-","-...","-.-.","-..",".","..-.","--.","....","..",".---","-.-",".-..","--","-.","---",
".--.","--.-",".-.","...","-","..-","...-",".--","-..-","-.--","--..","-----",".----","..---","...--","....-",
".....","-....","--...","---..","----."
);
var ABC012arr="*|ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

function DoMorseDecrypt(x)
{mess="";apos=0;bpos=0;
while(bpos<x.length)
{
 bpos=x.indexOf(" ",apos);if(bpos<0){bpos=x.length};
 dits=x.substring(apos,bpos);apos=bpos+1;let="";
 for(j=0;j<MCarr.length;j++){  if(dits==MCarr[j]){let=ABC012arr.charAt(j)}  };
 if(let==""){let="*"};
 mess+=let;
};
return mess;
};

function DoMorseEncrypt(x)
{mess="";
for(i=0;i<x.length;i++)
{
let=x.charAt(i).toUpperCase();
for(j=0;j<MCarr.length;j++){  if(let==ABC012arr.charAt(j)){mess+=MCarr[j]}  };
mess+=" ";
};
mess=mess.substring(0,mess.length-1);
return mess;
};


function DoReverse(x){y="";for(i=0;i<x.length;i++){y+=x.charAt(x.length-1-i);};return y};


function DoCaeserEncrypt(x,shf)
{
abc="abcdefghijklmnopqrstuvwxyz";
ABC="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
r1="";r2="";shf=eval(shf);
for(i=0;i<x.length;i++){let=x.charAt(i);pos=ABC.indexOf(let);if(pos>=0){r1+=ABC.charAt(  (pos+shf)%26  )}else{r1+=let};};
for(i=0;i<r1.length;i++){let=r1.charAt(i);pos=abc.indexOf(let);if(pos>=0){r2+=abc.charAt(  (pos+shf)%26  )}else{r2+=let};};
return r2;
};

function DoCaeserDecrypt(x,shf)
{return DoCaeserEncrypt(x,26-shf);};


function MakeCipherABC(abc,key1)
{
abc=abc.toUpperCase();key1=key1.toUpperCase();
cyabc=key1+abc;
for(i=0;i<abc.length;i++){let=cyabc.charAt(i);pos=cyabc.indexOf(let,i+1);
while(pos>-1){cyabc=cyabc.substring(0,pos)+cyabc.substring(pos+1,cyabc.length);pos=cyabc.indexOf(let,i+1);};};
return cyabc;
}


function DoVigenere(et,key1,key2,abc,dir,vigtype,altluabc)
{dt="";et=et.toUpperCase();key1=key1.toUpperCase();key2=key2.toUpperCase();abc=abc.toUpperCase();dir=dir.toUpperCase();
pos=et.indexOf(" ");
while(pos>-1){et=et.substring(0,pos)+et.substring(pos+1,et.length);pos=et.indexOf(" ");};
cyabc=MakeCipherABC(abc,key1);
key1=cyabc;
lu=cyabc;
if(vigtype=="N"){lu=abc};
if(vigtype=="K"){lu=cyabc};
if(vigtype=="A"){lu=altluabc};
for(i=0;i<et.length;i++)
{let=et.charAt(i);letinabc=abc.indexOf(let);
if(letinabc<0){dt+=let;et=et.substring(0,i)+et.substring(i+1,et.length);i--}
else{
if(dir=="E"){dt+=lu.charAt((key1.indexOf(let)+key1.length+key1.indexOf(key2.charAt(i%key2.length)))%key1.length);};
if(dir=="D"){dt+=lu.charAt((key1.indexOf(let)+key1.length-key1.indexOf(key2.charAt(i%key2.length)))%key1.length);};};

};
return dt;};

function DoFreqCnt(x,abc)
{var i,abc,pos,freqs;
 pos=x.indexOf(" ");while(pos>-1){x=x.substring(0,pos)+x.substring(pos+1,x.length);pos=x.indexOf(" ");};
 x=x.toUpperCase();freqs="";
 letarr=new Array("");
 for(i=0;i<abc.length;i++){letarr[i]=0;};
 for(i=0;i<x.length;i++){letarr[abc.indexOf(x.charAt(i))]++};
 for(i=0;i<abc.length;i++){freqs+=abc.charAt(i)+":"+letarr[i]+"/"+x.length+"="+letarr[i]/x.length+"\n";};
 return freqs;
}

function DoRowColumnTranspose(et,rowcol,jump,startrow)
{dt="";if((et=="")||(rowcol=="")||(jump=="")||(startrow=="")){dt="You must supply all values";return dt;}
maxrow=eval(rowcol.substring(0,rowcol.indexOf(",")));
maxcol=eval(rowcol.substring(rowcol.indexOf(",")+1,rowcol.length));
jump=eval(jump);startrow=eval(startrow);
if(startrow>maxrow){dt="Start Row must be <= Max Rows";return dt;}
lin=new Array("");
for(i=0;i<maxrow;i++){lin[i]=et.substring(maxcol*i,maxcol*(i+1))};
row=startrow-1;col=maxcol-1;//starting point
for(i=0;i<(maxrow*maxcol);i++)
{dt+=lin[row].charAt(col);
 row=row+jump;
 while(row>=maxrow){row-=maxrow;col-=1;};
 while(col<=-1){col+=maxcol;row-=1;};
 while(row<=-1){row+=maxrow;col-=1;};
 while(col>=maxcol){col-=maxcol;row-=1;};
};
return dt;};


function DoModTranspose(et,startlet,jumpinc,modulus)
{dt="";if((et=="")||(startlet=="")||(jumpinc=="")||(modulus=="")){dt="You must supply all values";return dt;}
startlet=eval(startlet)-1;jumpinc=eval(jumpinc);modulus=eval(modulus);
if(startlet>modulus){dt="startlet must be <= maxchar";return dt;}
et=escape(et);
pos=et.indexOf("%0D");
while(pos>-1){et=et.substring(0,pos)+et.substring(pos+3,et.length);pos=et.indexOf("%0D");};
pos=et.indexOf("%0A");
while(pos>-1){et=et.substring(0,pos)+et.substring(pos+3,et.length);pos=et.indexOf("%0A");};
et=unescape(et);
for(i=0;i<(modulus);i++){dt+=et.charAt((startlet+jumpinc*i)%modulus);};
return dt;};


function DoAsciiHex(x,dir)
{hex="0123456789ABCDEF";almostAscii=' !"#$%&'+"'"+'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ['+'\\'+']^_`abcdefghijklmnopqrstuvwxyz{|}';r="";
if(dir=="A2H")
{for(i=0;i<x.length;i++){let=x.charAt(i);pos=almostAscii.indexOf(let)+32;h16=Math.floor(pos/16);h1=pos%16;r+=hex.charAt(h16)+hex.charAt(h1);};};
if(dir=="H2A")
{for(i=0;i<x.length;i++){let1=x.charAt(2*i);let2=x.charAt(2*i+1);val=hex.indexOf(let1)*16+hex.indexOf(let2);r+=almostAscii.charAt(val-32);};};
return r;
};


function DoSubstitute(x,orig,sub,dir)
{
x=x.toUpperCase();r="";
if(dir=="e")
{for(i=0;i<x.length;i++){let=x.charAt(i);pos=orig.indexOf(let);if(pos>-1){r+=sub.charAt(pos)}else{r+=let}}};
if(dir=="d")
{for(i=0;i<x.length;i++){let=x.charAt(i);pos=sub.indexOf(let);if(pos>-1){r+=orig.charAt(pos)}else{r+=let}}};
return r;
};

function SwitchEm(x,a,b)
{
posA=x.indexOf(a);
posB=x.indexOf(b);
r1=x.substring(0,posA)+b+x.substring(posA+1,x.length);
r2=r1.substring(0,posB)+a+r1.substring(posB+1,r1.length);
return r2;
};





function MakePlayfairSquare(abc,key1)
{
cyabc=MakeCipherABC(abc,key1);
row = new Array();for(i=0;i<5;i++){row[i]=""};
for(i=0;i<5;i++){for(j=0;j<5;j++)row[i]+=cyabc.charAt(5*i+j);};
sqr="";for(i=0;i<5;i++){sqr+=row[i]+"\n"};
return sqr;
};


function DoPlayfair(et,abc,key1,dir,dup)
{
et=et.toUpperCase();abc=abc.toUpperCase();key1=key1.toUpperCase();
pos=et.indexOf(" ");
while(pos>-1){et=et.substring(0,pos)+et.substring(pos+1,et.length);pos=et.indexOf(" ");};

pos=et.indexOf("?");
while(pos>-1){et=et.substring(0,pos)+et.substring(pos+1,et.length);pos=et.indexOf("?");};

for(i=0;i<et.length;i=i+2)
{let1=et.charAt(i);let2=et.charAt(i+1);if(let1==let2){et=et.substring(0,i+1)+"X"+et.substring(i+1,et.length)};};
if( (et.length%2)==1 ){et+='X'}

if(dup!=""){
pos=et.indexOf(dup);
while(pos>-1){et=et.substring(0,pos)+"I"+et.substring(pos+1,et.length);pos=et.indexOf(dup);};
};

cyabc=MakeCipherABC(abc,key1)
row=new Array();for(i=0;i<5;i++){row[i]=""};
for(i=0;i<5;i++){for(j=0;j<5;j++)row[i]+=cyabc.charAt(5*i+j);};

shf=1;if(dir=="E"){shf=1};if(dir=="D"){shf=4};

dt="";
for(i=0;i<et.length;i=i+2)
{
pos1=cyabc.indexOf(et.charAt(i));pos2=cyabc.indexOf(et.charAt(i+1));
x1=pos1%5;y1=Math.floor(pos1/5);x2=pos2%5;y2=Math.floor(pos2/5);

if(y1==y2){x1=(x1+shf)%5;x2=(x2+shf)%5}
else if(x1==x2){y1=(y1+shf)%5;y2=(y2+shf)%5}
else{temp=x1;x1=x2;x2=temp};

dt+=row[y1].charAt(x1)+row[y2].charAt(x2) ;
};


return dt;
};



		</script>
<table width="920" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td class="mainpage" valign="top" bgcolor="#E4E4E4"><table width="910" border="0" cellspacing="0" cellpadding="0"><tr><td width="533" valign="top"><table width="910" border="0" cellspacing="0" cellpadding="0">
<tr><td class="ctitle" valign="middle">Type or paste in the text you want to encrypt or decrypt</td></tr>
<tr><td valign="top"><textarea class="m1write" name="mess"></textarea></td></tr>
<tr><td class="ctitle" valign="middle">Enter Shift Value (1-25) maxlength = 2 numbers</td></tr>
<tr><td><input  class="p1write" type="text" name="CShift" value="10" maxlength="2"/></td></tr>
</table></td></tr></table></td></tr></tr><tr><td class="infobot"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td width="15%"><input type="button" class="button" value="encrypt" onclick="mess.value=DoCaeserEncrypt(mess.value,CShift.value);" name="CaeserEncryptBut" /></td><td width="15%"><input type="button" class="button" value="decrypt" onclick="mess.value=DoCaeserDecrypt(mess.value,CShift.value);" name="decode" /></td><td width="15%"><input class="button" type="reset" value="clear" name="clear" /></td><td width="55%">The transformation can be represented by aligning two alphabets; the cipher alphabet is the plain alphabet rotated left or right by some number of positions.</td></tr></table></td></tr><tr><td height="40"></td></tr>
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
<td width="184" height="81" valign="middle" class="morebut2">Caesar Shift Code<br />Encrypt Message</td>
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