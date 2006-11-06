Tue Aug 15 19:41:27 EDT 2006  Esa Ilari Vuokko <ei@vuokko.info>
  * Workaround for HasBounds that was removed in base-2.0 (GHC 6.6)
diff -rN -u old-hsdarcs-2/Lcs.lhs new-hsdarcs-2/Lcs.lhs
--- Lcs.lhs   2006-11-02 09:05:05.000000000 -0500
+++ Lcs.lhs   2006-11-02 09:05:05.000000000 -0500
@@ -358,7 +358,8 @@
 -- | goto next unchanged line, return the given line if unchanged
 nextUnchanged :: BSTArray s -> Int -> ST s Int
 nextUnchanged c i = do
-  if i == (aLen c) + 1 then return i
+  len <- aLenM c
+  if i == len + 1 then return i
      else do b <- readArray c i
              if b then nextUnchanged c (i+1)
                 else return i
@@ -367,7 +368,8 @@
 --   behind the last line
 skipOneUnChanged :: BSTArray s -> Int -> ST s Int
 skipOneUnChanged c i = do
-  if i == (aLen c) + 1 then return i
+  len <- aLenM c
+  if i == len + 1 then return i
      else do b <- readArray c i
              if not b then return (i+1)
                 else skipOneUnChanged c (i+1)
@@ -381,8 +383,9 @@
 
 -- | goto next changed line, return the given line if changed
 nextChanged :: BSTArray s -> Int -> ST s (Maybe Int)
-nextChanged c i =
-  if i <= aLen c
+nextChanged c i = do
+  len <- aLenM c
+  if i <= len
     then do b <- readArray c i
             if not b then nextChanged c (i+1)
                else return $ Just i
@@ -430,8 +433,17 @@
 initP :: [PackedString] -> PArray
 initP a = listArray (0, length a) (nilPS:a)
 
+#if __GLASGOW_HASKELL__ > 604
+aLen :: (IArray a e) => a Int e -> Int
+aLen a = snd $ bounds a
+aLenM :: (MArray a e m) => a Int e -> m Int
+aLenM a = getBounds a >>= return . snd
+#else
 aLen :: HasBounds a => a Int e -> Int
 aLen a = snd $ bounds a
+aLenM :: (HasBounds a, Monad m) => a Int e -> m Int
+aLenM = return . snd . bounds
+#endif
 \end{code}
 
 \begin{code}
