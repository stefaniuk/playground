{include file=$header}
{literal}
<script type="text/javascript">  
	   	function checkUncheckAll(theElement) {
     var theForm = theElement.form, z = 0;
	 for(z=0; z<theForm.length;z++){
      if(theForm[z].type == 'checkbox' && theForm[z].name != 'checkall'){
	  theForm[z].checked = theElement.checked;
	  }
     }
    }
	
	function confirm_ip() 
{  
if (confirm('The virtual server will be rebooted\nAre you sure you want to continue?')){submit(); } 

} 
    </script>
    {/literal} 
{include file=$overview}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
   
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:0px"><h4>{#ip_title#}</h4></td>
        </tr>
        <tr>
        <td>
         {if $vt == "xenhvm" || $vt == "kvm"}
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td style="border:1px solid #cccccc">
          <table width="100%" border="0"  bgcolor="#E9E9E9" cellspacing="1" cellpadding="2">
        		<tr>
        		  <td colspan="2" align="center" bgcolor="#E6E6E6" style='padding: 8px; font-weight: bold;border-bottom: 1px solid #cccccc'>{#ip_ipv4_title#}</td>
      		  </tr>
        		<tr>
        		  <td align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold'>{#ip_table_ip#}</td>
        		  <td width="50%" align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold;'>{#ip_table_rdns#}</td>
      		    </tr>
        		<tr>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px; font-weight: bold;'><span style="color:orange"><strong>{$mainipaddress}</strong></span></td>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px; font-weight: bold;'>{if $rdns}<a href="rdns.php?id={$vmid}&ip={$mainipid}">{$rdns}</a>{else}<a href="rdns.php?id={$vmid}&ip={$mainipid}">[{#ip_rdns_button#}]</a>{/if}</td>
      		    </tr>
            
            
                 {if $aips}
                 
  {foreach item=item from=$iplist}
 
 <tr>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px;'>{$item.ipaddress}</td>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px; font-weight: bold;'>{if $item.rdns}<a href="rdns.php?id={$vmid}&ip={$item.ipaddressid}">{$item.rdns}</a>{else}<a href="rdns.php?id={$vmid}&ip={$item.ipaddressid}">[{#ip_rdns_button#}]</a>{/if}</td>
      		    </tr> 
  {/foreach}
  {/if}
</table>
</td>
            </tr>
	
          </table> 
         <br />
             <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td style="border:1px solid #cccccc">
          <table width="100%" border="0"  bgcolor="#E9E9E9" cellspacing="1" cellpadding="2">
        		<tr>
        		  <td colspan="3" align="center" bgcolor="#E6E6E6" style='padding: 8px; font-weight: bold;border-bottom: 1px solid #cccccc'>{#ip_ipv4_title_extra#}</td>
      		  </tr>
        		<tr>
        		  <td align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold'>{#ip_gateway#}</td>
        		  <td align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold;'>{#ip_netmask#}</td>
        		  <td align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold;'>{#ip_ns#}</td>
      		    </tr>
        		<tr>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px'>{$gway}</td>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px;'>{$netmask}</td>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px;'>{$ns}</td>
      		    </tr>
            
         
</table>

</td>
            </tr>
	
          </table>
         
         
         
         
         
         
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
               </table>
          {else}
     
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td style="border:1px solid #cccccc">
          <table width="100%" border="0"  bgcolor="#E9E9E9" cellspacing="1" cellpadding="2">
        		<tr>
        		  <td colspan="2" align="center" bgcolor="#E6E6E6" style='padding: 8px; font-weight: bold;border-bottom: 1px solid #cccccc'>{#ip_ipv4_title#}</td>
      		  </tr>
        		<tr>
        		  <td align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold'>{#ip_table_ip#}</td>
        		  <td width="50%" align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold;'>{#ip_table_rdns#}</td>
      		    </tr>
        		<tr>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px; font-weight: bold;'><span style="color:orange"><strong>{$mainipaddress}</strong></span></td>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px; font-weight: bold;'>{if $rdns}<a href="rdns.php?id={$vmid}&ip={$mainipid}">{$rdns}</a>{else}<a href="rdns.php?id={$vmid}&ip={$mainipid}">[{#ip_rdns_button#}]</a>{/if}</td>
      		    </tr>
            
            
                 {if $aips}
                 
  {foreach item=item from=$iplist}
 
 <tr>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px;'>{$item.ipaddress}</td>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 4px; font-weight: bold;'>{if $item.rdns}<a href="rdns.php?id={$vmid}&ip={$item.ipaddressid}">{$item.rdns}</a>{else}<a href="rdns.php?id={$vmid}&ip={$item.ipaddressid}">[{#ip_rdns_button#}]</a>{/if}</td>
      		    </tr> 
  {/foreach}
</table>
{/if}
</td>
            </tr>
	
          </table>
          </td></tr></table>
          {/if}
               {if $iplist6}
                <br />
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td style="border:1px solid #cccccc">
          <table width="100%" border="0"  bgcolor="#E9E9E9" cellspacing="1" cellpadding="2">
        		<form action="" method="post"  onsubmit="confirm_ip();return false;">
                <tr>
                  <td colspan="4" align="center" bgcolor="#E6E6E6" style='padding: 8px; font-weight: bold;border-bottom: 1px solid #cccccc'>{#ip_ipv6_title#}</td>
      		  </tr>
        		<tr>
        		  <td width="41%" align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold'>{#ip_table_ip#}</td>
        		  <td width="45%" align="left" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold;'>{#ip_table_rdns#}</td>
        		  <td width="2%" align="center" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold;'>{#ip_table_enabled#}</td>
        		  <td width="2%" align="center" bgcolor="#EEEEEE" style='padding: 5px; font-weight: bold;'><input type="checkbox" name="checkall" onclick="checkUncheckAll(this);"/></td>
      		    </tr>
                 {if $aips6}
                 
  {foreach item=item6 from=$iplist6}
 
 <tr>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 1px 1px 1px 4px;'>{$item6.ipaddress}</td>
        		  <td align="left" bgcolor="#FFFFFF" style='padding: 1px 1px 1px 4px;; font-weight: bold;'>{if $item6.rdns}<a href="rdns6.php?id={$vmid}&ip={$item6.ipaddressid}">{$item6.rdns}</a>{else}<a href="rdns6.php?id={$vmid}&ip={$item6.ipaddressid}">[{#ip_rdns_button#}]</a>{/if}</td>
        		  <td align="center" bgcolor="#FFFFFF" style='padding: 1px 1px 1px 4px;; font-weight: bold;'>{if $item6.inet6active == 1}<img src="../{$templatedirectory}/{$template}/images/tick.png" alt="Yes" width="16" height="16"/>{else}<img src="../{$templatedirectory}/{$template}/images/cross.png" alt="No" width="16" height="16"/>{/if}</td>
        		  <td align="center" bgcolor="#FFFFFF" style='padding: 1px 1px 1px 4px;; font-weight: bold;'><input name="checkbox[]" type="checkbox" value="{$item6.ipaddress}"/></td>
   		      </tr> 
  {/foreach}
<tr><td colspan="4" align="right" valign="top" >&nbsp;<input name="enable" type="submit" class="button" id="enable" value="Enable" />&nbsp;&nbsp;<input name="disable" type="submit" class="button" id="disable" value="Disable" /></td></tr>
</form>
</table>
{/if}
{/if}
</td>
            </tr>
	
          </table>
          </td></tr></table>
          </td></tr>
      
 </table>
 {include file=$footer}