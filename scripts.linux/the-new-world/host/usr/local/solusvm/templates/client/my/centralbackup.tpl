{include file=$header}
{literal}
<script type="text/javascript">  
       $(document).ready(function() {  
       $("#striped tr:odd").addClass("oddRow");  
       $("#striped tr:even").addClass("evenRow");  
    }); 
	   
	   function confirm_restore() 
{  
if (confirm('All data currently on the virtual server will be destroyed\nAre you sure you want to continue?')){submit(); } 

}

function confirm_delete() 
{  
if (confirm('Backup will be deleted\nAre you sure you want to continue?')){submit(); } 

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
    {if $msg == "02"}
    <div id='infoboxerror'><strong>{#centralbackup_msg_error#}</strong><br>{#centralbackup_msg_02#}</div>
    {elseif $msg == "03"}
    <div id='infoboxok'><strong>{#centralbackup_msg_success#}</strong><br>{#centralbackup_msg_03#}</div>
    {elseif $msg == "01"}
    <div id='infoboxerror'><strong>{#centralbackup_msg_error#}</strong><br>{#centralbackup_msg_01#}</div>
    {elseif $msg == "04"}
    <div id='infoboxok'><strong>{#centralbackup_restore_msg_success#}</strong><br>{#centralbackup_msg_04#}</div>
    {elseif $msg == "05"}
    <div id='infoboxerror'><strong>{#centralbackup_msg_error#}</strong><br>{#centralbackup_msg_05#}</div>
    {elseif $msg == "06"}
    <div id='infoboxerror'><strong>{#centralbackup_msg_error#}</strong><br>{#centralbackup_msg_06#}</div>
    {elseif $msg == "07"}
    <div id='infoboxerror'><strong>{#centralbackup_msg_error#}</strong><br>{#centralbackup_msg_07#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#centralbackup_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">
          {#centralbackup_title_sub_sub#}</td>
        </tr>       
        <tr>
          <td><br />
        <table id="striped" width="100%" border="0" bgcolor="#ffffff" cellspacing="1" cellpadding="2">
                <thead>
                <tr>
                  <td height="16" colspan="6" align="center" valign="middle" bgcolor="#D9E9F9" style='border: 1px solid #B6D5F3; padding: 10px 5px 10px 5px; color:#333333; font-size: 15px;'><strong>{#centralbackup_table_header#}&nbsp;&nbsp;{$usedbackupcredits}/{$totalbackupcredits}</strong></td> 
                  </tr>
                </thead>
               <thead>
                <tr>
                 
                 
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 8px 2px 8px; color:#333; border-bottom:1px solid #cccccc'>{#centralbackup_list_date#}</th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#centralbackup_list_filename#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#centralbackup_list_node#}</strong></th>
                  <th align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>{#centralbackup_list_status#}</strong></th>  
                  <th colspan="2" align="left" bgcolor="#F3F3F3" style='padding: 2px 2px 2px 8px; color:#333; border-bottom:1px solid #cccccc'><strong>&nbsp;</strong></th>
                 </tr>
                </thead> 
                {if $backuplist}
                 {foreach item=item from=$backups}                   			
			 <tr>               
                  <td  align="left" style='padding: 8px; border-bottom:1px solid #cccccc'>{$item.date}</td>
               <td align="left"  style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'>{$item.filename}</td>
                  <td align="left" style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'>{$item.node}</td>
                  <td align="left" style='padding: 8px;color: #4d4d4d; border-bottom:1px solid #cccccc'>{$item.status}</td>
                  <form id="{$item.id}" method="post" action="" onsubmit="confirm_restore();return false;">
                  <input name="restoreid" type="hidden" value="{$item.id}" />
                  <td width="1%" align="left" style='padding: 8px; color: #4d4d4d; border-bottom:1px solid #cccccc; font-size:9px'>
                    <input type="submit" name="restore" class="buttontable" id="restore" value="{#centralbackup_button_3#}" {$item.hide} />
                </td>
                </form>
               <form id="{$item.id}" method="post" action="" onsubmit="confirm_delete();return false;">
                  <input name="deleteid" type="hidden" value="{$item.id}" />
               <td width="1%" align="center" style='padding: 8px; border-bottom:1px solid #cccccc'><input type="submit" name="delete" class="buttontable" id="delete" value="{#centralbackup_button_2#}" {$item.hided} /></td>
               </form>
            </tr>			 
                {/foreach}
		{else}
        <tr>
			  <td colspan="11" align="center" bgcolor="#FFFFFF" style='padding: 3px;'><strong>{#centralbackup_list_no#}</strong></td>
            </tr>					
			{/if}			
               
      </table>
        </td></tr>
      <tr><form action="" method="post">
        <td  style="padding:3px"><input type="submit" name="create" class="button" id="create" value="{#centralbackup_button_1#}" /></td>
        </form>
      </tr>
    </table>
 {include file=$footer}