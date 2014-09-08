{include file=$header}
{literal}
<script type="text/javascript">
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
   function HDDBar(width, percent, color, percentb, background) 
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
  function MemoryBar(width, percent, color ,percentb, background) 
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
<table class="content" border="0" cellspacing="0" cellpadding="0">
<tr><td>
 {if $dmsg == "01"}
    <div id='infoboxerror'><strong>{#control_msg_suspended#}</strong><br>{#control_msg_01#}</div>
    {elseif $dmsg == "02"}
    <div id='infoboxerror'><strong>{#control_msg_suspended#}</strong><br>{#control_msg_02#}</div>
    {elseif $dmsg == "03"}
<div id='infoboxerror'><strong>{#control_msg_suspended#}</strong><br>{#control_msg_03#}</div>
{elseif $dmsg == "04"}
<div id='infoboxerror'><strong>{#control_msg_suspended#}</strong><br>{#control_msg_02#}</div>
{/if}
{if $msg == "01"}
    <div id='infoboxok'><strong>{#control_hvm_msg_success#}</strong><br>{#control_hvm_msg_01#}</div>
    {elseif $msg == "02"}
   <div id='infoboxok'><strong>{#control_hvm_msg_success#}</strong><br>{#control_hvm_msg_02#}</div>
    {elseif $msg == "03"}
    <div id='infoboxok'><strong>{#control_hvm_msg_success#}</strong><br>{#control_hvm_msg_03#}</div>
    {elseif $msg == "04"}
    <div id='infoboxok'><strong>{#control_hvm_msg_success#}</strong><br>{#control_hvm_msg_04#}</div>
    {elseif $msg == "05"}
    <div id='infoboxok'><strong>{#control_hvm_msg_success#}</strong><br>{#control_hvm_msg_05#}</div>
    {elseif $msg == "06"}
    <div id='infoboxok'><strong>{#control_hvm_msg_success#}</strong><br>{#control_hvm_msg_06#}</div>
    {elseif $msg == "07"}
    <div id='infoboxok'><strong>{#control_hvm_msg_success#}</strong><br>{#control_hvm_msg_07#}</div>
    {/if}
</td></tr>
  <tr>
    <td valign="top">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><table width="100%" style="border: 1px solid #b8c1d0; margin:12px 0 0px 0" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="40%" align="left" valign="top" style="padding:15px">
    <table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td width="33%" class="vservertable" align="right">{#control_stats_01#}:</td>
    <td width="67%">{$hostname}</td>
  </tr>
  <tr>
    <td class="vservertable" align="right">{#control_stats_02#}:</td>
    <td>{$mainipaddress}</td>
  </tr>
  <tr>
    <td class="vservertable" align="right">{#control_stats_03#}:</td>
    <td>{$ostemplate}</td>
  </tr>
  <tr>
    <td class="vservertable" align="right">{#control_stats_04#}:</td>
    <td>{$nodecity}, {$nodecountry}</td>
  </tr>
  <tr>
    <td class="vservertable" align="right">{#control_stats_05#}:</td>
    <td><span style="color:{$statuscolor}; font-weight:bold ">{$status}</span></td>
  </tr>
</table></td>
    <td width="0%" align="left" valign="middle"><table width="1" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="100" width="1" bgcolor="#CCCCCC"></td>
  </tr>
</table>
</td>
    <td width="34%" align="left" style="padding:15px" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  {if $vt == "xen" || $vt == "openvz"}
  <tr>
    <td width="30%" class="vservertable" align="right">{#control_stats_06#}:</td>
    <td width="70%" class="bar" style="padding:0 0 0 3px;"><script language="javascript">HDDBar(250, {$percenthdd}, '{$percenthddc}', {$percenthddb}); </script></td>
  </tr>
  <tr>
    <td class="vservertable" align="right">&nbsp;</td>
    <td width="70%" align="left" class="bardata" style="padding:0 0 0 3px;">{$usedhdd} {#control_stats_12#} {$totalhdd} {#control_stats_13#} / {$freehdd} {#control_stats_14#}</td>
  </tr>
  <tr>
    <td class="vservertable" style="padding:6px 0 0 3px;" align="right">{#control_stats_07#}:</td>
    <td class="bar" style="padding:6px 0 0 3px;"><script language="javascript">MemoryBar(250, {$percentmem}, '{$percentmemc}', {$percentmemb}); </script></td>
  </tr>
  <tr>
    <td class="vservertable" align="right">&nbsp;</td>
    <td class="bardata" style="padding:0 0 0 3px;">{if $vt == "xen"}n/a{else}{$usedmem} {#control_stats_12#} {$totalmem} {#control_stats_13#} / {$freemem} {#control_stats_14#}{/if}</td>
  </tr>
  {/if}
  <tr>
    <td class="vservertable" align="right" style="padding:6px 0 0 3px;">{#control_stats_08#}:</td>
    <td class="bar"style="padding:6px 0 0 3px;" ><script language="javascript">BandwidthBar(250, {$percentbw}, '{$percentbwc}', {$percentbwb}); </script></td>
  </tr>
  <tr>
    <td class="vservertable" align="right">&nbsp;</td>
    <td class="bardata" style="padding:0 0 0 3px;">{$usedbw} {#control_stats_12#} {$totalbw} {#control_stats_13#} / {$freebw} {#control_stats_14#}</td>
  </tr>
    </table></td>
    <td width="0%" align="left" valign="middle"><table width="1" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="100" width="1" bgcolor="#CCCCCC"></td>
  </tr>
</table></td>
    <td width="26%" style="padding:15px" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="3">
 
  <tr>
    <td class="vservertable" width="56%" align="right">{if $vt == "xen"}<span class="vservertable" style="padding:6px 0 0 3px;">{#control_stats_07#}</span>:{else}<span class="vservertable" style="padding:6px 0 0 3px;">{#control_stats_09#}</span>:{/if}</td>
    <td width="44%">{$memory}</td>
  </tr>
   {if $vt == "xen" || $vt == "openvz"}
  <tr>
    <td class="vservertable" align="right">{if $vt == "xen"}<span class="vservertable" style="padding:6px 0 0 3px;">{#control_stats_10#}</span>:{else}<span class="vservertable" style="padding:6px 0 0 3px;">{#control_stats_11#}</span>:{/if}</td>
    <td>{$burst}</td>
  </tr>
  {/if}
  <tr>
    <td class="vservertable" align="right"><span class="vservertable" style="padding:6px 0 0 3px;">{#control_stats_06#}</span>:</td>
    <td>{$disk}</td>
  </tr>
  <tr>
    <td class="vservertable" align="right"><span class="vservertable" style="padding:6px 0 0 3px;">{#control_stats_08#}</span>:</td>
    <td>{$bandwidth}</td>
  </tr>
</table></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td></td>
  </tr>
</table>

</td>
  </tr>
</table><br />
 {if $vt == "xenhvm" || $vt == "kvm"}
 <fieldset>
  <legend>{#control_title_hvm#}</legend>
  <table width="100%" border="0">
    <tr>
      <td width="42%" valign="top"><table width="100%" border="0">
    <tr>
      <td width="35%" style="padding:3px" align="right"><strong>{#control_hvm_apic#}:</strong></td>
      <form action="" method="post">
      <td width="65%"style="padding:3px" >{if $apic}<span style="color:#0C0"><strong>ON</strong></span></strong>&nbsp;&nbsp;&nbsp;<input name="apic" type="submit" class="bn" value="Off" />{else}<span style="color:#F00"><strong>OFF</strong></span></strong>&nbsp;&nbsp;&nbsp;<input name="apic" type="submit" class="bn" value="On" />{/if}</td>
    </form>
    </tr>
    <tr>
     <form action="" method="post">
      <td align="right" style="padding:3px"><strong>{#control_hvm_acpi#}:</strong></td>
      <td style="padding:3px">{if $acpi}<span style="color:#0C0"><strong>ON</strong></span></strong>&nbsp;&nbsp;&nbsp;<input name="acpi" type="submit" class="bn" value="Off" />{else}<span style="color:#F00"><strong>OFF</strong></span></strong>&nbsp;&nbsp;&nbsp;<input name="acpi" type="submit" class="bn" value="On" />{/if}</td>
    </form>
    </tr>
    <tr>
      <form action="" method="post">
      <td align="right" style="padding:3px"><strong>{#control_hvm_vnc#}:</strong></td>
      <td style="padding:3px">{if $vnc}<span style="color:#0C0"><strong>ON</strong></span></strong>&nbsp;&nbsp;&nbsp;<input name="vnc" type="submit" class="bn" value="Off" />{else}<span style="color:#F00"><strong>OFF</strong></span></strong>&nbsp;&nbsp;&nbsp;<input name="vnc" type="submit" class="bn" value="On" />{/if}</td>
    </form>
    </tr>
     <tr>
      <form action="" method="post">
      <td align="right" style="padding:3px"><strong>{#control_hvm_pae#}:</strong></td>
      <td style="padding:3px">{if $pae}<span style="color:#0C0"><strong>ON</strong></span></strong>&nbsp;&nbsp;&nbsp;<input name="pae" type="submit" class="bn" value="Off" />{else}<span style="color:#F00"><strong>OFF</strong></span></strong>&nbsp;&nbsp;&nbsp;<input name="pae" type="submit" class="bn" value="On" />{/if}</td>
    </form>
    </tr>
    <tr>
      
      <td align="right" style="padding:3px"><strong>{#control_hvm_boot#}:</strong></td>
      <form action="" method="post">
        <td style="padding:3px" ><select class="ffield" name="bootorder" id="bootorder">
          <option value="cd" {if $boot == "cd"}selected="selected"{/if}>(1) Hard Disk (2) CDROM</option>
          <option value="dc" {if $boot == "dc"}selected="selected"{/if}>(1) CDROM (2) Hard Disk</option>
          <option value="c" {if $boot == "c"}selected="selected"{/if}>Hard Disk Only</option>
          <option value="d" {if $boot == "d"}selected="selected"{/if}>CDROM Only</option>
          </select>
          <input name="border" type="submit" class="bn" value="Set" /></td>
      </form>
    </tr>
  </table></td>
      <td width="58%">
      {if $nocd != 1}
      <table width="100%" border="0">
    <tr>
      <td width="23%" rowspan="2" align="right" valign="top" style="padding:3px"><img src="../{$templatedirectory}/{$template}/images/icons/cdrom.png" alt="cdrom" /></td>
    
      <td width="77%" align="left" valign="middle" style="padding:3px">
                <strong>{#control_hvm_cdrom#}:</strong>        
              </td>
                      
    <tr>
      <form action="" method="post">
        <td width="77%" align="left" valign="middle" style="padding:3px">{if $cdrom == "none"}<span style="color: #CA6500">{#control_hvm_empty#}</span><br />
          
          {#control_hvm_mount#}:&nbsp;<select name="vmos" class="ffield" id="vmos">
                            
                   {foreach item=t from=$templatelist} 
                            <option value="{$t.filename}">{$t.friendlyname}</option>
                            {/foreach}
                  
                          </select>
          <input name="mount" type="submit" class="bn" value="Mount" />
          {else}
          {$cdrom}&nbsp;&nbsp;&nbsp;<input name="unmount" type="submit" class="bn" value="Unmount" />
          {/if}</td>
      </form>
    </tr>
      </table>
      {/if}
      </td>
    </tr>
  </table>
 </fieldset>
<br />
{/if}
<fieldset>
  <legend>{#control_title_01#}</legend>
<table class="services" border="0" cellspacing="0" cellpadding="0">      
      <tr>
      <tr><td>
      <br />
      <ul class="shortcut-buttons-set">
				
				<li><a class="shortcut-button" href="{$navXreboot}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_reboot.png" alt="{#control_button_01#}" /><br />
					{#control_button_01#}
				</span></a></li>
				
				<li><a class="shortcut-button" href="{$navXshutdown}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_shutdown.png" alt="{#control_button_02#}" /><br />
					{#control_button_02#}
				</span></a></li>
				
				<li><a class="shortcut-button" href="{$navXboot}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_boot.png" alt="{#control_button_03#}" /><br />
					{#control_button_03#}
				</span></a></li>
              {if $vt == "kvm"}
                <li><a class="shortcut-button" href="poweroff.php?id={$vmid}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_hard_off.png" alt="{#control_button_51#}" /><br />
					{#control_button_51#}
				</span></a></li>
                {/if}
			</ul>
      </td></tr>
        <td  style="padding:3px"></td>
        </tr>
    </table>
    </fieldset>
<br />
 
    <fieldset>
  <legend>{#control_title_02#}</legend>
  <br />
    <table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td  style="padding:3px">
          
      
      <ul class="shortcut-buttons-set">
				
				{if $vt == "xenhvm"}
                <li><a class="shortcut-button" href="hvmreinstall.php?id={$vmid}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_reinstall.png" alt="{#control_button_04#}" /><br />
					{#control_button_04#}
				</span></a></li>
{/if}
				{if $vt == "xen" || $vt == "openvz"}
                <li><a class="shortcut-button" href="{$navXreinstall}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_reinstall.png" alt="{#control_button_04#}" /><br />
					{#control_button_04#}
				</span></a></li>
				
				<li><a class="shortcut-button" href="{$navXrootpassword}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_rootpassword.png" alt="{#control_button_05#}" /><br />
					{#control_button_05#}
				</span></a></li>
				{/if}
				<li><a class="shortcut-button" href="{$navXhostname}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_hostname.png" alt="{#control_button_06#}" /><br />
					{#control_button_06#}
				</span></a></li>
                {if $vt == "xenhvm" || $vt == "kvm"}
                <li><a class="shortcut-button" href="{$navXvnc}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_console.png" alt="{#control_button_16#}" /><br />
					{#control_button_16#}
				</span></a></li>
                <li><a class="shortcut-button" href="{$navXvncpassword}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_consolesettings.png" alt="{#control_button_17#}" /><br />
					{#control_button_17#}
				</span></a></li>
                {else}
                <li><a class="shortcut-button" href="{$navXconsole}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_console.png" alt="{#control_button_07#}" /><br />
					{#control_button_07#}
				</span></a></li>
                <li><a class="shortcut-button" href="{$navXconsolesettings}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_consolesettings.png" alt="{#control_button_12#}" /><br />
					{#control_button_12#}
				</span></a></li>
                {/if}
                 <li><a class="shortcut-button" href="{$navXapisettings}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_apisettings.png" alt="{#control_button_45#}" /><br />
					{#control_button_45#}
				</span></a></li>
			</ul>
   </td>
        </tr>
    </table>
    </fieldset>
    <br />   
    <fieldset>
  <legend>{#control_title_04#}</legend>
  <br />
    <table class="services" border="0" cellspacing="0" cellpadding="0">      
      <tr>
        <td  style="padding:3px">
        <ul class="shortcut-buttons-set">
				
			<li><a class="shortcut-button" href="{$navXmainip}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_mainip.png" alt="{#control_button_15#}" /><br />
					{#control_button_15#}
				</span></a></li>
            <li><a class="shortcut-button" href="{$navXipaddresses}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_ip.png" alt="{#control_button_09#}" /><br />
					{#control_button_09#}
				</span></a></li>
				
			<li><a class="shortcut-button" href="{$navXsystemlog}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_log.png" alt="{#control_button_10#}" /><br />
					{#control_button_10#}
				</span></a></li>
				
			<li><a class="shortcut-button" href="{$navXstatistics}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_statistics.png" alt="{#control_button_11#}" /><br />
					{#control_button_11#}
				</span></a></li>
		  </ul></td>
        </tr>
    </table>
</fieldset>
<br />
 <fieldset style="height:147px">
  <legend>{#control_title_03#}</legend>
  <br />
    <table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td  style="padding:3px">
        
         <ul class="shortcut-buttons-set">
				
			<li><a class="shortcut-button" href="{$qbl}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_backup.png" alt="{#control_button_08#}" /><br />
					{#control_button_08#}
				</span></a></li>
                <li><a class="shortcut-button" href="{$cbs}"><span>
					<img src="../{$templatedirectory}/{$template}/images/icons/m_cbackup.png" alt="{#control_button_18#}" /><br />
					{#control_button_18#}
				</span></a></li>
		  </ul></td>
      </tr>
    </table>
    </fieldset>
{include file=$footer}