https://github.com/php/php-src/commit/67259e4
--- php-src/ext/xml/tests/gh14834.phpt.orig	2025-03-29 11:04:03.000000000 -0600
+++ php-src/ext/xml/tests/gh14834.phpt	2025-03-29 16:00:42.000000000 -0600
@@ -0,0 +1,29 @@
+--TEST--
+GH-14834 (Error installing PHP when --with-pear is used)
+--EXTENSIONS--
+xml
+--FILE--
+<?php
+$xml = <<<XML
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE root [
+    <!ENTITY foo "ent">
+]>
+<root>
+  <element hint="hello&apos;world">&foo;<![CDATA[ &amp; ]]><?x &amp; ?></element>
+</root>
+XML;
+
+$parser = xml_parser_create();
+xml_set_character_data_handler($parser, function($_, $data) {
+    var_dump($data);
+});
+xml_parse($parser, $xml, true);
+?>
+--EXPECT--
+string(3) "
+  "
+string(3) "ent"
+string(7) " &amp; "
+string(1) "
+"
