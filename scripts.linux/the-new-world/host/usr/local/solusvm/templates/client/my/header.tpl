{config_load file="/usr/local/solusvm/language/client/`$smarty.session.lang`.txt"}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<noscript>
<meta http-equiv="refresh" content="0;URL=javascript.html" />
</noscript>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="{$templatedirectory}/{$template}/style.css" media="screen"/>
<script type="text/javascript" src="{$templatedirectory}/{$template}/js/core.js"></script>
<script type="text/javascript" src="{$templatedirectory}/{$template}/js/functions.js"></script>
<title>Host4ge - Control Panel {$page}</title>
</head>
<body {if $loggedin == 'true'}style="background: #FFF url(../{$templatedirectory}/{$template}/images/bg_1.png) repeat-x;"{else}style="background: #DDD"{/if}>

<div id="wrapper">
{if $loggedin == 'true'}
<table class="header" border="0" cellspacing="0" cellpadding="0">


        </table>
    </tr>
      <tr>
        <td height="90" colspan="2" valign="bottom" class="tabs" >

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td  height="92" align="left">{if $loggedin == 'true'}<img src="../{$templatedirectory}/{$template}/images/logo.png" alt="VPS CONTROL PANEL"class="png_bg" width="358" height="53"  />{/if}</td>
    <td  height="92" align="right" valign="top"  style="padding: 0px 20px 0 20px">{if $loggedin == 'true'}<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="99%" style="padding: 10px 0px 0 15px" align="right"><img src="../{$templatedirectory}/{$template}/images/logout.gif" alt="{#side_menu_myaccount_logout#}" width="10" height="10"/></td>
    <td width="1%" style="padding: 10px 0px 0 4px" align="right"><a href="{$navXlogout}"><span style="color:#ffffff; text-decoration: none">{#side_menu_myaccount_logout#}</span></a></td>
  </tr>
</table>{/if}
</td>
  </tr>
</table>
<table width="100%"class="toptabs" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="22" align="left" valign="top" class="links" style="padding: 0 20px 0 15px";>{if $loggedin == 'true'}{#top_bar_header_left#} <strong>{$fname} {$lname}</strong>{/if}</td>
    <td align="right" valign="top" class="links" style="padding: 0 20px 0 20px";>{#top_bar_header_right#} <strong>{$uip}</strong></td>
    </tr>
</table></td>
      </tr>
    </table>
    {/if}
<table class="container" border="0" cellspacing="0" cellpadding="0">
  <tr>
    {if $loggedin == 'true'}
    <td width="15%" rowspan="3" valign="top" class="sidebar">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>

          <td>
         <div class="sidemenu">
        <h3>{#side_menu_myaccount_header#}</h3>
        <table width="210" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td  width="32" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc;padding:5px 0 5px 5px"><img src="../{$templatedirectory}/{$template}/images/home_32.png" alt="Home" width="32" height="32" class="png_bg" /> </td>
    <td  align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0"><a href="{$navXhome}">{#side_menu_myaccount_home#}</a></td>
  </tr>
  <tr>
    <td  width="32" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px"><img src="../{$templatedirectory}/{$template}/images/user_32.png" alt="Profile" width="32" height="32" class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"  style="border-bottom: 1px solid #cccccc;  padding:5px 0 5px 0"><a href="{$navXprofile}">{#side_menu_myaccount_profile#}</a></td>
  </tr>
  <tr>
    <td width="32" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/home_go_32.png" alt="Logout" width="32" height="32" class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXlogout}">{#side_menu_myaccount_logout#}</a></td>
  </tr>
</table>
<br />

<h3>{#side_menu_vlist_header#}</h3>
        <table width="210" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc;padding:8px 0 5px 5px"><select name="qvm" style="width:95%" id="qvm" ONCHANGE="location = this.options[this.selectedIndex].value;">
    <form name="qvm" action="" method="post">
    <option value="">Select...</option>
                     {foreach item=qvm from=$qvmlist} <option value="control.php?id={$qvm.vserverid}">{$qvm.hostname}</option>{/foreach}
                     </form>
                 </select> </td>
    </tr>
</table>
{if !$vmanage}
<br />
 <h3>{#side_menu_myaccount_stats#}</h3>
        <table width="210" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td  width="32" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc;padding:5px 0 5px 5px"><img src="../{$templatedirectory}/{$template}/images/lastlogin.png" alt="Lastlogin" width="32" height="32" class="png_bg" /> </td>
    <td  align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0"><a href="#">{#side_menu_stats_lastlogin#}</a><br /><span style="line-height:23px">{$llogin}</span></td>
  </tr>
  <tr>
    <td  width="32" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px"><img src="../{$templatedirectory}/{$template}/images/vps.png" alt="VPS" width="32" height="32" class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"  style="border-bottom: 1px solid #cccccc;  padding:5px 0 5px 0"><a href="#">{#side_menu_stats_vps#}<span style="color:#000000"> {$vpsc}</span></a></td>
  </tr>
</table>
<br />
{/if}
    {if $vmanage}
    <br />
     <h3>{#side_menu_myaccount_title#}</h3>
        <table width="210" border="0" cellspacing="0" cellpadding="0">
        <tr>
    <td colspan="2" align="center" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc;padding:5px 5px 5px 5px">  <table width="100%" border="0" style="border:1px solid #e9e9e9" cellspacing="0" cellpadding="0">
  <tr>
 <td width="41%" align="right" bgcolor="#FFFFE6" style="padding:3px; color: #7FA0DE">
    {#side_menu_myaccount_status#}:</td>
    <td width="59%" align="left" bgcolor="#FFFFE6" style="padding:3px"><span style="color:{$statuscolor}; font-weight:bold ">{$status}</span></td>
  </tr>
  <tr>
    <td width="41%" align="right" bgcolor="#FFFFE6" style="padding:3px; color: #7FA0DE">
    {#side_menu_myaccount_ip#}:</td>
    <td width="59%" align="left" bgcolor="#FFFFE6" style="padding:3px">{$mainipaddress}</td>
  </tr>
</table></td>
    </tr>
    <tr>
    <td  width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc;padding:5px 0 5px 5px"><img src="../{$templatedirectory}/{$template}/images/icons/m_home_small.png"  width="16" height="16" alt="home"class="png_bg" /> </td>
    <td width="320"  align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0"><a href="{$navXmaincontrol}">Main View</a></td>
  </tr>
  <tr>
    <td  width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc;padding:5px 0 5px 5px"><img src="../{$templatedirectory}/{$template}/images/icons/m_reboot_small.png"  width="16" height="16" alt="reboot"class="png_bg" /> </td>
    <td width="320"  align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0"><a href="{$navXreboot}">{#control_button_01#}</a></td>
  </tr>
  <tr>
    <td  width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px"><img src="../{$templatedirectory}/{$template}/images/icons/m_shutdown_small.png"  width="16" height="16" alt="shutdown" class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"  style="border-bottom: 1px solid #cccccc;  padding:5px 0 5px 0"><a href="{$navXshutdown}">{#control_button_02#}</a></td>
  </tr>
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_boot_small.png"  width="16" height="16" alt="boot"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXboot}">{#control_button_03#}</a></td>
  </tr>
  {if $vt =="xenhvm"}
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_reinstall_small.png"  width="16" height="16" alt="reinstall"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="hvmreinstall.php?id={$vmid}">{#control_button_04#}</a></td>
  </tr>
  {/if}
  {if $vt =="xen" || $vt =="openvz"}
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_reinstall_small.png"  width="16" height="16" alt="reinstall"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXreinstall}">{#control_button_04#}</a></td>
  </tr>
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_rootpassword_small.png"  width="16" height="16" alt="rootpassword"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXrootpassword}">{#control_button_05#}</a></td>
  </tr>
  <tr>
  {/if}
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_hostname_small.png"  width="16" height="16" alt="hostname"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXhostname}">{#control_button_06#}</a></td>
  </tr>
  <tr>
   {if $vt =="xen" || $vt =="openvz"}
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_console_small.png"  width="16" height="16" alt="console"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXconsole}">{#control_button_07#}</a></td>
  </tr>
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_consolesettings_small.png" width="16" height="16" alt="consolesettings"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXconsolesettings}">{#control_button_12#}</a></td>
  </tr>
  {/if}
   <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_apisettings_small.png" width="16" height="16" alt="apisettings"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXapisettings}">{#control_button_45#}</a></td>
  </tr>
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_ipaddresses_small.png"  width="16" height="16" alt="ipaddresses"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXipaddresses}">{#control_button_09#}</a></td>
  </tr>
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_mainip_small.png"  width="16" height="16" alt="mainip"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXmainip}">{#control_button_15#}</a></td>
  </tr>
 <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_qbackup_small.png"  width="16" height="16" alt="quickbackup"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$qbl}">{#control_button_08#}</a></td>
  </tr>
  <tr>
   <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_cbackup_small.png"  width="16" height="16" alt="centralbackup"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$cbs}">{#control_button_18#}</a></td>
  </tr>
   <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_statistics_small.png"  width="16" height="16" alt="statistics"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXstatistics}">{#control_button_11#}</a></td>
  </tr>
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_log_small.png"  width="16" height="16" alt="log"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="{$navXsystemlog}">{#control_button_10#}</a></td>
  </tr>
  {if $reseller}
                {if $suspended}
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_unsuspend_small.png"  width="16" height="16" alt="unsuspend"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="unsuspend.php?id={$vmid}">{#control_button_13#}</a></td>
  </tr>
  {else}
  <tr>
    <td width="21" align="left" bgcolor="#FBFBFB" style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 5px" ><img src="../{$templatedirectory}/{$template}/images/icons/m_suspend_small.png"  width="16" height="16" alt="suspend"class="png_bg" /></td>
    <td align="left" bgcolor="#FBFBFB"style="border-bottom: 1px solid #cccccc; padding:5px 0 5px 0" ><a href="suspend.php?id={$vmid}">{#control_button_14#}</a></td>
  </tr>
  {/if}
  {/if}
</table>
<br />
  {/if}
  </div></td></tr></table>


  </td>
  {/if}
    <td width="85%" class="main" valign="top">

