(ns zweikopf.core
  (:require [clojure.reflect :as r])
  (:import [org.jruby RubyObject RubyHash RubyBasicObject
            RubySymbol RubyHash$RubyHashEntry RubyArray]
           [org.jruby.javasupport JavaUtil]))

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
