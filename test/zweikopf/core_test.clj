(ns zweikopf.core-test
  (:import [org.jruby.embed ScriptingContainer])
  (:use clojure.test
        zweikopf.core))

(defn run-ruby-script [script]
  (.evalScriptlet ruby script)
  ;; (.runScriptlet (ScriptingContainer.) script)
  )

(deftest clojurize-test
  (testing "Empty hash"
    (is (= {} (clojurize (run-ruby-script "{}")))))
  (testing "Non-empty hash"
    (is (= {:a 1 :b 2} (clojurize (run-ruby-script "{:a => 1, :b =>2 }")))))
  (testing "Deep hash"
    (is (= {:a 1 :b {:c 3 :d 4}} (clojurize (run-ruby-script "{:a => 1, :b => {:c => 3, :d =>4}}")))))

  (testing "Empty array"
    (is (= [] (clojurize (run-ruby-script "[]")))))
  (testing "Non-empty array"
    (is (= [1 :a "b"]) (clojurize (run-ruby-script "[1, :a, 'b']"))))
  (testing "Deep array"
    (is (= [:a [:c :d] :e :f]) (clojurize (run-ruby-script "[:a, [:c, :d], :e, :f]"))))
  (testing "Complex DS"
    (is (= [:a [:c {:d :e}] :f :g] (clojurize (run-ruby-script "[:a, [:c, {:d => :e}], :f, :g]"))))))

(deftest rubyize-test
  (testing "Emtpy hash"
    (is (.equals (run-ruby-script "{}") (rubyize {}))))
  (testing "Non-emtpy hash"
    (is (.equals (run-ruby-script "{:a => 1, :b => 2}") (rubyize {:a 1 :b 2}))))
  (testing "Deep hash"
    (is (.equals (run-ruby-script "{:a => 1, :b => {:c => 3, :d =>4}}") (rubyize {:a 1 :b {:c 3 :d 4}}))))

  (testing "Empty array"
    (is (= (run-ruby-script "[]") (rubyize []))))

  (testing "Empty list"
    (is (= (run-ruby-script "[]") (rubyize '()))))

  (testing "Non-empty array"
    (is (= (run-ruby-script "[1, :a, 'b']") (rubyize [1 :a "b"])) ))

  (testing "Deep array"
    (is (= (run-ruby-script "[:a, [:c, :d], :e, :f]") (rubyize [:a [:c :d] :e :f])) ))

  (testing "Complex DS"
    (is (= (run-ruby-script "[:a, [:c, {:d => :e}], :f, :g]") (rubyize [:a [:c {:d :e}] :f :g])))))

(comment
  (deftest performance
    (testing "this spec simply shows performance, very roughly, please do your testing depending on your needs"
      (time
       (let [ruby-obj (run-ruby-script (str "{:a => 1, :b => 2 }"))]
         (dotimes [i 100000]
           (clojurize ruby-obj)))))))
