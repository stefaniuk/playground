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
     <tr><td><br />
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td style="border:1px solid #cccccc">
          <table width="100%" border="0"  bgcolor="#E9E9E9" cellspacing="1" cellpadding="2">
        		<form method="post" action="" onsubmit="confirm_rebuild();return false;">
                <tr>
        		  <td colspan="3" align="center" bgcolor="#E6E6E6" style='padding: 8px; font-weight: bold;border-bottom: 1px solid #cccccc'>Operating Systems</td>
      		  </tr>
        		{foreach item=template from=$templatedata}
                <tr>
        		  <td align="center" bgcolor="#FFFFFF" width="1px" style='padding: 4px'><img src="../{$templatedirectory}/default/images/icons/{$template.distro}.jpg"/></td>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 6px;'><strong>{$template.friendlyname}</strong><br />{$template.description}</td>
        		  <td align="left" bgcolor="#FFFFFF" width="1px" style='padding: 4px;'>{$template.radio}</td>
      		  </tr>
            {/foreach}
         <tr>
           <td colspan="3" align="right" valign="top" ><input type="submit" name="reinstall" class="button" id="reinstall" value="{#reinstall_button#}" /></td></tr>
</form>
</table>
</td>
 </tr>	
          </table>     
     </td></tr>
      
        </table> </td>
      </tr>
      <tr>
        <td  style="padding:3px">
        </td>
      </tr>
    </table>
 {include file=$footer}