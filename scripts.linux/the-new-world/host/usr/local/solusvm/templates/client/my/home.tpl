{include file=$header}
{literal}
<script type="text/javascript">  
       $(document).ready(function() {  
       $("#striped tr:odd").addClass("oddRow");  
       $("#striped tr:even").addClass("evenRow");  
    }); 
    
   function BandwidthBar(width, percent, color, percentb, background) 
  { 
    var pixels = width * (percentb / 100); 
    if (!background) { background = "white"; }
 
    document.write("<div style=\"position: relative; line-height: 1em; background-color: " 

                   + background + "; border: 1px solid black; width: " 
                   + width + "px\">"); 
    document.write("<div style=\"height: 13px; width: " + pixels + "px; background-color: "
                   + color + ";\"></div>"); 
    document.write("<div style=\"position: absolute; text-align: center; padding-top: 1px; width: " 
                   + width + "px; top: 0; left: 0\">" + percent + "%</div>"); 

    document.write("</div>"); 
  } 
</script>
{/literal}

<table class="content" style="padding-top: 10px" border="0" cellspacing="0" cellpadding="0">
<tr><td>
  {if $boxtitle}   <table style="border: solid  #F4C22A 3px; background-color: #FFF8BF; padding: 10px 10px 10px 10px" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h2><span style='font-size: 15px;'>{$boxtitle}</span></h2></td>
    </tr>
  <tr>
    <td> <span style='font-size: 13px;'>{$boxtext}</span></td>
    </tr>
    </table>
</td>
  </tr>
</table>
<br />
{/if}
 <table id="striped" width="100%" border="0" bgcolor="#ffffff" cellspacing="1" cellpadding="2">
                <thead>
                <tr>
                  <td height="16" colspan="10" align="center" valign="middle" bgcolor="#D9E9F9" style='border: 1px solid #B6D5F3; padding: 10px 5px 10px 5px; color:#333333; font-size: 15px;'><strong>{#virtual_server_list_title#}</strong></td> 
                  </tr>
                </thead>
               <thead>
                <tr>
                  <td width="1%" height="16" align="center" valign="middle" bgcolor="#F3F3F3" style='padding: 2px; color:#333; border-bottom:1px solid #cccccc'>&nbsp;</td> 
                 
                  <th align="center" bgcolor="#F3F3F3" style='padding: 2px 8px 2px 8px; color:#333; border-bottom:1px solid #cccccc'>{#virtual_server_list_type#}</th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#virtual_server_list_hostname#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#virtual_server_list_ip#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#virtual_server_list_mem#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#virtual_server_list_burst#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#virtual_server_list_os#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#virtual_server_list_node#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#virtual_server_list_bandwidth#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'>&nbsp;</th>
                </tr>
                </thead> 
                {if $vserverlist}
                 {foreach item=item from=$vservers}                   			
			 <tr>
                  <td  width="1%" align="center" style='padding: 5px; border-bottom:1px solid #cccccc'>
               {$item.wstatus}</td>
                  <td  width="1%" align="center" style='padding: 8px; border-bottom:1px solid #cccccc'>{if $item.type == "xen"}<img src="../{$templatedirectory}/{$template}/images/xen.gif" />{elseif $item.type == "xenhvm"}<img src="../{$templatedirectory}/{$template}/images/xen.gif" />{elseif $item.type == "kvm"}<img src="../{$templatedirectory}/{$template}/images/kvm.png" />{else}<img src="../{$templatedirectory}/{$template}/images/vz.gif" />{/if}</td>
               <td align="left"  style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'><a href="control.php?id={$item.vserverid}">{$item.hostname}</a></td>
                  <td align="left" style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'>{$item.mainipaddress}</td>
                  <td align="left" style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'>{$item.ram}</td>
                  <td align="left" style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'>{if $item.type == "xenhvm" || $item.type == "kvm"}-{else}{$item.burst}{/if}</td>
                  <td align="left" style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'>{$item.template}</td>
               <td align="left" style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'>{$item.node}</td>
                  <td width="1%" align="left" style='padding: 8px; color: #4d4d4d; border-bottom:1px solid #cccccc; font-size:9px'><script language="javascript">BandwidthBar(80, {$item.bwp}, '{$item.bwpc}', {$item.bwpp}); </script></td>
               <td width="1%" align="center" style='padding: 8px; border-bottom:1px solid #cccccc'><a href="control.php?id={$item.vserverid}"><img src="../{$templatedirectory}/{$template}/images/manage.gif" border="0" alt="Manage" /></a></td>
            </tr>			 
                {/foreach}
		{else}
        <tr>
			  <td colspan="10" align="center" bgcolor="#FFFFFF" style='padding: 3px;'><strong>{#virtual_server_list_no#}</strong></td>
            </tr>					
			{/if}			
               
      </table>
</td></tr>
  <tr>
    <td>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><table width="100%" border="0" cellspacing="0" cellpadding="3">
      <tr>
    <td></td>
  </tr>
</table>

</td>
  </tr>
</table>
{include file=$footer}