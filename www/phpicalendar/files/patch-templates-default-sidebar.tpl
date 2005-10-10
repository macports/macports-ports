--- templates/default/sidebar.tpl	2004-05-19 05:45:09.000000000 +0200
+++ templates/default/sidebar.tpl	2005-10-10 11:04:15.000000000 +0200
@@ -22,6 +22,13 @@
 		<td bgcolor="#FFFFFF" align="left" valign="middle"><div style="padding-left: 5px; padding-bottom: 5px;">{L_PASSWORD}:</div></td>
 		<td bgcolor="#FFFFFF" align="right" valign="middle"><div style="padding-right: 5px; padding-bottom: 5px;"><input type="password" name="password" size="10" /></div></td>
 	</tr>
+	<tr> 
+		<td bgcolor="#FFFFFF" align="center" valign="middle" colspan="2"> 
+			<div style="padding-left: 5px; padding-bottom: 5px;"> 
+				<input type="submit" value="&nbsp;&nbsp;&nbsp;Login&nbsp;&nbsp;&nbsp;"> 
+			</div> 
+		</td> 
+	</tr> 
 </table>
 </form>
 <table width="100%" border="0" cellpadding="0" cellspacing="0">
