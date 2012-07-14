(ns zweikopf.core-test
  (:import [org.jruby.embed ScriptingContainer])
  (:use clojure.test
        zweikopf.core))

(deftest a-test
  (let [scripting-container (ScriptingContainer.)]
    (testing "Empty hash"
      (is (= {} (clojurize (.runScriptlet scripting-container "{}")))))
    (testing "Non-empty hash"
      (is (= {:a 1 :b 2} (clojurize (.runScriptlet scripting-container "{:a => 1, :b =>2 }")))))
    (testing "Deep hash"
      (is (= {:a 1 :b {:c 3 :d 4}} (clojurize (.runScriptlet scripting-container "{:a => 1, :b => {:c => 3, :d =>4}}")))))))