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
    <div id='infoboxerror'><strong>{#boot_msg_error#}</strong><br>{#boot_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxok'><strong>{#boot_msg_success#}</strong><br>{#boot_msg_02#}</div>
    {elseif $msg == "G01"}
    <div id='infoboxerror'><strong>{#boot_msg_error#}</strong><br>{#generic_msg_01#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#boot_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#boot_title_sub#}</td>
        </tr>
      <tr>
        <td  style="padding:3px"><form id="" method="post" action=""><input type="submit" name="boot" class="button" id="boot" value="{#boot_button#}" />
                      
                  </form></td>
      </tr>
    </table>
 {include file=$footer}