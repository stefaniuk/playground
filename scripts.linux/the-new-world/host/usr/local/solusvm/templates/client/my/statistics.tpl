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
    document.write("<div style=\"height: 13px; width: " + pixels + "px; background-color: "
                   + color + ";\"></div>"); 
    document.write("<div style=\"position: absolute; text-align: center; padding-top: 1px; width: " 
                   + width + "px; top: 0; left: 0\">" + percent + "%</div>"); 

    document.write("</div>"); 
  } 
</script>
{/literal}
{include file=$overview}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td style="width: 131px">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><table width="100%" border="0" cellspacing="0" cellpadding="3">
      <tr>
    <td align="center">{$msg}</td>
  </tr>
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:3px"><h4>{#statistics_title#}</h4></td>
        </tr>
      <tr>
        <td>
        
            
    <table style="width: 100%">
		<tr>
			<td><table width="95%" border="0" style="margin:20px" cellspacing="0" cellpadding="3">
  
  <tr>
    <td><select name="si" id="si" ONCHANGE="getstats(this.options[this.selectedIndex].value);">
    <option value="3600">1 Hour</option>
    <option value="7200">2 Hours</option>
<option value="14400">4 Hours</option>
<option value="21600">6 Hours</option>
<option value="28800">8 Hours</option>
<option value="43200">12 Hours</option>
<option value="86400">1 Day</option>
<option value="172800">2 Days</option>
<option value="259200">3 Days</option>
<option value="345600">4 Days</option>
<option value="432000">5 Days</option>
<option value="518400">6 Days</option>
<option value="604800">1 Week</option>
<option value="1209600">2 Weeks</option>
<option value="1814400">3 Weeks</option>
<option value="2678400">1 Month</option>
<option value="5356800">2 Months</option>
<option value="8035200">3 Months</option>
<option value="10713600">4 Months</option>
<option value="13392000">5 Months</option>
<option value="16070400">6 Months</option>
<option value="18748800">7 Months</option>
<option value="21427200">8 Months</option>
<option value="24105600">9 Months</option>
<option value="26784000">10 Months</option>
<option value="29462400">11 Months</option>
<option value="31536000">1 Year</option>
</select>    </td></td>
      </tr>
  
  <tr>
    <td>          {literal}
<script type="text/javascript">  

									$(document).ready(function(){

  $('#lhostmemory').html('<img style="padding: 20px" src="../{/literal}{$templatedirectory}/{$template}{literal}/images/l-o-a-d.gif" width="16" height="16"/>');
  $('#lhostmemory').load("client_call_return_graph.php?action=vps&_v={/literal}{$vpsid}{literal}");
});

function getstats(id){
var randn=Math.floor(Math.random()*11)
$('#lhostmemory').html('<img style="padding: 20px" src="../{/literal}{$templatedirectory}/{$template}{literal}/images/l-o-a-d.gif" width="16" height="16"/>');
  $('#lhostmemory').load("client_call_return_graph.php?action=vps&_v={/literal}{$vpsid}{literal}&_g="+id+"&_r="+randn);

}
</script>	
{/literal}
<div id="lhostmemory"><img style="padding: 20px" src="../{$templatedirectory}/{$template}/images/l-o-a-d.gif" width="16" height="16"/></div>
</td>
      </tr>
</table>
</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table></td>
        </tr>
      <tr>
        <td><div class="pagination"></div></td>
      </tr>
    </table>
 {include file=$footer}