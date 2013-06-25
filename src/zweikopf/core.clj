(ns zweikopf.core
  (:require [clojure.reflect :as r])
  (:import [org.jruby.embed ScriptingContainer LocalContextScope]
           [org.jruby RubyObject RubyHash RubyBasicObject
            RubySymbol RubyHash$RubyHashEntry RubyArray RubyString]
           [org.jruby.javasupport JavaUtil])
  (:import [org.jruby Ruby RubyObject RubyHash RubyBasicObject
            RubySymbol RubyHash$RubyHashEntry RubyArray]
           [org.jruby.javasupport JavaUtil]))

(declare ruby)
(declare ruby-runtime)

(defprotocol Clojurize
  (clojurize [this]))

(defprotocol Rubyize
  (rubyize [this]))

(defn ruby-eval
  [script]
  (.evalScriptlet ruby-runtime script))

(defn ruby-require
  [lib]
  (ruby-eval (format "require '%s'" lib)))

(defn ruby-load
  [lib]
  (ruby-eval (format "load '%s'" lib)))

(defmacro call-ruby
  [klass method & args-list]
  `(let [args# ~(vec args-list)
         method-name# ~(name method)
         klass# (if (string? ~klass)
                  (ruby-eval (clojure.string/replace ~klass "/" "::"))
                  ~klass)]
     (if ~(empty? args-list)
       (.callMethod ^org.jruby.embed.ScriptingContainer ruby klass# method-name# Object)
       (.callMethod ^org.jruby.embed.ScriptingContainer ruby klass# method-name# (object-array args#) Object))))

(defn set-gem-path
  "Sets GEM_PATH Environment variable"
  [gem-path]
  (ruby-eval (str "ENV['GEM_PATH']='" gem-path "'")))

(defn set-gem-home
  [gem-home]
  (ruby-eval (str "ENV['GEM_HOME']='" gem-home "'")))

(defn init-ruby-context
  []
  (defonce ruby (ScriptingContainer. LocalContextScope/SINGLETON))
  (defonce ruby-runtime (.getRuntime (.getProvider ruby))))

(extend-protocol Clojurize
  nil
  (clojurize [this] nil)

  RubySymbol
  (clojurize [^RubySymbol this]
             (clojure.lang.Keyword/intern (.toString this)))
  RubyHash
  (clojurize [^RubyHash this]
             (loop [[^RubyHash$RubyHashEntry entry & entries] (seq (.directEntrySet this))
                    acc (transient {})]
               (if entry
                 (recur entries
                        (assoc! acc (clojurize (.getKey entry))
                                (clojurize (.getValue entry))))
                 (persistent! acc))))
  RubyArray
  (clojurize [^RubyArray this]
             (loop [[entry & entries] (seq this)
                    acc (transient [])]
               (if entry
                 (recur entries (conj! acc (clojurize entry)))
                 (persistent! acc))))

  RubyString
  (clojurize [this]
    (.decodeString this))

  org.jruby.RubyNil
  (clojurize  [_]
    nil)

  org.jruby.RubyFixnum
  (clojurize  [this]
    (.getLongValue this))

  org.jruby.RubyFloat
  (clojurize  [this]
    (.getDoubleValue this))

  org.jruby.RubyBoolean
  (clojurize  [this]
    (.isTrue this))

  org.jruby.RubyTime
  (clojurize [this]
    (.toJava this java.util.Date))

  org.jruby.RubyObject
  (clojurize [this]
    (condp #(call-ruby %2 respond_to? %1) this
      "to_hash" (clojurize (call-ruby this to_hash))
      "to_time" (clojurize (call-ruby this to_time))))

  java.lang.Object
  (clojurize [this] this))

(defn apply-to-keys-and-values
  ([m f]
     (apply-to-keys-and-values m f f))
  ([m key-f value-f]
     "Applies function f to all values in map m"
     (into {} (for [[k v] m]
                [(key-f k) (value-f v)]))))

(extend-protocol Rubyize
  clojure.lang.IPersistentMap
  (rubyize [this]
    (doto (RubyHash. ruby-runtime)
      (.putAll (apply-to-keys-and-values this rubyize))))

  clojure.lang.PersistentArrayMap
  (rubyize [this]
    (doto (RubyHash. ruby-runtime)
      (.putAll (apply-to-keys-and-values this rubyize))))

  clojure.lang.IPersistentVector
  (rubyize [this]
    (doto (RubyArray/newArray ruby-runtime)
      (.addAll (for [item this] (rubyize item)))))

  clojure.lang.IPersistentList
  (rubyize [this]
    (doto (RubyArray/newArray ruby-runtime)
      (.addAll (for [item this] (rubyize item)))))

  clojure.lang.Keyword
  (rubyize [this]
    (.fastNewSymbol ruby-runtime (name this)))

  java.lang.Object
  (rubyize [this]
    this)

  nil
  (rubyize [this] nil))
