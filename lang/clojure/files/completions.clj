(def completions (keys (ns-publics (find-ns 'clojure.core))))
 
(with-open [f (java.io.BufferedWriter. (java.io.FileWriter. ".clj_completions"))]
    (.write f (apply str (interleave completions (repeat "\n")))))