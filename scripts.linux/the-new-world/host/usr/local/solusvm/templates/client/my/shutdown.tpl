{include file=$header}
{literal}
<script type="text/javascript">

  function BandwidthBar(width, percent, color, background) 
  { 
    var pixels = width * (percent / 100); 
    if (!background) { background = "none"; }
 
    document.write("<div style=\"position: relative; line-height: 1em; background-color: " 

                   + background + "; border: 1px solid black; width: " 
                   + width + "px\">"); 
    document.write("<div style=\"height: 1.5em; width: " + pixels + "px; background-color: "
                   + color + ";\"></div>"); 
    document.write("<div style=\"position: absolute; text-align: center; padding-top: .25em; width: " 
                   + width + "px; top: 0; left: 0\">" + percent + "%</div>"); 

    document.write("</div>"); 
  } 
   function HDDBar(width, percent, color, background) 
  { 
    var pixels = width * (percent / 100); 
    if (!background) { background = "none"; }
 
    document.write("<div style=\"position: relative; line-height: 1em; background-color: " 

                   + background + "; border: 1px solid black; width: " 
                   + width + "px\">"); 
    document.write("<div style=\"height: 1.5em; width: " + pixels + "px; background-color: "
                   + color + ";\"></div>"); 
    document.write("<div style=\"position: absolute; text-align: center; padding-top: .25em; width: " 
                   + width + "px; top: 0; left: 0\">" + percent + "%</div>"); 

    document.write("</div>"); 
  } 
  function MemoryBar(width, percent, color, background) 
  { 
    var pixels = width * (percent / 100); 
    if (!background) { background = "none"; }
 
    document.write("<div style=\"position: relative; line-height: 1em; background-color: " 

                   + background + "; border: 1px solid black; width: " 
                   + width + "px\">"); 
    document.write("<div style=\"height: 1.5em; width: " + pixels + "px; background-color: "
                   + color + ";\"></div>"); 
    document.write("<div style=\"position: absolute; text-align: center; padding-top: .25em; width: " 
                   + width + "px; top: 0; left: 0\">" + percent + "%</div>"); 

    document.write("</div>"); 
  } 
 

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
    <div id='infoboxok'><strong>{#shutdown_msg_success#}</strong><br>{#shutdown_msg_01#}</div>
    {elseif $msg == "02"}
    <div id='infoboxerror'><strong>{#shutdown_msg_error#}</strong><br>{#shutdown_msg_02#}</div>
    {elseif $msg == "04"}
    <div id='infoboxerror'><strong>{#shutdown_msg_error#}</strong><br>{#generic_msg_01#}</div>
    {/if}
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#shutdown_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px">{#shutdown_title_sub#}</td>
        </tr>
      <tr>
        <td  style="padding:3px"><form id="" method="post" action="">
          <input type="submit" name="shutdown" class="button" id="shutdown" value="{#shutdown_button#}" />
        </form></td>
      </tr>
    </table>
 {include file=$footer}