--- src/gtk/mdi.cpp	Thu Oct  7 09:52:11 2004
+++ mdi.cpp	Thu Nov 11 12:10:05 2004
@@ -170,17 +170,19 @@
 
         /* need to set the menubar of the child */
         wxMDIChildFrame *active_child_frame = GetActiveChild();
-        wxMenuBar *menu_bar = active_child_frame->m_menuBar;
-        if (menu_bar)
+        if (active_child_frame != NULL)
         {
-            menu_bar->m_width = m_width;
-            menu_bar->m_height = wxMENU_HEIGHT;
-            gtk_pizza_set_size( GTK_PIZZA(m_mainWidget),
-                                menu_bar->m_widget,
-                                0, 0, m_width, wxMENU_HEIGHT );
-            menu_bar->SetInvokingWindow(active_child_frame);
+            wxMenuBar *menu_bar = active_child_frame->m_menuBar;
+            if (menu_bar)
+            {
+                menu_bar->m_width = m_width;
+                menu_bar->m_height = wxMENU_HEIGHT;
+                gtk_pizza_set_size( GTK_PIZZA(m_mainWidget),
+                                    menu_bar->m_widget,
+                                    0, 0, m_width, wxMENU_HEIGHT );
+                menu_bar->SetInvokingWindow(active_child_frame);
+            }
         }
-
         m_justInserted = false;
         return;
     }
