{include file=$header}
<form action="" method="post">
{if $maintenancemode}
<div class="notification information png_bg">
{$mmmsg}
<div>
{else}

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:160px">
   <tr>
     <td align="center">
     {if $error == 'failed'}
     <table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td style="margin-bottom:30px" align="center"><div id='loginerror'><strong>Username/Password Invalid!</strong><br>All invalid login attempts are logged. Too many failed attempts will result in your ip address being blacklisted.</div></td>
  </tr>
</table>
{/if}
{if $error == 'blacklisted'}
 <table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td style="margin-bottom:30px" align="center"><div id='loginerror'><strong>Error!!</strong><br>Your IP Address is blacklisted. Please try again later.</div></td>
  </tr>
</table>
{/if}

 <table width="350" border="0"style="background-color: #ffffff; padding:15px 3px 3px 3px; border:5px solid #cccccc;" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" align="center" bgcolor="#FFFFFF" style="font-size: 19px; padding:15px 3px 3px 3px; font-weight:bold"></td>
  </tr>
  <tr>
 <td colspan="2" align="left" bgcolor="#FFFFFF" style="padding:15px 3px 3px 15px; font-weight:bold">Username:</td>
    </tr>
  <tr>
    <td colspan="2" align="center" bgcolor="#FFFFFF" style="padding:3px 3px 6px 3px; font-weight:bold"><input type="text" style="border: 1px solid #CCCCCC; padding: 7px; background-color: #F3F3F3; width: 300px; height: 17px" name="username" id="username" /></td>
    </tr>
  <tr>
    <td colspan="2" align="left" bgcolor="#FFFFFF" style="padding:3px 0 0 15px; font-weight:bold">
      Password:</td>
    </tr>
  <tr>
    <td colspan="2" align="center" bgcolor="#FFFFFF" style="padding:3px; font-weight:bold">
      <input type="password" style="border: 1px solid #CCCCCC; padding: 7px; background-color: #F3F3F3; width: 300px; height: 17px" name="password" id="password" />
    </td>
    </tr>
	<tr>
		<td width="50" align="left" bgcolor="#FFFFFF" style="padding:6px 3px 3px 15px;">Language:</td>
		<td width="300" align="left" bgcolor="#FFFFFF" style="padding:6px">
			<select name="language">
			{foreach item=item from=$langlist}
				<option value="{$item.file}" {if $item.file == "english"}selected="selected"{/if}>{$item.file}</option>
			{/foreach}
			</select>
		</td>
	</tr>

  <tr>
    <td colspan="2" align="right" bgcolor="#FFFFFF" style="padding:3px 15px 15px 15px;"><input  style="background-color: #D6D6D6; color: #666666; font-weight: bold; border: 1px solid #CCCCCC; margin-top: 5px; margin-bottom: 5px; padding: 5px 7px 5px 7px;" type="submit" name="Submit" value="Login" /></td>
    </tr>

</table><table width="350" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td width="199" align="left" style='font-size: 9px; color:#000000'></td>
    <td width="139" align="right" style="font-size: 9px"><a href="lostpassword.php" title="Lost Password">Forgot Password?</a></td>
  </tr>
</table>
</td>
   </tr>
 </table>
 {/if}
</form>
{include file=$footer}
