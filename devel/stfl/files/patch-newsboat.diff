https://github.com/newsboat/newsboat/issues/506

--- base.c.orig	2015-01-05 10:50:54 UTC
+++ base.c
@@ -750,9 +750,11 @@ unsigned int stfl_print_richtext(struct stfl_widget *w
 				wmemcpy(stylename, p1 + 1, p2 - p1 - 1);
 				stylename[p2 - p1 - 1] = L'\0';
 				if (wcscmp(stylename,L"")==0) {
-					mvwaddnwstr(win, y, x, L"<", 1);
-					retval += 1;
-					++x;
+					if (end_col - x > 0) {
+						mvwaddnwstr(win, y, x, L"<", 1);
+						retval += 1;
+						++x;
+					}
 				} else if (wcscmp(stylename, L"/")==0) {
 					stfl_style(win, style_normal);
 				} else {
