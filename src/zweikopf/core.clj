(ns zweikopf.core
  (:require [clojure.reflect :as r])
  (:import [org.jruby Ruby RubyObject RubyHash RubyBasicObject
            RubySymbol RubyHash$RubyHashEntry RubyArray]
           [org.jruby.javasupport JavaUtil]))

(def ruby (Ruby/newInstance))

(defprotocol Clojurize
  (clojurize [this]))

(extend-protocol Clojurize
  java.lang.Object
  (clojurize [this] this)

  RubyObject
  (clojurize [this] (JavaUtil/convertRubyToJava this))

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
                 (persistent! acc)))))

(defn apply-to-keys-and-values
  ([m f]
     (apply-to-keys-and-values m f f))
  ([m key-f value-f]
     "Applies function f to all values in map m"
     (into {} (for [[k v] m]
                [(key-f k) (value-f v)]))))

(defprotocol Rubyize
  (rubyize [this]))

(extend-protocol Rubyize
  clojure.lang.IPersistentMap
  (rubyize [this]
    (doto (RubyHash. ruby)
      (.putAll (apply-to-keys-and-values this rubyize))))

  clojure.lang.IPersistentVector
  (rubyize [this]
    (doto (RubyArray/newArray ruby)
      (.addAll (for [item this] (rubyize item)))))

  clojure.lang.IPersistentList
  (rubyize [this]
    (doto (RubyArray/newArray ruby)
      (.addAll (for [item this] (rubyize item)))))

  clojure.lang.Keyword
  (rubyize [this]
    (.fastNewSymbol ruby (name this)))

  java.lang.Object
  (rubyize [this]
    this)

  )