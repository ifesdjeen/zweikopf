(ns zweikopf.core
  (:require [zweikopf.multi :as multi])
  (:import [org.jruby.embed ScriptingContainer LocalContextScope]
           [org.jruby Ruby]))

(declare ^ScriptingContainer ruby)
(declare ^Ruby ruby-runtime)

(defn clojurize
  [this]
  (multi/clojurize this ruby))

(defn rubyize
  [this]
  (multi/rubyize this ruby))

(defn ruby-eval
  [script]
  (multi/ruby-eval ruby script))

(defn ruby-require
  [lib]
  (ruby-eval (format "require '%s'" lib)))

(defn ruby-load
  [lib]
  (ruby-eval (format "load '%s'" lib)))

(defn call-ruby
  [& args]
  (apply multi/call-ruby ruby args))

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
