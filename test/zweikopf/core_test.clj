(ns zweikopf.core-test
  (:import [org.jruby.embed ScriptingContainer])
  (:use clojure.test
        zweikopf.core))

(defn run-ruby-script [script]
  (.runScriptlet (ScriptingContainer.) script))

(deftest hash-test
  (testing "Empty hash"
    (is (= {} (clojurize (run-ruby-script "{}")))))
  (testing "Non-empty hash"
    (is (= {:a 1 :b 2} (clojurize (run-ruby-script "{:a => 1, :b =>2 }")))))
  (testing "Deep hash"
    (is (= {:a 1 :b {:c 3 :d 4}} (clojurize (run-ruby-script "{:a => 1, :b => {:c => 3, :d =>4}}"))))))

(deftest array-test
  (testing "Empty array"
    (is (= [] (clojurize (run-ruby-script "[]")))))
  (testing "Non-empty array"
    (is (= [1 :a "b"]) (run-ruby-script "[1, :a, 'b']")))
  (testing "Deep array"
    (is (= [:a [:c :d] :e :f]) (run-ruby-script "[:a, [:c, :d], :e, :f]"))))