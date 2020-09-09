Fix with Qt5-5.14

Obtained from:
	https://github.com/quassel/quassel/commit/579e559a6322209df7cd51c34801fecff5fe734b

--- src/common/types.h.orig	2020-04-04 10:50:56 UTC
+++ src/common/types.h
@@ -140,6 +140,7 @@ Q_DECLARE_METATYPE(QHostAddress)
 typedef QList<MsgId> MsgIdList;
 typedef QList<BufferId> BufferIdList;
 
+#if QT_VERSION < QT_VERSION_CHECK(5, 14, 0)
 /**
  * Catch-all stream serialization operator for enum types.
  *
@@ -169,6 +170,7 @@ QDataStream &operator>>(QDataStream &in, T &value) {
     value = static_cast<T>(v);
     return in;
 }
+#endif
 
 // Exceptions
 
