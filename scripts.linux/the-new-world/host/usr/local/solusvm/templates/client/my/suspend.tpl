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
    <div id='infoboxok'><strong>{#suspend_msg_success#}</strong><br>{#suspend_msg_01#}</div>
    {elseif $msg == "03"}
    <div id='infoboxerror'><strong>{#suspend_msg_error#}</strong><br>{#suspend_msg_03#}</div>
    {/if}
   </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px">&nbsp;</td>
        </tr>
      
    </table>
   
 {include file=$footer}