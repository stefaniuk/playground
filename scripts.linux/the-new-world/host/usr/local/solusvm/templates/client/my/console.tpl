{include file=$header}
{include file=$overview}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25" colspan="2" style="padding:3px"><h4>{#console_title#}</h4></td>
        </tr>
        <tr>
        <td colspan="2">{#console_title_sub#}</td></tr>
        <tr>
          <td colspan="2"></td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" align="left"><p><strong>{#console_username#}:&nbsp;</strong>{$consoleusername}<br />
          <strong>{#console_password#}:&nbsp;</strong>&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;
          <br />
          <strong>{#console_ip#}:&nbsp;</strong>{$consoleip}
          <br />
          <strong>{#console_port#}:&nbsp;</strong>{$consoleport}</td>
          </td>
        </tr>
        <tr>
          <td colspan="2"  style='padding-top: 30px;'><p align="center">
            <applet width="640" height="480" archive="SSHTermApplet-signed.jar,SSHTermApplet-jdkbug-workaround-signed.jar,SSHTermApplet-jdk1.3.1-dependencies-signed.jar" code="com.sshtools.sshterm.SshTermApplet" codebase="/java/sshterm-applet/" style="border:2px solid #d0d5e4; padding-left: 0; padding-right: 0; padding-top: 0; padding-bottom: 0">
              <param name=sshapps.connection.host value={$consoleip} />
              <param name=sshapps.connection.port value={$consoleport} />
              <param name=sshapps.connection.userName value={$consoleusername} />
              <param name=sshapps.connection.showConnectionDialog value=false />
              <param name=sshapps.connection.authenticationMethod value=password />
              <param name=sshapps.connection.connectImmediately value=true />
            </applet>
      </p></td></tr>  
 </table>
{include file=$footer}