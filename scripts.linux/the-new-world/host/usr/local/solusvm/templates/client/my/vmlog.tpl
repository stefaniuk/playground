{include file=$header}
{include file=$overview}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#log_title#}</h4></td>
        </tr>
        <tr>
        <td>
        <table width="100%" border="0"  bgcolor="#CCCCCC" cellspacing="1" cellpadding="2">
                <tr>
                  <td align="left" bgcolor="#4F4F4F" style='padding: 5px; color:#fff'><strong>{#log_date#}</strong></td>
                  <td align="left" bgcolor="#4F4F4F" style='padding: 5px; color:#fff'><strong>{#log_action#}</strong></td>
                  <td align="left" bgcolor="#4F4F4F" style='padding: 5px; color:#fff'><strong>{#log_request#}</strong></td>
                  <td align="left" bgcolor="#4F4F4F" style='padding: 5px; color:#fff'><strong>{#log_status#}</strong></td>
                </tr>
                {if $logs}
                 {foreach item=item from=$logdata}                      			
			 <tr>
                  <td align="left" bgcolor="#FFFFFF" style='padding: 3px;'>{$item.date|date_format:"%d/%m/%Y %I:%M %p"}</td>
                  <td align="left" bgcolor="#FFFFFF" style='padding: 3px;'>{$item.action}</td>
                  <td align="left" bgcolor="#FFFFFF" style='padding: 3px;'>{$item.requestipaddress}</td>
                  <td align="left" bgcolor="#FFFFFF" style='padding: 3px;'>{$item.status}</td>
            </tr>			 
                {/foreach}
		{else}
        <tr>
			  <td colspan="4" align="center" bgcolor="#FFFFFF" style='padding: 3px;'><strong>{#log_no#}</strong></td>
            </tr>					
			{/if}			
               
          </table>
      </td></tr>
        <tr><td>
        <div class="pagination">{$pagination}</div>
        </td></tr>
 </table>
   
 {include file=$footer}