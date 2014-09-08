{include file=$header}
{literal}
<script type="text/javascript">
	$(document).ready(function lastMessage() {

$('#lastmessage').html('<img src="../templates/default/images/loader.gif" width="16" height="16" />&nbsp; loading...');	
$("#lastmessage").load('status.php?randval='+ Math.random());	

});
 
 $(document).ready(function(){ 
    $('div.toggler-c').toggleElements( 
        { fxAnimation:'slide', fxSpeed:'slow', className:'toggler' } );  
}); 

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
    <div id='infoboxok'><strong>{#rootpassword_msg_success#}</strong><br>{#rootpassword_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxok'><strong>{#rootpassword_msg_success#}</strong><br>{#rootpassword_msg_02#}</div>
    {elseif $msg == "03"}
    <div id='infoboxerror'><strong>{#rootpassword_msg_error#}</strong><br>{#generic_msg_01#}</div>
    {elseif $msg == "04"}
    <div id='infoboxerror'><strong>{#rootpassword_msg_error#}</strong><br>{#rootpassword_msg_03#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#rootpassword_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#rootpassword_title_sub#}</td>
        </tr>
      <tr>
      <form id="" method="post" action="">
        <td  style="padding:10px 3px 3px 3px"><input type="text" class="formfield" name="newrootpassword" id="newrootpassword" /></td>
      </tr>
      <tr>
        <td  style="padding:3px"><input type="submit" name="rootpassword" class="button" id="rootpassword" value="{#rootpassword_button#}" />
                      
                  </td>
      </form> </tr>
    </table>
   
 {include file=$footer}