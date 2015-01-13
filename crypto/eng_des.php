<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>DES Algorithm</title>
<meta name="description" content="DES using strong encryption and a faster algorithm." />
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
<form name="CRYPT">
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
<tr><td width="920" class="rolbuz"><span class="page1title">DES Algorithm <br />DES using strong encryption and a faster algorithm.</span></td></tr>
</table></td></tr></table>
</div><div class="maincode">
<script language="Javascript">
function dP(){
	salt=document.CRYPT.Salt.value;
	pw_salt=this.crypt(salt,document.CRYPT.PW.value); 

	document.CRYPT.ENC_PW.value=pw_salt[0];
	document.CRYPT.Salt.value=pw_salt[1];
	return false;
}

function bTU(b){
      value=Math.floor(b);
      return (value>=0?value:value+256);
}
function fBTI(b,offset){
      value=this.byteToUnsigned(b[offset++]);
      value|=(this.byteToUnsigned(b[offset++])<<8);
      value|=(this.byteToUnsigned(b[offset++])<<16);
      value|=(this.byteToUnsigned(b[offset++])<<24);
      return value;
}
function iTFB(iValue,b,offset){
      b[offset++]=((iValue)&0xff);
      b[offset++]=((iValue>>>8)&0xff);
      b[offset++]=((iValue>>>16)&0xff);
      b[offset++]=((iValue>>>24)&0xff);
}
function P_P(a,b,n,m,results){
      t=((a>>>n)^b)&m;
      a^=t<<n;
      b^=t;
      results[0]=a;
      results[1]=b;
}
function H_P(a,n,m){
      t=((a<<(16-n))^a)&m;
      a=a^t^(t>>>(16-n));
      return a;
}
function d_s_k(key){
      schedule=new Array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
      c=this.fourBytesToInt(key,0);
      d=this.fourBytesToInt(key,4);
      results=new Array(0,0);
      this.PERM_OP(d,c,4,0x0f0f0f0f,results);
      d=results[0];c=results[1];
      c=this.HPERM_OP(c,-2,0xcccc0000);
      d=this.HPERM_OP(d,-2,0xcccc0000);
      this.PERM_OP(d,c,1,0x55555555,results);
      d=results[0];c=results[1];
      this.PERM_OP(c,d,8,0x00ff00ff,results);
      c=results[0];d=results[1];
      this.PERM_OP(d,c,1,0x55555555,results);
      d=results[0];c=results[1];
      d=(((d&0x000000ff)<<16)|(d&0x0000ff00)|((d&0x00ff0000)>>>16)|((c&0xf0000000)>>>4));
      c&=0x0fffffff;
      s=0;t=0;
      j=0;
      for(i=0;i<this.ITERATIONS;i++){
         if(this.shifts2[i]){
            c=(c>>>2)|(c<<26);
            d=(d>>>2)|(d<<26);
         }else{
            c=(c>>>1)|(c<<27);
            d=(d>>>1)|(d<<27);
         }
         c&=0x0fffffff;
         d&=0x0fffffff;
         s=this.skb[0][c&0x3f]|this.skb[1][((c>>>6)&0x03)|((c>>>7)&0x3c)]|this.skb[2][((c>>>13)&0x0f)|((c>>>14)&0x30)]|this.skb[3][((c>>>20)&0x01)|((c>>>21)&0x06)|((c>>>22)&0x38)];
         t=this.skb[4][d&0x3f]|this.skb[5][((d>>>7)&0x03)|((d>>>8)&0x3c)]|this.skb[6][(d>>>15)&0x3f]|this.skb[7][((d>>>21)&0x0f)|((d>>>22)&0x30)];
         schedule[j++]=((t<< 16)|(s&0x0000ffff))&0xffffffff;
         s=((s>>>16)|(t&0xffff0000));
         s=(s<<4)|(s>>>28);
         schedule[j++]=s&0xffffffff;
      }
      return schedule;
}
function D_E(L,R,S,E0,E1,s){
      v=R^(R>>>16);
      u=v&E0;
      v=v&E1;
      u=(u^(u<<16))^R^s[S];
      t=(v^(v<<16))^R^s[S+1];
      t=(t>>>4)|(t<<28);
      L^=this.SPtrans[1][t&0x3f]|this.SPtrans[3][(t>>>8)&0x3f]|this.SPtrans[5][(t>>>16)&0x3f]|this.SPtrans[7][(t>>>24)&0x3f]|this.SPtrans[0][u&0x3f]|this.SPtrans[2][(u>>>8)&0x3f]|this.SPtrans[4][(u>>>16)&0x3f]|this.SPtrans[6][(u>>>24)&0x3f];
      return L;
}
function bdy(schedule,Eswap0,Eswap1) {
	left=0;
	right=0;
	t=0;
      for(j=0;j<25;j++){
         for(i=0;i<this.ITERATIONS*2;i+=4){
            left=this.D_ENCRYPT(left, right,i,Eswap0,Eswap1,schedule);
            right=this.D_ENCRYPT(right,left,i+2,Eswap0,Eswap1,schedule);
         }
         t=left; 
         left=right; 
         right=t;
      }
      t=right;
      right=(left>>>1)|(left<<31);
      left=(t>>>1)|(t<<31);
      left&=0xffffffff;
      right&=0xffffffff;
      results=new Array(0,0);
      this.PERM_OP(right,left,1,0x55555555,results); 
      right=results[0];left=results[1];
      this.PERM_OP(left,right,8,0x00ff00ff,results); 
      left=results[0];right=results[1];
      this.PERM_OP(right,left,2,0x33333333,results); 
      right=results[0];left=results[1];
      this.PERM_OP(left,right,16,0x0000ffff,results);
      left=results[0];right=results[1];
      this.PERM_OP(right,left,4,0x0f0f0f0f,results);
      right=results[0];left=results[1];
      out=new Array(0,0);
      out[0]=left;out[1]=right;
      return out;
}
function rC(){ return this.GOODCHARS[Math.floor(64*Math.random())]; }
function cript(salt,original){
	if(salt.length>=2) salt=salt.substring(0,2);
	while(salt.length<2) salt+=this.randChar();
	re=new RegExp("[^./a-zA-Z0-9]","g");
	if(re.test(salt)) salt=this.randChar()+this.randChar();
	charZero=salt.charAt(0)+'';
      charOne=salt.charAt(1)+'';
	ccZ=charZero.charCodeAt(0);
	ccO=charOne.charCodeAt(0);
	buffer=charZero+charOne+"           ";
      Eswap0=this.con_salt[ccZ];
      Eswap1=this.con_salt[ccO]<<4;
      key=new Array(0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0);
      for(i=0;i<key.length&&i<original.length;i++){
         iChar=original.charCodeAt(i);
         key[i]=iChar<<1;
      }
      schedule=this.des_set_key(key);
      out=this.body(schedule,Eswap0,Eswap1);
      b=new Array(0,0,0,0,0,0,0,0,0);
      this.intToFourBytes(out[0],b,0);
      this.intToFourBytes(out[1],b,4);
      b[8]=0;
      for(i=2,y=0,u=0x80;i<13;i++){
         for(j=0,c=0;j<6;j++){
            c<<=1;
            if((b[y]&u)!=0) c|=1;
            u>>>=1;
            if(u==0){
               y++;
               u=0x80;
            }
            buffer=buffer.substring(0,i)+String.fromCharCode(this.cov_2char[c])+buffer.substring(i+1,buffer.length);
         }
      }
	ret=new Array(buffer,salt);
      return ret;
}

function Crypt() {
this.ITERATIONS=16;
this.GOODCHARS=new Array(
	".","/","0","1","2","3","4","5","6","7",
	"8","9","A","B","C","D","E","F","G","H",
	"I","J","K","L","M","N","O","P","Q","R",
	"S","T","U","V","W","X","Y","Z","a","b",
	"c","d","e","f","g","h","i","j","k","l",
	"m","n","o","p","q","r","s","t","u","v",
	"w","x","y","z");
this.con_salt=new Array(
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, 
      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, 
      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, 
      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, 
      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, 
      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x01, 
      0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09, 
      0x0A,0x0B,0x05,0x06,0x07,0x08,0x09,0x0A, 
      0x0B,0x0C,0x0D,0x0E,0x0F,0x10,0x11,0x12, 
      0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A, 
      0x1B,0x1C,0x1D,0x1E,0x1F,0x20,0x21,0x22, 
      0x23,0x24,0x25,0x20,0x21,0x22,0x23,0x24, 
      0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C, 
      0x2D,0x2E,0x2F,0x30,0x31,0x32,0x33,0x34, 
      0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C, 
      0x3D,0x3E,0x3F,0x00,0x00,0x00,0x00,0x00 );
this.shifts2=new Array(
	false,false,true,true,true,true,true,true,
	false,true, true,true,true,true,true,false );
this.skb=new Array(0,0,0,0,0,0,0,0);
	this.skb[0]=new Array(
         0x00000000,0x00000010,0x20000000,0x20000010, 
         0x00010000,0x00010010,0x20010000,0x20010010, 
         0x00000800,0x00000810,0x20000800,0x20000810, 
         0x00010800,0x00010810,0x20010800,0x20010810, 
         0x00000020,0x00000030,0x20000020,0x20000030, 
         0x00010020,0x00010030,0x20010020,0x20010030, 
         0x00000820,0x00000830,0x20000820,0x20000830, 
         0x00010820,0x00010830,0x20010820,0x20010830, 
         0x00080000,0x00080010,0x20080000,0x20080010, 
         0x00090000,0x00090010,0x20090000,0x20090010, 
         0x00080800,0x00080810,0x20080800,0x20080810, 
         0x00090800,0x00090810,0x20090800,0x20090810, 
         0x00080020,0x00080030,0x20080020,0x20080030, 
         0x00090020,0x00090030,0x20090020,0x20090030, 
         0x00080820,0x00080830,0x20080820,0x20080830, 
         0x00090820,0x00090830,0x20090820,0x20090830 );
	this.skb[1]=new Array(
         0x00000000,0x02000000,0x00002000,0x02002000, 
         0x00200000,0x02200000,0x00202000,0x02202000, 
         0x00000004,0x02000004,0x00002004,0x02002004, 
         0x00200004,0x02200004,0x00202004,0x02202004, 
         0x00000400,0x02000400,0x00002400,0x02002400, 
         0x00200400,0x02200400,0x00202400,0x02202400, 
         0x00000404,0x02000404,0x00002404,0x02002404, 
         0x00200404,0x02200404,0x00202404,0x02202404, 
         0x10000000,0x12000000,0x10002000,0x12002000, 
         0x10200000,0x12200000,0x10202000,0x12202000, 
         0x10000004,0x12000004,0x10002004,0x12002004, 
         0x10200004,0x12200004,0x10202004,0x12202004, 
         0x10000400,0x12000400,0x10002400,0x12002400, 
         0x10200400,0x12200400,0x10202400,0x12202400, 
         0x10000404,0x12000404,0x10002404,0x12002404, 
         0x10200404,0x12200404,0x10202404,0x12202404 );
	this.skb[2]=new Array(
         0x00000000,0x00000001,0x00040000,0x00040001, 
         0x01000000,0x01000001,0x01040000,0x01040001, 
         0x00000002,0x00000003,0x00040002,0x00040003, 
         0x01000002,0x01000003,0x01040002,0x01040003, 
         0x00000200,0x00000201,0x00040200,0x00040201, 
         0x01000200,0x01000201,0x01040200,0x01040201, 
         0x00000202,0x00000203,0x00040202,0x00040203, 
         0x01000202,0x01000203,0x01040202,0x01040203, 
         0x08000000,0x08000001,0x08040000,0x08040001, 
         0x09000000,0x09000001,0x09040000,0x09040001, 
         0x08000002,0x08000003,0x08040002,0x08040003, 
         0x09000002,0x09000003,0x09040002,0x09040003, 
         0x08000200,0x08000201,0x08040200,0x08040201, 
         0x09000200,0x09000201,0x09040200,0x09040201, 
         0x08000202,0x08000203,0x08040202,0x08040203, 
         0x09000202,0x09000203,0x09040202,0x09040203 );
	this.skb[3]=new Array(
         0x00000000,0x00100000,0x00000100,0x00100100, 
         0x00000008,0x00100008,0x00000108,0x00100108, 
         0x00001000,0x00101000,0x00001100,0x00101100, 
         0x00001008,0x00101008,0x00001108,0x00101108, 
         0x04000000,0x04100000,0x04000100,0x04100100, 
         0x04000008,0x04100008,0x04000108,0x04100108, 
         0x04001000,0x04101000,0x04001100,0x04101100, 
         0x04001008,0x04101008,0x04001108,0x04101108, 
         0x00020000,0x00120000,0x00020100,0x00120100, 
         0x00020008,0x00120008,0x00020108,0x00120108, 
         0x00021000,0x00121000,0x00021100,0x00121100, 
         0x00021008,0x00121008,0x00021108,0x00121108, 
         0x04020000,0x04120000,0x04020100,0x04120100, 
         0x04020008,0x04120008,0x04020108,0x04120108, 
         0x04021000,0x04121000,0x04021100,0x04121100, 
         0x04021008,0x04121008,0x04021108,0x04121108 );
	this.skb[4]=new Array(
         0x00000000,0x10000000,0x00010000,0x10010000, 
         0x00000004,0x10000004,0x00010004,0x10010004, 
         0x20000000,0x30000000,0x20010000,0x30010000, 
         0x20000004,0x30000004,0x20010004,0x30010004, 
         0x00100000,0x10100000,0x00110000,0x10110000, 
         0x00100004,0x10100004,0x00110004,0x10110004, 
         0x20100000,0x30100000,0x20110000,0x30110000, 
         0x20100004,0x30100004,0x20110004,0x30110004, 
         0x00001000,0x10001000,0x00011000,0x10011000, 
         0x00001004,0x10001004,0x00011004,0x10011004, 
         0x20001000,0x30001000,0x20011000,0x30011000, 
         0x20001004,0x30001004,0x20011004,0x30011004, 
         0x00101000,0x10101000,0x00111000,0x10111000, 
         0x00101004,0x10101004,0x00111004,0x10111004, 
         0x20101000,0x30101000,0x20111000,0x30111000, 
         0x20101004,0x30101004,0x20111004,0x30111004 );
	this.skb[5]=new Array(
         0x00000000,0x08000000,0x00000008,0x08000008, 
         0x00000400,0x08000400,0x00000408,0x08000408, 
         0x00020000,0x08020000,0x00020008,0x08020008, 
         0x00020400,0x08020400,0x00020408,0x08020408, 
         0x00000001,0x08000001,0x00000009,0x08000009, 
         0x00000401,0x08000401,0x00000409,0x08000409, 
         0x00020001,0x08020001,0x00020009,0x08020009, 
         0x00020401,0x08020401,0x00020409,0x08020409, 
         0x02000000,0x0A000000,0x02000008,0x0A000008, 
         0x02000400,0x0A000400,0x02000408,0x0A000408, 
         0x02020000,0x0A020000,0x02020008,0x0A020008, 
         0x02020400,0x0A020400,0x02020408,0x0A020408, 
         0x02000001,0x0A000001,0x02000009,0x0A000009, 
         0x02000401,0x0A000401,0x02000409,0x0A000409, 
         0x02020001,0x0A020001,0x02020009,0x0A020009, 
         0x02020401,0x0A020401,0x02020409,0x0A020409 );
	this.skb[6]=new Array(
         0x00000000,0x00000100,0x00080000,0x00080100, 
         0x01000000,0x01000100,0x01080000,0x01080100, 
         0x00000010,0x00000110,0x00080010,0x00080110, 
         0x01000010,0x01000110,0x01080010,0x01080110, 
         0x00200000,0x00200100,0x00280000,0x00280100, 
         0x01200000,0x01200100,0x01280000,0x01280100, 
         0x00200010,0x00200110,0x00280010,0x00280110, 
         0x01200010,0x01200110,0x01280010,0x01280110, 
         0x00000200,0x00000300,0x00080200,0x00080300, 
         0x01000200,0x01000300,0x01080200,0x01080300, 
         0x00000210,0x00000310,0x00080210,0x00080310, 
         0x01000210,0x01000310,0x01080210,0x01080310, 
         0x00200200,0x00200300,0x00280200,0x00280300, 
         0x01200200,0x01200300,0x01280200,0x01280300, 
         0x00200210,0x00200310,0x00280210,0x00280310, 
         0x01200210,0x01200310,0x01280210,0x01280310 );
	this.skb[7]=new Array(
         0x00000000,0x04000000,0x00040000,0x04040000, 
         0x00000002,0x04000002,0x00040002,0x04040002, 
         0x00002000,0x04002000,0x00042000,0x04042000, 
         0x00002002,0x04002002,0x00042002,0x04042002, 
         0x00000020,0x04000020,0x00040020,0x04040020, 
         0x00000022,0x04000022,0x00040022,0x04040022, 
         0x00002020,0x04002020,0x00042020,0x04042020, 
         0x00002022,0x04002022,0x00042022,0x04042022, 
         0x00000800,0x04000800,0x00040800,0x04040800, 
         0x00000802,0x04000802,0x00040802,0x04040802, 
         0x00002800,0x04002800,0x00042800,0x04042800, 
         0x00002802,0x04002802,0x00042802,0x04042802, 
         0x00000820,0x04000820,0x00040820,0x04040820, 
         0x00000822,0x04000822,0x00040822,0x04040822, 
         0x00002820,0x04002820,0x00042820,0x04042820, 
         0x00002822,0x04002822,0x00042822,0x04042822 );
this.SPtrans=new Array(0,0,0,0,0,0,0,0);
	this.SPtrans[0]=new Array(
         0x00820200,0x00020000,0x80800000,0x80820200,
         0x00800000,0x80020200,0x80020000,0x80800000,
         0x80020200,0x00820200,0x00820000,0x80000200,
         0x80800200,0x00800000,0x00000000,0x80020000,
         0x00020000,0x80000000,0x00800200,0x00020200,
         0x80820200,0x00820000,0x80000200,0x00800200,
         0x80000000,0x00000200,0x00020200,0x80820000,
         0x00000200,0x80800200,0x80820000,0x00000000,
         0x00000000,0x80820200,0x00800200,0x80020000,
         0x00820200,0x00020000,0x80000200,0x00800200,
         0x80820000,0x00000200,0x00020200,0x80800000,
         0x80020200,0x80000000,0x80800000,0x00820000,
         0x80820200,0x00020200,0x00820000,0x80800200,
         0x00800000,0x80000200,0x80020000,0x00000000,
         0x00020000,0x00800000,0x80800200,0x00820200,
         0x80000000,0x80820000,0x00000200,0x80020200 );
	this.SPtrans[1]=new Array(
         0x10042004,0x00000000,0x00042000,0x10040000,

         0x10000004,0x00002004,0x10002000,0x00042000,
         0x00002000,0x10040004,0x00000004,0x10002000,
         0x00040004,0x10042000,0x10040000,0x00000004,
         0x00040000,0x10002004,0x10040004,0x00002000,
         0x00042004,0x10000000,0x00000000,0x00040004,
         0x10002004,0x00042004,0x10042000,0x10000004,
         0x10000000,0x00040000,0x00002004,0x10042004,
         0x00040004,0x10042000,0x10002000,0x00042004,
         0x10042004,0x00040004,0x10000004,0x00000000,
         0x10000000,0x00002004,0x00040000,0x10040004,
         0x00002000,0x10000000,0x00042004,0x10002004,
         0x10042000,0x00002000,0x00000000,0x10000004,
         0x00000004,0x10042004,0x00042000,0x10040000,
         0x10040004,0x00040000,0x00002004,0x10002000,
         0x10002004,0x00000004,0x10040000,0x00042000 );
	this.SPtrans[2]=new Array(
         0x41000000,0x01010040,0x00000040,0x41000040,
         0x40010000,0x01000000,0x41000040,0x00010040,
         0x01000040,0x00010000,0x01010000,0x40000000,
         0x41010040,0x40000040,0x40000000,0x41010000,
         0x00000000,0x40010000,0x01010040,0x00000040,
         0x40000040,0x41010040,0x00010000,0x41000000,
         0x41010000,0x01000040,0x40010040,0x01010000,
         0x00010040,0x00000000,0x01000000,0x40010040,
         0x01010040,0x00000040,0x40000000,0x00010000,
         0x40000040,0x40010000,0x01010000,0x41000040,
         0x00000000,0x01010040,0x00010040,0x41010000,
         0x40010000,0x01000000,0x41010040,0x40000000,
         0x40010040,0x41000000,0x01000000,0x41010040,
         0x00010000,0x01000040,0x41000040,0x00010040,
         0x01000040,0x00000000,0x41010000,0x40000040,
         0x41000000,0x40010040,0x00000040,0x01010000 );
	this.SPtrans[3]=new Array(
         0x00100402,0x04000400,0x00000002,0x04100402,
         0x00000000,0x04100000,0x04000402,0x00100002,
         0x04100400,0x04000002,0x04000000,0x00000402,
         0x04000002,0x00100402,0x00100000,0x04000000,
         0x04100002,0x00100400,0x00000400,0x00000002,
         0x00100400,0x04000402,0x04100000,0x00000400,
         0x00000402,0x00000000,0x00100002,0x04100400,
         0x04000400,0x04100002,0x04100402,0x00100000,
         0x04100002,0x00000402,0x00100000,0x04000002,
         0x00100400,0x04000400,0x00000002,0x04100000,
         0x04000402,0x00000000,0x00000400,0x00100002,
         0x00000000,0x04100002,0x04100400,0x00000400,
         0x04000000,0x04100402,0x00100402,0x00100000,
         0x04100402,0x00000002,0x04000400,0x00100402,
         0x00100002,0x00100400,0x04100000,0x04000402,
         0x00000402,0x04000000,0x04000002,0x04100400 );
	this.SPtrans[4]=new Array(
         0x02000000,0x00004000,0x00000100,0x02004108,
         0x02004008,0x02000100,0x00004108,0x02004000,
         0x00004000,0x00000008,0x02000008,0x00004100,
         0x02000108,0x02004008,0x02004100,0x00000000,
         0x00004100,0x02000000,0x00004008,0x00000108,
         0x02000100,0x00004108,0x00000000,0x02000008,
         0x00000008,0x02000108,0x02004108,0x00004008,
         0x02004000,0x00000100,0x00000108,0x02004100,
         0x02004100,0x02000108,0x00004008,0x02004000,
         0x00004000,0x00000008,0x02000008,0x02000100,
         0x02000000,0x00004100,0x02004108,0x00000000,
         0x00004108,0x02000000,0x00000100,0x00004008,
         0x02000108,0x00000100,0x00000000,0x02004108,
         0x02004008,0x02004100,0x00000108,0x00004000,
         0x00004100,0x02004008,0x02000100,0x00000108,
         0x00000008,0x00004108,0x02004000,0x02000008 );

	this.SPtrans[5]=new Array(
         0x20000010,0x00080010,0x00000000,0x20080800,
         0x00080010,0x00000800,0x20000810,0x00080000,
         0x00000810,0x20080810,0x00080800,0x20000000,
         0x20000800,0x20000010,0x20080000,0x00080810,
         0x00080000,0x20000810,0x20080010,0x00000000,
         0x00000800,0x00000010,0x20080800,0x20080010,
         0x20080810,0x20080000,0x20000000,0x00000810,
         0x00000010,0x00080800,0x00080810,0x20000800,
         0x00000810,0x20000000,0x20000800,0x00080810,
         0x20080800,0x00080010,0x00000000,0x20000800,
         0x20000000,0x00000800,0x20080010,0x00080000,
         0x00080010,0x20080810,0x00080800,0x00000010,
         0x20080810,0x00080800,0x00080000,0x20000810,
         0x20000010,0x20080000,0x00080810,0x00000000,
         0x00000800,0x20000010,0x20000810,0x20080800,
         0x20080000,0x00000810,0x00000010,0x20080010 );
	this.SPtrans[6]=new Array(
         0x00001000,0x00000080,0x00400080,0x00400001,
         0x00401081,0x00001001,0x00001080,0x00000000,
         0x00400000,0x00400081,0x00000081,0x00401000,
         0x00000001,0x00401080,0x00401000,0x00000081,
         0x00400081,0x00001000,0x00001001,0x00401081,
         0x00000000,0x00400080,0x00400001,0x00001080,
         0x00401001,0x00001081,0x00401080,0x00000001,
         0x00001081,0x00401001,0x00000080,0x00400000,
         0x00001081,0x00401000,0x00401001,0x00000081,
         0x00001000,0x00000080,0x00400000,0x00401001,
         0x00400081,0x00001081,0x00001080,0x00000000,
         0x00000080,0x00400001,0x00000001,0x00400080,
         0x00000000,0x00400081,0x00400080,0x00001080,
         0x00000081,0x00001000,0x00401081,0x00400000,
         0x00401080,0x00000001,0x00001001,0x00401081,
         0x00400001,0x00401080,0x00401000,0x00001001 );
	this.SPtrans[7]=new Array(
         0x08200020,0x08208000,0x00008020,0x00000000,
         0x08008000,0x00200020,0x08200000,0x08208020,
         0x00000020,0x08000000,0x00208000,0x00008020,
         0x00208020,0x08008020,0x08000020,0x08200000,
         0x00008000,0x00208020,0x00200020,0x08008000,
         0x08208020,0x08000020,0x00000000,0x00208000,
         0x08000000,0x00200000,0x08008020,0x08200020,
         0x00200000,0x00008000,0x08208000,0x00000020,
         0x00200000,0x00008000,0x08000020,0x08208020,
         0x00008020,0x08000000,0x00000000,0x00208000,
         0x08200020,0x08008020,0x08008000,0x00200020,
         0x08208000,0x00000020,0x00200020,0x08008000,
         0x08208020,0x00200000,0x08200000,0x08000020,
         0x00208000,0x00008020,0x08008020,0x08200000,
         0x00000020,0x08208000,0x00208020,0x00000000,
         0x08000000,0x08200020,0x00008000,0x00208020 );
this.cov_2char=new Array(
      0x2E,0x2F,0x30,0x31,0x32,0x33,0x34,0x35, 
      0x36,0x37,0x38,0x39,0x41,0x42,0x43,0x44, 
      0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C, 
      0x4D,0x4E,0x4F,0x50,0x51,0x52,0x53,0x54, 
      0x55,0x56,0x57,0x58,0x59,0x5A,0x61,0x62, 
      0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A, 
      0x6B,0x6C,0x6D,0x6E,0x6F,0x70,0x71,0x72, 
      0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A );
this.byteToUnsigned=bTU;
this.fourBytesToInt=fBTI;
this.intToFourBytes=iTFB;
this.PERM_OP=P_P;
this.HPERM_OP=H_P;
this.des_set_key=d_s_k;
this.D_ENCRYPT=D_E;
this.body=bdy;
this.randChar=rC;
this.crypt=cript;
this.displayPassword=dP;
}
Javacrypt=new Crypt();
</script>
<table width="920" border="0" align="center" cellpadding="0" cellspacing="0"><tr><td class="mainpage" valign="top" bgcolor="#E4E4E4"><table width="910" border="0" cellspacing="0" cellpadding="0"><tr><td width="533" valign="top"><table width="910" border="0" cellspacing="0" cellpadding="0"><tr><td class="ctitle" valign="middle">Type or paste in the text you want to encrypt</td></tr><tr><td valign="top"><textarea class="m2write" name="PW"></textarea></td></tr><tr><td valign="top"><textarea class="m4write" name="ENC_PW" readonly="readonly"></textarea></td></tr><tr><td class="ctitle" valign="middle">Enter your KeyPass! If you do not enter a password, one will be randomly generated.</td></tr><tr><td valign="top"><input type=text class="p1write"  name="Salt" maxlength="18"/></td></tr></table></td></tr></table></td></tr></tr><tr><td class="infobot"><table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td width="15%"><input type="button" class="button" value="encrypt" onClick="Javacrypt.displayPassword()" /></td><td width="15%"><input class="button" type="reset" value="clear" name="clear" /></td><td width="70%">Do note that DES only uses 8 byte keys and only works on 8 byte data blocks. See the Crypt/CBC documentation for proper syntax and use.</td></tr></table></td></tr><tr><td height="40"></td></tr>
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
<td width="184" height="81" valign="middle" class="morebut2">DES Algorithm<br />Strong Encryption</td>
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
<div style="float:left;">[ ONLINE: 49 USERS ]<br>Copyright &copy; 2007-2011 Crypo<br>All rights reserved</div>
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