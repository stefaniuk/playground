{include file=$header}
<form action="" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:160px">
   <tr>
     <td align="center">


 <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center">{$msg}</td>
  </tr>
</table>


 <table width="350" border="0"style=" background-color: #ffffff; padding:15px 3px 3px 3px; border:5px solid #cccccc;" cellspacing="0" cellpadding="0">
 <tr>
 <td colspan="2" align="center" bgcolor="#FFFFFF" style="font-size: 19px; padding:15px 3px 3px 3px; font-weight:bold">Request a new password</td>
    </tr>
  <tr>
 <td colspan="2" align="left" bgcolor="#FFFFFF" style="padding:15px 3px 3px 15px; font-weight:bold">Username:</td>
    </tr>
  <tr>
    <td colspan="2" align="center" bgcolor="#FFFFFF" style="padding:3px 3px 6px 3px; font-weight:bold"><input type="text" style="border: 1px solid #CCCCCC; padding: 7px; background-color: #F3F3F3; width: 300px; height: 17px" name="username" id="username" /></td>
  </tr>
  <tr>
    <td width="128" align="center" bgcolor="#FFFFFF" style="padding:3px 3px 15px 3px;">&nbsp;</td>
    <td width="191" align="right" bgcolor="#FFFFFF" style="padding:3px 15px 15px 15px;"><input  style="background-color: #D6D6D6; color: #666666; font-weight: bold; border: 1px solid #CCCCCC; margin-top: 5px; margin-bottom: 5px; padding: 5px 7px 5px 7px;" type="submit" name="Submit" value="Request" /></td>
  </tr>

</table><table width="350" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td width="199" align="left" style="font-size: 9px"></td>
    <td width="139" align="right" style="font-size: 9px"><a href="login.php" title="Login">Back to Login</a></td>
  </tr>
</table>

</td>
   </tr>
 </table>
</form>
{include file=$footer}
