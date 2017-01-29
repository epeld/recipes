;;;; package.lisp

;; 
;; Dependencies

(ql:quickload "hunchentoot")
(ql:quickload "cl-who")

;; 
;; Packages

(defpackage #:recipes
  (:use #:cl)
  (:export #:def-recipe
           #:name
           #:description
           #:main-ingredients))


(defpackage #:cookbook
  (:use #:cl))


(defpackage #:http
  (:use #:cl))


(defpackage #:html
  (:use #:cl)
  (:export #:main-page
           #:as-string))

