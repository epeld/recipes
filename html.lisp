
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


(defun recipe-page (stream recipe)
  "Generate html for the main page"
  (cl-who:with-html-output (stream)
    (:html
     (:head
      (:title "Recipe Editor"))
     (:body
      (:h1 (cl-who:str (recipes:name recipe)))
      (:ul
       (loop for ingr in (recipes:main-ingredients recipe) do
            (cl-who:htm (:li (cl-who:str ingr)))))
      (:p (cl-who:str (recipes:description recipe)))))))



(defun recipe-not-found (stream name)
  "404 Not found page for recipes"
  (cl-who:with-html-output (stream)
    (:html
     (:head
      (:title "Recipe Not Found"))
     (:body
      (:h1 "The recipe '" (cl-who:str name) "' could not be found")
      (:p "The recipe list can help you find recipes"))))

  404)


(defun recipes-list (stream)
  "404 Not found page for recipes"
  (cl-who:with-html-output (stream)
    (:html
     (:head
      (:title "Recipe List"))
     (:body
      (:h1 "List of all Recipes")
      (:p "Later you will be able to search for recipes here")
      (:ul
       (loop for recipe in (recipes:sorted) do
            (cl-who:htm
             (:li (cl-who:str (recipes:name recipe))))))))))


;; For testing out pages:
(defmacro as-string (page &rest args)
  "Macro for getting the string output of each page"
  (let ((s (gensym "string-stream")))
    `(with-output-to-string (,s)
       (,page ,s ,@args))))

