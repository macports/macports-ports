--- plugins/rubyide_fox_gui/appframe.rb	Fri Dec  3 16:24:02 2004
+++ ../freeride-0.9.2-patched/plugins/rubyide_fox_gui/appframe.rb	Fri Dec 17 17:52:36 2004
@@ -1,235 +1,278 @@
-# Purpose: Setup and initialize the core gui interfaces
-#
-# $Id: appframe.rb,v 1.8 2004/12/03 21:24:02 ljulliar Exp $
-#
-# Authors:  Curt Hibbs <curt@hibbs.com>
-# Contributors:
-#
-# This file is part of the FreeRIDE project
-#
-# This application is free software; you can redistribute it and/or
-# modify it under the terms of the Ruby license defined in the
-# COPYING file.
-#
-# Copyright (c) 2001 Curt Hibbs. All rights reserved.
-#
-
-require 'fox12'
-require 'fox12/colors'
-require 'rubyide_fox_gui/fxscintilla/scintilla'
-
-
-module FreeRIDE
-  module FoxRenderer
-
-    ##
-    # This is the module that renders application-frames using
-    # FOX.
-    #
-    class AppFrame
-      
-      extend FreeBASE::StandardPlugin
-      
-      
-      
-      def AppFrame.start(plugin)
-        component_slot = plugin["/system/ui/components/AppFrame"]
-        
-        component_slot.subscribe do |event, slot|
-          if (event == :notify_slot_add && slot.parent == component_slot)
-            Renderer.new(plugin, slot)
-          end
-        end
-        
-        component_slot.each_slot { |slot| slot.notify(:notify_slot_add) }
-        
-        plugin.transition(FreeBASE::RUNNING)
-      end
-      
-      ##
-      # Each instance of this class is responsible for rendering an application-frame component
-      #
-      class Renderer < Fox::FXMainWindow
-        include Fox
-        attr_reader :plugin
-        def initialize(plugin, slot)
-          @plugin = plugin
-          @slot = slot
-
-          @command = @slot["/system/ui/commands"]
-          @plugin.log_info << "AppFrame started"
-          @app = FXApp.new("FreeRIDE", "FreeRIDE")
-          @app.init(ARGV)
-
-          # use the FR mini icon for the main window
-          mi_path = "#{plugin.plugin_configuration.full_base_path}/icons/bullseye.ico"
-          mi = Fox::FXICOIcon.new(@app, File.open(mi_path, "rb").read)
-          super(@app, @slot.data, mi, mi, DECOR_ALL)
-          FXToolTip.new(@app, TOOLTIP_NORMAL)
-          
-          appFrameSetup
-          
-          connect(SEL_CLOSE) { @plugin["/system/ui/commands"].manager.command("App/Services/Shutdown").invoke }
-          @plugin["/system/state/all_plugins_loaded"].subscribe do |event, slot|
-            self.recalc
-            self.forceRefresh
-          end
-        end
-        
-        def create
-          super
-          x = @plugin.properties["Location/X"]
-          y = @plugin.properties["Location/Y"]
-          width = @plugin.properties["Location/Width"]
-          height = @plugin.properties["Location/Height"]
-          x ||= 1
-          y ||= 1
-          width ||= 800
-          height ||= 600
-
-          position(x,y,width,height)
-          if x==1
-            show(PLACEMENT_SCREEN)
-          else
-            show
-          end
-        end
-        
-        def appFrameSetup
-          
-          @menubar = FXMenuBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
-          FXHorizontalSeparator.new(self, LAYOUT_SIDE_TOP|SEPARATOR_GROOVE|LAYOUT_FILL_X);
-          @toolbar = FXToolBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X,0, 0, 0, 0, 4, 4, 0, 0, 0, 0)
-          @statusbar = FXStatusBar.new(self, LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X|STATUSBAR_WITH_DRAGCORNER)
-          
-          # Vertical splitter svFrame contains the south dock bar at the
-          # bottom and a horizontal splitter in the upper part which itself
-          # contains the East Dock bar, the Scintilla widget and the West
-          # dock bar.
-          @svFrame = FXSplitter.new(self, LAYOUT_FILL_X|LAYOUT_FILL_Y|
-                                    SPLITTER_TRACKING|SPLITTER_VERTICAL|SPLITTER_REVERSED)
-          @shFrame = FXSplitter.new(@svFrame, LAYOUT_FILL_X|LAYOUT_FILL_Y|
-                                    SPLITTER_TRACKING|SPLITTER_HORIZONTAL)
-          
-          @dockbar_west = FXVerticalFrame.new(@shFrame, FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
-          @dockbar_west.width = 0
-          @dockbar_west.padRight = 0
-          @dockbar_west.padTop = 0
-          @dockbar_west.padLeft = 0
-          @dockbar_west.padBottom = 0
-          
-          # Scintilla widget is in the middle
-          @contentFrame = FXHorizontalFrame.new(@shFrame, FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
-          @contentFrame.width = self.width - 30
-          @contentFrame.padRight = 0
-          @contentFrame.padTop = 0
-          @contentFrame.padLeft = 0
-          @contentFrame.padBottom = 0
-          
-          # dockbar south at the bottom of the vertical frame
-          @dockbar_south = FXHorizontalFrame.new(@svFrame, FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
-          @dockbar_south.padRight = 0
-          @dockbar_south.padTop = 0
-          @dockbar_south.padLeft = 0
-          @dockbar_south.padBottom = 0
-          @dockbar_south.height = 0
-          
-          @plugin["/system/ui/fox/FXApp"].data = @app
-          @plugin["/system/ui/fox/FXMainWindow"].data = self
-          @plugin["/system/ui/fox/FXMenuBar"].data = @menubar
-          @plugin["/system/ui/fox/FXToolBar"].data = @toolbar
-          @plugin["/system/ui/fox/FXStatusBar"].data = @statusbar
-          @plugin["/system/ui/fox/contentFrame"].data = @contentFrame
-          @plugin["/system/ui/fox/dockbar/west/frame"].data = @dockbar_west
-          @plugin["/system/ui/fox/dockbar/west/textAngle"].data = -90
-          @plugin["/system/ui/fox/dockbar/south/frame"].data = @dockbar_south
-          @plugin["/system/ui/fox/dockbar/south/textAngle"].data = 0
-          @plugin.log_info << "Dockbar UI components positioned OK!"
-          
-          @app.create
-          @running = true
-          
-          @plugin["/system/ui/messagepump"].set_proc do
-            begin
-              @app.run
-            rescue
-	      exc_box = FreerideExceptionBox.new(self,"#{$!.class}: #{$!.message}\n\n#{$@.join("\n")}")
-	      if exc_box.execute == MBOX_CLICKED_YES
-                @plugin['/system/ui/components/EditPane'].each_slot {|ep| ep.manager.save}
-              end
-              # raise the exception again for the text console
-              raise 
-            ensure
-              @running = false
-              @plugin["/system/shutdown"].call(1)
-            end
-          end
-        end
-        
-        def shutdown
-          @plugin.properties["Location/Width"] = self.width
-          @plugin.properties["Location/Height"] = self.height
-          @plugin.properties["Location/X"] = self.x
-          @plugin.properties["Location/Y"] = self.y
-          @app.handle(self, Fox.MKUINT(Fox::FXApp::ID_QUIT, Fox::SEL_COMMAND), nil)
-        end
-        
-      end
-
-
-      class FreerideExceptionBox < Fox::FXDialogBox
-
-        include Fox
-	include Responder
-
-	HORZ_PAD = 30
-	VERT_PAD =  2
-
-        def initialize(owner,text)
-
-          FXMAPFUNC(SEL_COMMAND, ID_CANCEL,   :onCmdClickedNo)
-          FXMAPFUNC(SEL_COMMAND, ID_ACCEPT,  :onCmdClickedYes)
-
-          # Invoke base class initialize function first
-          super(owner, "FreeRIDE went south...", DECOR_TITLE|DECOR_BORDER|DECOR_CLOSE|DECOR_RESIZE)
-          self.width = 580
-          self.height = 430
-          self.padLeft = 0
-          self.padRight = 0
-
-          content = FXVerticalFrame.new(self,LAYOUT_FILL_X|LAYOUT_FILL_Y)
-          #info = FXHorizontalFrame.new(content,LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X|LAYOUT_FILL_Y,0,0,0,0,10,10,10,10);
-          #FXLabel.new(info,nil,ic,ICON_BEFORE_TEXT|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X|LAYOUT_FILL_Y)
-          FXLabel.new(content,"Unhandled Exception Caught:",nil,JUSTIFY_LEFT|ICON_BEFORE_TEXT|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X)
-	  text_area = FXText.new(content,nil,0,JUSTIFY_LEFT|TEXT_READONLY|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X|LAYOUT_FILL_Y)
-	  text_area.text = text
-
-          FXLabel.new(content,"Please report the bug to http://rubyforge.org/tracker/?group_id=31\n\nWould you like to save modified files now?",nil,JUSTIFY_LEFT|ICON_BEFORE_TEXT|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X)
-
-          FXHorizontalSeparator.new(content,SEPARATOR_GROOVE|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X)
-
-          buttons = FXHorizontalFrame.new(content,LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH,0,0,0,0,10,10,10,10)
-          initial = FXButton.new(buttons,"&Yes",nil,self,ID_ACCEPT,BUTTON_INITIAL|BUTTON_DEFAULT|FRAME_RAISED|FRAME_THICK|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_CENTER_X,0,0,0,0,HORZ_PAD,HORZ_PAD,VERT_PAD,VERT_PAD)
-          FXButton.new(buttons,"&No",nil,self,ID_CANCEL,BUTTON_DEFAULT|FRAME_RAISED|FRAME_THICK|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_CENTER_X,0,0,0,0,HORZ_PAD,HORZ_PAD,VERT_PAD,VERT_PAD)
-          initial.setFocus
-        end
-
-
-        def onCmdClickedYes(sender, sel, ptr)
-          getApp.stopModal(self,MBOX_CLICKED_YES)
-          hide
-          return 1
-        end
-
-        def onCmdClickedNo(sender, sel, ptr)
-          getApp.stopModal(self,MBOX_CLICKED_NO)
-          hide
-          return 1
-        end
-
-      end
-    end
-
-  end
-end
-
+# Purpose: Setup and initialize the core gui interfaces
+#
+# $Id: appframe.rb,v 1.8 2004/12/03 21:24:02 ljulliar Exp $
+#
+# Authors:  Curt Hibbs <curt@hibbs.com>
+# Contributors:
+#
+# This file is part of the FreeRIDE project
+#
+# This application is free software; you can redistribute it and/or
+# modify it under the terms of the Ruby license defined in the
+# COPYING file.
+#
+# Copyright (c) 2001 Curt Hibbs. All rights reserved.
+#
+
+require 'fox12'
+require 'fox12/colors'
+require 'rubyide_fox_gui/fxscintilla/scintilla'
+
+
+module FreeRIDE
+  module FoxRenderer
+
+    ##
+    # This is the module that renders application-frames using
+    # FOX.
+    #
+    class AppFrame
+      
+      extend FreeBASE::StandardPlugin
+      
+      
+      
+      def AppFrame.start(plugin)
+        component_slot = plugin["/system/ui/components/AppFrame"]
+        
+        component_slot.subscribe do |event, slot|
+          if (event == :notify_slot_add && slot.parent == component_slot)
+# BGB - START
+# was:
+#            Renderer.new(plugin, slot)
+# now:    PLEASE NOTE - this is taken from appFrameSetup below but see internal comments
+            app = Fox::FXApp.new("FreeRIDE", "FreeRIDE")
+# BGB - PLEASE NOTE where the app was created below there was also the following line.  Is it required?
+#            app.init(ARGV)
+            r = Renderer.new(plugin, slot, app)
+            app.create
+# BGB - PLEASE NOTE - this is taken from appFrameSetup below but has a couple of changes (see internal comments)
+            plugin["/system/ui/messagepump"].set_proc do
+              begin
+                r.show  # BGB - new line
+                app.run
+              rescue
+                exc_box = FreerideExceptionBox.new(r,"#{$!.class}: #{$!.message}\n\n#{$@.join("\n")}")
+                if exc_box.execute == MBOX_CLICKED_YES
+                  plugin['/system/ui/components/EditPane'].each_slot {|ep| ep.manager.save}
+                end
+                # raise the exception again for the text console
+                raise 
+              ensure
+# BGB - commented out following line.  What use is this running field in Renderer anyway?
+#                r.running = false
+                plugin["/system/shutdown"].call(1)
+              end
+            end
+          end
+        end
+# BGB - END
+        
+        component_slot.each_slot { |slot| slot.notify(:notify_slot_add) }
+        
+        plugin.transition(FreeBASE::RUNNING)
+      end
+      
+      ##
+      # Each instance of this class is responsible for rendering an application-frame component
+      #
+      class Renderer < Fox::FXMainWindow
+        include Fox
+        attr_reader :plugin
+# BGB - START
+# was:
+#        def initialize(plugin, slot)
+#          @plugin = plugin
+#          @slot = slot
+# now:
+        def initialize(plugin, slot, app)
+          @plugin = plugin
+          @slot = slot
+		  @app = app
+# BGB - END
+          @command = @slot["/system/ui/commands"]
+          @plugin.log_info << "AppFrame started"
+# BGB - START
+# was:
+#          @app = FXApp.new("FreeRIDE", "FreeRIDE")
+#          @app.init(ARGV)
+# now:
+# BGB - END
+
+          # use the FR mini icon for the main window
+          mi_path = "#{plugin.plugin_configuration.full_base_path}/icons/bullseye.ico"
+          mi = Fox::FXICOIcon.new(@app, File.open(mi_path, "rb").read)
+          super(@app, @slot.data, mi, mi, DECOR_ALL)
+          FXToolTip.new(@app, TOOLTIP_NORMAL)
+          
+          appFrameSetup
+          
+          connect(SEL_CLOSE) { @plugin["/system/ui/commands"].manager.command("App/Services/Shutdown").invoke }
+          @plugin["/system/state/all_plugins_loaded"].subscribe do |event, slot|
+            self.recalc
+            self.forceRefresh
+          end
+        end
+        
+        def create
+          super
+          x = @plugin.properties["Location/X"]
+          y = @plugin.properties["Location/Y"]
+          width = @plugin.properties["Location/Width"]
+          height = @plugin.properties["Location/Height"]
+          x ||= 1
+          y ||= 1
+          width ||= 800
+          height ||= 600
+
+          position(x,y,width,height)
+          if x==1
+            show(PLACEMENT_SCREEN)
+          else
+            show
+          end
+        end
+        
+        def appFrameSetup
+          
+          @menubar = FXMenuBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
+          FXHorizontalSeparator.new(self, LAYOUT_SIDE_TOP|SEPARATOR_GROOVE|LAYOUT_FILL_X);
+          @toolbar = FXToolBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X,0, 0, 0, 0, 4, 4, 0, 0, 0, 0)
+          @statusbar = FXStatusBar.new(self, LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X|STATUSBAR_WITH_DRAGCORNER)
+          
+          # Vertical splitter svFrame contains the south dock bar at the
+          # bottom and a horizontal splitter in the upper part which itself
+          # contains the East Dock bar, the Scintilla widget and the West
+          # dock bar.
+          @svFrame = FXSplitter.new(self, LAYOUT_FILL_X|LAYOUT_FILL_Y|
+                                    SPLITTER_TRACKING|SPLITTER_VERTICAL|SPLITTER_REVERSED)
+          @shFrame = FXSplitter.new(@svFrame, LAYOUT_FILL_X|LAYOUT_FILL_Y|
+                                    SPLITTER_TRACKING|SPLITTER_HORIZONTAL)
+          
+          @dockbar_west = FXVerticalFrame.new(@shFrame, FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
+          @dockbar_west.width = 0
+          @dockbar_west.padRight = 0
+          @dockbar_west.padTop = 0
+          @dockbar_west.padLeft = 0
+          @dockbar_west.padBottom = 0
+          
+          # Scintilla widget is in the middle
+          @contentFrame = FXHorizontalFrame.new(@shFrame, FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
+          @contentFrame.width = self.width - 30
+          @contentFrame.padRight = 0
+          @contentFrame.padTop = 0
+          @contentFrame.padLeft = 0
+          @contentFrame.padBottom = 0
+          
+          # dockbar south at the bottom of the vertical frame
+          @dockbar_south = FXHorizontalFrame.new(@svFrame, FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
+          @dockbar_south.padRight = 0
+          @dockbar_south.padTop = 0
+          @dockbar_south.padLeft = 0
+          @dockbar_south.padBottom = 0
+          @dockbar_south.height = 0
+          
+          @plugin["/system/ui/fox/FXApp"].data = @app
+          @plugin["/system/ui/fox/FXMainWindow"].data = self
+          @plugin["/system/ui/fox/FXMenuBar"].data = @menubar
+          @plugin["/system/ui/fox/FXToolBar"].data = @toolbar
+          @plugin["/system/ui/fox/FXStatusBar"].data = @statusbar
+          @plugin["/system/ui/fox/contentFrame"].data = @contentFrame
+          @plugin["/system/ui/fox/dockbar/west/frame"].data = @dockbar_west
+          @plugin["/system/ui/fox/dockbar/west/textAngle"].data = -90
+          @plugin["/system/ui/fox/dockbar/south/frame"].data = @dockbar_south
+          @plugin["/system/ui/fox/dockbar/south/textAngle"].data = 0
+          @plugin.log_info << "Dockbar UI components positioned OK!"
+          
+          @app.create
+          @running = true
+          
+# BGB - START
+# was:
+#          @plugin["/system/ui/messagepump"].set_proc do
+#            begin
+#              @app.run
+#            rescue
+#	      exc_box = FreerideExceptionBox.new(self,"#{$!.class}: #{$!.message}\n\n#{$@.join("\n")}")
+#	      if exc_box.execute == MBOX_CLICKED_YES
+#                @plugin['/system/ui/components/EditPane'].each_slot {|ep| ep.manager.save}
+#              end
+#              # raise the exception again for the text console
+#              raise 
+#            ensure
+#              @running = false
+#              @plugin["/system/shutdown"].call(1)
+#            end
+#          end
+# now:
+# BGB - END
+        end
+        
+        def shutdown
+          @plugin.properties["Location/Width"] = self.width
+          @plugin.properties["Location/Height"] = self.height
+          @plugin.properties["Location/X"] = self.x
+          @plugin.properties["Location/Y"] = self.y
+          @app.handle(self, Fox.MKUINT(Fox::FXApp::ID_QUIT, Fox::SEL_COMMAND), nil)
+        end
+        
+      end
+
+
+      class FreerideExceptionBox < Fox::FXDialogBox
+
+        include Fox
+	include Responder
+
+	HORZ_PAD = 30
+	VERT_PAD =  2
+
+        def initialize(owner,text)
+
+          FXMAPFUNC(SEL_COMMAND, ID_CANCEL,   :onCmdClickedNo)
+          FXMAPFUNC(SEL_COMMAND, ID_ACCEPT,  :onCmdClickedYes)
+
+          # Invoke base class initialize function first
+          super(owner, "FreeRIDE went south...", DECOR_TITLE|DECOR_BORDER|DECOR_CLOSE|DECOR_RESIZE)
+          self.width = 580
+          self.height = 430
+          self.padLeft = 0
+          self.padRight = 0
+
+          content = FXVerticalFrame.new(self,LAYOUT_FILL_X|LAYOUT_FILL_Y)
+          #info = FXHorizontalFrame.new(content,LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X|LAYOUT_FILL_Y,0,0,0,0,10,10,10,10);
+          #FXLabel.new(info,nil,ic,ICON_BEFORE_TEXT|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X|LAYOUT_FILL_Y)
+          FXLabel.new(content,"Unhandled Exception Caught:",nil,JUSTIFY_LEFT|ICON_BEFORE_TEXT|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X)
+	  text_area = FXText.new(content,nil,0,JUSTIFY_LEFT|TEXT_READONLY|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X|LAYOUT_FILL_Y)
+	  text_area.text = text
+
+          FXLabel.new(content,"Please report the bug to http://rubyforge.org/tracker/?group_id=31\n\nWould you like to save modified files now?",nil,JUSTIFY_LEFT|ICON_BEFORE_TEXT|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X)
+
+          FXHorizontalSeparator.new(content,SEPARATOR_GROOVE|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X)
+
+          buttons = FXHorizontalFrame.new(content,LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH,0,0,0,0,10,10,10,10)
+          initial = FXButton.new(buttons,"&Yes",nil,self,ID_ACCEPT,BUTTON_INITIAL|BUTTON_DEFAULT|FRAME_RAISED|FRAME_THICK|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_CENTER_X,0,0,0,0,HORZ_PAD,HORZ_PAD,VERT_PAD,VERT_PAD)
+          FXButton.new(buttons,"&No",nil,self,ID_CANCEL,BUTTON_DEFAULT|FRAME_RAISED|FRAME_THICK|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_CENTER_X,0,0,0,0,HORZ_PAD,HORZ_PAD,VERT_PAD,VERT_PAD)
+          initial.setFocus
+        end
+
+
+        def onCmdClickedYes(sender, sel, ptr)
+          getApp.stopModal(self,MBOX_CLICKED_YES)
+          hide
+          return 1
+        end
+
+        def onCmdClickedNo(sender, sel, ptr)
+          getApp.stopModal(self,MBOX_CLICKED_NO)
+          hide
+          return 1
+        end
+
+      end
+    end
+
+  end
+end
+
+
