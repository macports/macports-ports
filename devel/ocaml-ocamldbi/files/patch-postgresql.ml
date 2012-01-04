--- dbi_postgresql.ml.orig	2008-07-29 14:18:16.000000000 -0700
+++ dbi_postgresql.ml	2008-07-29 14:32:00.000000000 -0700
@@ -120,9 +120,9 @@
     (fun h m s -> { Dbi.hour = h; Dbi.min = m; Dbi.sec = s;
                     Dbi.microsec = 0;  Dbi.timezone = None })
 
-(* [encode_sql_t v] returns a string suitable for substitution of "?"
+(* [encode_sql_t conn v] returns a string suitable for substitution of "?"
    in a SQL query. *)
-let encode_sql_t = function
+let encode_sql_t (conn : Pg.connection) = function
   | `Null -> "NULL"
   | `Int i ->
       (* As we use [`Int] for INTEGER and SMALLINT, we quote the
@@ -139,7 +139,7 @@
   | `Timestamp t -> string_of_timestamp t
   | `Interval i -> string_of_interval i
   | `Blob s -> Dbi.string_escaped s (* FIXME *)
-  | `Binary s -> "'" ^ Pg.escape_bytea s ^ "'::bytea"
+  | `Binary s -> "'" ^ (conn#escape_bytea s) ^ "'::bytea"
   | `Unknown s -> s
 
 
@@ -209,7 +209,7 @@
 
     let query = (* substitute args *)
       Dbi.make_query "Dbi_postgres: execute called with wrong number of args."
-        encode_sql_t query args in
+        (fun v -> encode_sql_t conn v) query args in
     (* Send the query to the database. *)
     let res = conn#exec query in
 
