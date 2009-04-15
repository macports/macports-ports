(def completions
    (reduce concat (map (fn [p] (keys (ns-publics (find-ns p))))
                        '(clojure.core clojure.set clojure.xml clojure.zip))))
 
(with-open [f (java.io.BufferedWriter. (java.io.FileWriter. ".clj_completions"))]
    (.write f (apply str (interleave completions (repeat "\n")))))