--- Modules/selectmodule.c.orig	Tue Feb 11 10:18:58 2003
+++ Modules/selectmodule.c	Tue Jan 27 17:56:11 2004
@@ -318,7 +318,7 @@
 	return ret;
 }
 
-#ifdef HAVE_POLL
+#if defined(HAVE_POLL) && !defined(_POLL_EMUL_H_)
 /* 
  * poll() support
  */
@@ -612,7 +612,7 @@
 		return NULL;
 	return (PyObject *)rv;
 }
-#endif /* HAVE_POLL */
+#endif /* HAVE_POLL && !_POLL_EMUL_H_ */
 
 PyDoc_STRVAR(select_doc,
 "select(rlist, wlist, xlist[, timeout]) -> (rlist, wlist, xlist)\n\
@@ -639,9 +639,9 @@
 
 static PyMethodDef select_methods[] = {
     {"select",	select_select, METH_VARARGS, select_doc},
-#ifdef HAVE_POLL
+#if defined(HAVE_POLL) && !defined(_POLL_EMUL_H_)
     {"poll",    select_poll,   METH_VARARGS, poll_doc},
-#endif /* HAVE_POLL */
+#endif /* HAVE_POLL && !_POLL_EMUL_H_ */
     {0,  	0},			     /* sentinel */
 };
 
@@ -660,7 +660,7 @@
 	SelectError = PyErr_NewException("select.error", NULL, NULL);
 	Py_INCREF(SelectError);
 	PyModule_AddObject(m, "error", SelectError);
-#ifdef HAVE_POLL
+#if defined(HAVE_POLL) && !defined(_POLL_EMUL_H_)
 	poll_Type.ob_type = &PyType_Type;
 	PyModule_AddIntConstant(m, "POLLIN", POLLIN);
 	PyModule_AddIntConstant(m, "POLLPRI", POLLPRI);
@@ -684,5 +684,5 @@
 #ifdef POLLMSG
 	PyModule_AddIntConstant(m, "POLLMSG", POLLMSG);
 #endif
-#endif /* HAVE_POLL */
+#endif /* HAVE_POLL && !_POLL_EMUL_H_ */
 }
