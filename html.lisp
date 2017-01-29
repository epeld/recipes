
(in-package #:html)


(defun main-page (stream)
  "Generate html for the main page"
  (cl-who:with-html-output (stream)
    (:html
     (:head
      (:title "Recipe Chooser"))
     (:body
      (:h1 "Hi all!")
      (:p "This is a paragraph")))))


(defun edit-recipe-page (stream recipe)
  "Generate html for the main page"
  (cl-who:with-html-output (stream)
    (:html
     (:head
      (:title "Recipe Editor"))
     (:body
      (:h1 (string (recipes:name recipe)))
      (:p (string (recipes:description recipe)))))))


;; For testing out pages:
(defmacro as-string (page &rest args)
  "Macro for getting the string output of each page"
  (let ((s (gensym "string-stream")))
    `(with-output-to-string (,s)
       (,page ,s ,@args))))

