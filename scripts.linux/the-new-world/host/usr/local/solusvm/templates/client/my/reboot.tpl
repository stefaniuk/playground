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
    <div id='infoboxok'><strong>{#reboot_msg_success#}</strong><br>{#reboot_msg_01#}</div>
    {elseif $msg == "04"}
    <div id='infoboxerror'><strong>{#reboot_msg_error#}</strong><br>{#generic_msg_01#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#reboot_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#reboot_title_sub#}</td>
        </tr>
      <tr>
        <td  style="padding:3px"><form id="" method="post" action=""><input type="submit" name="reboot" class="button" id="reboot" value="{#reboot_button#}" />
                      
                  </form></td>
      </tr>
    </table>
 {include file=$footer}