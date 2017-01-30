
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


(defun recipe-details (stream recipe)
  "Produce html describing teh details of a recipe"
  (cl-who:with-html-output (stream)
    (:h1 (cl-who:str (recipes:name recipe)))
    (:ul
     (loop for ingredient in (recipes:main-ingredients recipe) do
          (cl-who:htm (:li (cl-who:str ingredient)))))
    (:p (cl-who:str (recipes:description (or recipe ""))))))


(defun new-recipe-page (stream &optional recipe)
  "HTML for creating a new recipe"
  (let (name ingredients description)
    (when recipe
      (setf name (recipes:name recipe))
      (setf ingredients (recipes:main-ingredients recipe))
      (setf description (or (recipes:description recipe) nil)))
    
    (cl-who:with-html-output (stream)
      (:html
       (:head
        (:title "New Recipe Editor")
        (:style "textarea,input {display: block}"))
       (:body
        (when recipe
          (cl-who:htm
           (:div (:h1 "Preview:")
                 (recipe-details stream recipe))))
        (:form
         :method :post
         (:div "Name"
               (:input :name "name" :placeholder "Name" :value (cl-who:str name)))
             
         (:div "Main Ingredients"
               (:textarea :name "ingredients"
                          :placeholder "Main Ingredients"
                          (cl-who:str (format nil "~{~A~^, ~}" ingredients))))
             
         (:div "Description"
               (:textarea :name "description"
                          :placeholder "Description"
                          (cl-who:str description)))

         (:input :type :submit
                 :value "Preview")
         
         (when recipe
           (cl-who:htm (:input :type :submit
                               :name "save"
                               :value "Save")))))))))


(defun recipe-page (stream recipe)
  "Generate html for the main page"
  (cl-who:with-html-output (stream)
    (:html
     (:head
      (:title "Recipe Editor"))
     (:body
      (recipe-details stream recipe)))))



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


(defun recipes-list (stream &optional recipe-url-fn)
  "The full list of recipes"
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
             (:li (if recipe-url-fn
                      (cl-who:htm
                       (:a :href
                           (cl-who:str (funcall recipe-url-fn recipe))
                           (cl-who:str (recipes:name recipe))))
                      (cl-who:str (recipes:name recipe)))))))))))


;; For testing out pages:
(defmacro as-string (page &rest args)
  "Macro for getting the string output of each page"
  (let ((s (gensym "string-stream")))
    `(with-output-to-string (,s)
       (,page ,s ,@args))))

