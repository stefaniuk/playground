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
    {if $msg == "02"}
    <div id='infoboxerror'><strong>{#qbackup_msg_error#}</strong><br>{#qbackup_msg_02#}</div>
    {elseif $msg == "03"}
    <div id='infoboxok'><strong>{#qbackup_msg_success#}</strong><br>{#qbackup_msg_03#}</div>
    {elseif $msg == "01"}
    <div id='infoboxerror'><strong>{#qbackup_msg_error#}</strong><br>{#qbackup_msg_01#}</div>
    {elseif $msg == "04"}
    <div id='infoboxerror'><strong>{#qbackup_msg_error#}</strong><br>{#qbackup_msg_04#}</div>
    {elseif $msg == "05"}
    <div id='infoboxerror'><strong>{#qbackup_msg_error#}</strong><br>{#qbackup_msg_05#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#qbackup_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px"><strong>{#qbackup_title_sub#}</strong><br />
          {#qbackup_title_sub_sub#}</td>
        </tr>
      <tr>
        <td  style="padding:3px"><form id="" method="post" action=""><input type="submit" name="qbackup" class="button" id="qbackup" value="{#qbackup_start_button#}" />
                      
                  </form></td>
      </tr>
    </table>
 {include file=$footer}