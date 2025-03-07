--- src/sequence.c.orig	2011-04-06 19:35:39 UTC
+++ src/sequence.c
@@ -66,7 +66,7 @@ bdb_seq_txn_close(VALUE obj, VALUE commit, VALUE real)
 }
 
 static VALUE
-bdb_seq_i_options(VALUE obj, VALUE seqobj)
+bdb_seq_i_options(VALUE obj, VALUE seqobj, int _argc, const VALUE *_argv, VALUE _blockarg)
 {
     VALUE key, value;
     bdb_SEQ *seqst;
@@ -148,7 +148,7 @@ bdb_seq_open(int argc, VALUE *argv, VALUE obj)
         break;
     }
     if (!NIL_P(options)) {
-        rb_iterate(rb_each, options, bdb_seq_i_options, res);
+	rb_block_call(options, rb_intern("each"), 0, NULL, bdb_seq_i_options, res);
     }
     a = bdb_test_recno(obj, &key, &recno, a);
     if (seqst->seqp->open(seqst->seqp, txnid, &key, flags)) {
