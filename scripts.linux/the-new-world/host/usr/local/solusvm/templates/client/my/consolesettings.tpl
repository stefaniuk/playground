{include file=$header}
{include file=$overview}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><table width="100%" border="0" cellspacing="0" cellpadding="3">
      <tr>
    <td align="center">
    {if $msg == "01"}
    <div id='infoboxok'><strong>{#console_settings_msg_success#}</strong><br>{#console_settings_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxerror'><strong>{#console_settings_msg_error#}</strong><br>{#console_settings_msg_02#}</div>
    {elseif $msg == "G01"}
    <div id='infoboxerror'><strong>{#console_settings_msg_error#}</strong><br>{#generic_msg_01#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#console_settings_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#console_settings_title_sub#}</td>
        </tr>
      <tr>
      <form id="" method="post" action="">
        <td  style="padding:10px 3px 3px 3px"><input type="text" class="inputfield" name="newconsolepassword" id="newconsolepassword" /></td>
      </tr>
      <tr>
        <td  style="padding:3px"><input type="submit" name="consolepassword" class="button" id="consolepassword" value="{#console_settings_button#}" />
                      
                  </td>
      </form> </tr>
    </table>
   
 {include file=$footer}