{include file=$header}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><table width="100%" border="0" cellspacing="0" cellpadding="3">
      <tr>
    <td align="center">
    {if $msg == "01"}
    <div id='infoboxok'><strong>{#rdns_msg_success#}</strong><br>{#rdns_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxerror'><strong>{#rdns_msg_error#}</strong><br>{#rdns_msg_02#}</div>
    {elseif $msg == "03"}
    <div id='infoboxerror'><strong>{#rdns_msg_error#}</strong><br>{#rdns_msg_03#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:8px 3px 3px 3px"><h4>{#rdns_title#}: {$ipaddress}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#rdns_title_sub#}</td>
        </tr>
        <form id="" method="post" action="">
     
     {if $nodns}
    
    <tr><td>
    <div id='infoboxwarn'><strong>{#rdns_msg_04#}</strong><br>{#rdns_msg_02#}</div>
    </td></tr>
    {else}
      <tr>
      
        <td  style="padding:10px 3px 3px 3px"><input name="newhostname" type="text" class="inputfield" id="newhostname" size="40" />  Current: {$hostname}</td>
      </tr>
      <tr>
        <td  style="padding:3px"><input type="submit" name="rdns" class="button" id="rdns" value="{#rdns_button#}" />
                      
                  </td>
      </tr>
      {/if}
      </form> 
    </table>
   
 {include file=$footer}