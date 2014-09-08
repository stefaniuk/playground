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
    <div id='infoboxok'><strong>{#clientapi_msg_success#}</strong><br>{#clientapi_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxok'><strong>{#clientapi_msg_success#}</strong><br>{#clientapi_msg_02#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#clientapi_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#clientapi_title_sub#}</td>
        </tr>
      <tr>
        <td align="left"  style="padding:3px"><table border="0">
  <tr>
    <td style="border:1px #CCC solid">
<table border="0" cellpadding="5">
  <tr>
    <td align="right"><strong>{#clientapi_key#}:</strong></td>
    <td align="left">{$akey}</td>
  </tr>
  <tr>
    <td align="right"><strong>{#clientapi_hash#}:</strong></td>
    <td align="left">{$ahash}</td>
  </tr>
  <tr>
    <td align="right"><strong>{#clientapi_status#}:</strong></td>
    <td align="left">{if $astatus == "Active"}<strong><span style="color:#090">Enabled</span></strong>&nbsp;&nbsp;&nbsp;[<a href="clientapi.php?action=disable&id={$vide}">disable</a>]{elseif $astatus == "Disabled"}<strong><span style="color: #000">Disabled</span></strong>&nbsp;&nbsp;&nbsp;[<a href="clientapi.php?action=enable&id={$vide}">enable</a>]{else}{/if}</td>
  </tr>
</table>
</td>
  </tr>
</table>
</td>
    </tr>
      <form id="" method="post" action="">
 
      <tr>
        <td  style="padding:3px"><input type="submit" name="generate" class="button" id="generate" value="{#clientapi_button#}" />
                      
                  </td>
      </form> </tr>
    </table>
   
 {include file=$footer}