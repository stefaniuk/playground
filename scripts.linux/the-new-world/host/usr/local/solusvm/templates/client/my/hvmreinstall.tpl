{include file=$header}
{literal}
<script type="text/javascript">
function confirm_rebuild() 
{  
if (confirm('All data currently on the virtual server will be destroyed\nAre you sure you want to continue?')){submit(); } 

} 
</script>
{/literal}
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
    <div id='infoboxok'><strong>{#reinstall_msg_success#}</strong><br>{#reinstall_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxerror'><strong>{#reinstall_msg_error#}</strong><br>{#reinstall_msg_02#}</div>
    {elseif $msg == "03"}
    <div id='infoboxerror'><strong>{#reinstall_msg_error#}</strong><br>{#generic_msg_01#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#reinstall_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#reinstall_title_sub#}</td>
        </tr>
      <tr>
        <td  style="padding:20px 3px 3px 3px"><table width="90%" border="0" cellspacing="0" cellpadding="3">
         {foreach item=template from=$templatedata}
         <form id="{$template.filename}" method="post" action="" onsubmit="confirm_rebuild();return false;">
         <tr>
            <td style="padding:3px 5px 20px 3px"><table width="100%" style="border-bottom: 1px dashed #cccccc" border="0" cellspacing="0" cellpadding="3">
              <tr>
                  <td width="6%" bgcolor="#FFFFFF" style="padding:5px"><img src="../{$templatedirectory}/default/images/icons/{$template.distro}.jpg"/></td>
                  <td width="83%" bgcolor="#FFFFFF" style="padding:5px"> <strong>{$template.friendlyname}</strong><br />{$template.description}</td>
                  <input name="template" type="hidden" value="{$template.filename}" />
                  <td width="11%" align="right" bgcolor="#FFFFFF"style="padding:5px"><input type="submit" name="reinstall" class="button" id="reinstall" value="{#reinstall_button#}" /></td>
                  </tr>
              </table>           </td>
            </tr>
            </form>
          {/foreach}
        </table> </td>
      </tr>
      <tr>
        <td  style="padding:3px">
        </td>
      </tr>
    </table>
 {include file=$footer}