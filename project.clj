(defproject zweikopf "1.0.2"
  :description "jruby clojure interop"
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.jruby/jruby-complete "9.1.6.0"]]

    :deploy-repositories [["releases" :clojars]
                          ["snapshots" :clojars]])
