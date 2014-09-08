{include file=$header}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"></td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25" colspan="2" style="padding:0px"><h4>Add Virtual Server</h4></td>
        </tr><tr>
    <td align="left">{$msg}</td>
  </tr>
       
      
      <tr>
        <td colspan="2" style='padding-top: 0px;'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td style="border:1px solid #cccccc">    
        <table width="100%" border="0"  bgcolor="#ebebeb" cellspacing="1" cellpadding="2">
                
                   <tr>
                     <td  align="center" bgcolor="#efefef" style='padding: 5px;'><table width="680" border="0">
                       <tr>
                         <td align="center"><a href="createvzvm.php"><img src="../{$templatedirectory}/{$template}/openvz-linux.png" width="209" height="100" border="0" alt="OpenVZ" /></a></td>
                         <td align="center"><a href="createxenvm.php"><img src="../{$templatedirectory}/{$template}xen-parra.png" width="209" height="100" border="0" alt="Xen Paravirtualization" /></a></td>
                         <td align="center"><a href="createhvmxenvm.php"><img src="../{$templatedirectory}/{$template}/xen-hvm.png" width="209" height="100" border="0" alt="Xen HVM-ISO" /></a></td>
                       </tr>
                     </table></td>
            </tr>
	
          </table>
          </td></tr></table>
          <br />
          <table width="100%" border="0"  bgcolor="#ffffff" cellspacing="1" cellpadding="2">
               
                                  			
          </table>
          </td></tr></table></td>
      </tr>
      </table>
 {include file=$footer}