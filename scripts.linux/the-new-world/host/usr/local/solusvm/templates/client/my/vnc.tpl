{include file=$header}
{include file=$overview}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25" style="padding:3px"><h4>VNC</h4></td>
        </tr>
        <tr>
        <td height="13" colspan="2" align="center" style="padding:30px"><input type="button" class="button" name="" id="" value="Refresh" onClick="window.location='vnc.php?id={$vmidd}'"/></td>
      </tr>
        <tr>
          <td><table width="100%" border="0">
  <tr>
    <td width="11%" align="right">Connection IP:</td>
    <td width="89%">{$consoleip}</td>
  </tr>
  <tr>
    <td align="right">Connection Port:</td>
    <td>{$consoleport}</td>
  </tr>
  <tr>
    <td align="right">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</td>
        </tr>
        <tr>
          <td  style='padding-top: 30px;'><p align="center">
            <APPLET CODE="VncViewer.class" ARCHIVE="/java/vnc/VncViewer.jar">
            <PARAM NAME="Open new window" VALUE=Yes>
            <PARAM NAME="Scaling factor" VALUE=auto>
<PARAM NAME="PORT" VALUE="{$consoleport}">
<PARAM NAME="HOST" VALUE="{$consoleip}">
<PARAM NAME="PASSWORD" VALUE="{$consolepassword}">This  browser need Java plugins to run Java applets <applet></applet>
</APPLET>
      </p></td></tr>  
 </table>
{include file=$footer}