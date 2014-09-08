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
    <div id='infoboxok'><strong>{#hostname_msg_success#}</strong><br>{#hostname_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxok'><strong>{#hostname_msg_success#}</strong><br>{#hostname_msg_02#}</div>
    {elseif $msg == "03"}
    <div id='infoboxerror'><strong>{#hostname_msg_error#}</strong><br>{#hostname_msg_03#}</div>
    {elseif $msg == "04"}
    <div id='infoboxerror'><strong>{#hostname_msg_error#}</strong><br>{#generic_msg_01#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#hostname_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{if $vt == "xenhvm"}{#hostname_msg_04#}{else}{#hostname_title_sub#}{/if}</td>
        </tr>
        <form id="" method="post" action="">
      <tr>
      
        <td  style="padding:10px 3px 3px 3px"><input name="newhostname" type="text" class="formfield" id="newhostname" size="40" />  i.e: anything.server.com</td>
      </tr>
      <tr>
        <td  style="padding:3px"><input type="submit" name="hostname" class="button" id="hostname" value="{#hostname_button#}" />
                      
                  </td>
      </tr></form> 
    </table>  
 {include file=$footer}