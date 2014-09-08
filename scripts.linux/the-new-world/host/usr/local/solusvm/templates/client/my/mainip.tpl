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
    <div id='infoboxok'><strong>{#mainip_msg_success#}</strong><br>{#mainip_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxok'><strong>{#mainip_msg_success#}</strong><br>{#mainip_msg_02#}</div>
    {elseif $msg == "04"}
    <div id='infoboxerror'><strong>{#mainip_msg_error#}</strong><br>{#generic_msg_01#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#mainip_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#mainip_title_sub#}</td>
        </tr>
        <tr><td>
        {if $noips}
    <div id='infoboxwarn'><strong>{#mainip_msg_04#}</strong><br>{#mainip_msg_03#}</div> 
    
</td></tr>    {else}
 <form id="" method="post" action="">      
       <tr>
        <td  style="padding:3px"><select name="ipaddress" id="ipaddress">
                     {foreach item=freeip from=$iplist} <option value="{$freeip.ipaddress}">{$freeip.ipaddress}</option>{/foreach}
                 </select>
                      
                 </td>
      </tr>
      <tr>
        <td  style="padding:3px"><input type="submit" name="change" class="button" id="change" value="{#mainip_button#}" />
                      
                 </td>
      </tr>
      </form>
      {/if}
    </table>
 {include file=$footer}