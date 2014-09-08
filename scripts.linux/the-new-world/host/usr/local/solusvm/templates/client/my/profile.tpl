{include file=$header}
<table class="content" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><table width="100%" border="0" cellspacing="0" cellpadding="3">
</table>
</td>
  </tr>
</table>
<table class="services" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="25px" style="padding:8px 3px 3px 3px"><h4>{#profile_title#}</h4></td>
        </tr>
      <tr>
        <td  style="padding:3px; border: 0px solid #cccccc"><table width="100%" border="0" cellspacing="0" cellpadding="2">
         <form id="" method="post" action="">
                <tr>
                  <td width="100%" align="left" valign="top" bgcolor="#E2E2E2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="52%" valign="top" bgcolor="#F8F8F8" style="padding:10px"><strong>{#profile_personal#}</strong><br />{#profile_personal_sub#}</td>
                      <td width="48%" valign="top" bgcolor="#F8F8F8" style="padding:10px">
                      {foreach item=personalmsg from=$personaldata} 
                      {$personalmsg}
                      {/foreach}
                        <table width="100%" border="0" cellspacing="5" cellpadding="5">
                        <tr>
                          <td width="32%" align="right">{#profile_personal_fname#}:</td>
                          <td width="68%"><input name="fname" type="text" class="formfield" id="fname" value="{$fname}" /></td>
                          </tr>
                        <tr>
                          <td align="right">{#profile_personal_lname#}:</td>
                          <td><input type="text" class="formfield" name="lname" id="lname" value="{$lname}" /></td>
                          </tr>
                        <tr>
                          <td align="right">{#profile_personal_company#}:</td>
                          <td><input type="text" class="formfield" name="company" id="company" value="{$company}" /></td>
                          </tr>
                        <tr>
                          <td align="right">&nbsp;</td>
                          <td align="right"><input type="submit" class="button" name="personalupdate" id="personalupdate" value="{#profile_update_button#}" /></td>
                          </tr>
                        </table></td>
                      </tr>
                    <tr>
                      <td colspan="2" valign="top" bgcolor="#F8F8F8"><hr /></td>
                      </tr>
                    <tr>
                      <td width="52%" valign="top" bgcolor="#F8F8F8" style="padding:10px"><strong>{#profile_email#}</strong><br />
                        {#profile_email_sub#}</td>
                      <td width="48%" valign="top" bgcolor="#F8F8F8" style="padding:10px">
                     {foreach item=emailmsg from=$emaildata} 
                      {$emailmsg}
                      {/foreach}
                        <table width="100%" border="0" cellspacing="5" cellpadding="5">
                        <tr>
                          <td width="32%" align="right">{#profile_email_email#}:</td>
                          <td width="68%"><input type="text" class="formfield" name="eaddress" id="eaddress" value="{$emailaddress}" /></td>
                          </tr>
                          <tr>
                          <td width="32%" align="right">{#profile_email_notification#}:</td>
                          <td width="68%"><input name="lnotification" type="checkbox" class="formfield" id="lnotification" {if $lny}checked="checked"{/if} /></td>
                          </tr>
                        <tr>
                          <td align="right">&nbsp;</td>
                          <td align="right"><input type="submit" class ="button" name="emailupdate" id="emailupdate" value="{#profile_update_button#}" /></td>
                          </tr>
                        </table></td>
                      </tr>
                    <tr>
                      <td colspan="2" valign="top" bgcolor="#F8F8F8"><hr /></td>
                      </tr>
                    <tr>
                      <td width="52%" valign="top" bgcolor="#F8F8F8" style="padding:10px"><p><strong>{#profile_password#}</strong><br />
                        {#profile_password_sub#}</td>
                      <td width="48%" valign="top" bgcolor="#F8F8F8" style="padding:10px">
                      {foreach item=passmsg from=$passdata} 
                      {$passmsg}
                      {/foreach}
                      <table width="100%" border="0" cellspacing="5" cellpadding="5">
                        <tr>
                          <td width="32%" align="right">{#profile_password_cpassword#}:</td>
                          <td width="68%"><input type="password" class="formfield" name="cpassword" id="cpassword" /></td>
                          </tr>
                        <tr>
                          <td align="right">{#profile_password_npassword#}:</td>
                          <td><input type="password" class="formfield" name="npassword" id="npassword" /></td>
                          </tr>
                        <tr>
                          <td align="right">{#profile_password_rnpassword#}:</td>
                          <td><input type="password" class="formfield" name="rnpassword" id="rnpassword" /></td>
                          </tr>
                        <tr>
                          <td>&nbsp;</td>
                          <td align="right"><input type="submit" class="button" name="passwdupdate" id="passwdupdate" value="{#profile_update_button#}" /></td>
                          </tr>
                        </table></td>
                      </tr>
                  </table></td>
                </tr>
                
              </table></td>
        </tr>
       
      <tr>
      
        <td  style="padding:10px 3px 3px 3px">&nbsp;</td>
      </tr>
      <tr>
        <td  style="padding:3px">&nbsp;</td>
      </tr></form> 
    </table>
   
 {include file=$footer}