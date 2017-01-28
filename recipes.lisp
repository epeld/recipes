;;;; recipes.lisp

(in-package #:recipes)


(defvar recipes
  nil
  "The database of available recipes")


(defclass recipe ()
  ((name :reader name
         :initarg :name)
   
   (main-ingredients :reader main-ingredients
                     :initarg :ingredients)
   
   (description :reader description
                :initarg :description))
  
  (:documentation "Represents a cooking recipe"))


(defun ingredients-match-recipe-p (ingredients recipe)
  "Verify that the ingredients satisfy a given recipe"
  (let ((diff (set-difference (main-ingredients recipe) ingredients)))
    (not diff)))


(defun suggest-recipe (available-ingredients)
  "Suggest a recipe, given the list of available ingredients"
  (loop for recipe in recipes 
     when (ingredients-match-recipe-p available-ingredients recipe)
       collect recipe))


(defun def-recipe (name ingredients description)
  "Define a new recipe"
  (push (make-instance 'recipe
                       :name name
                       :ingredients ingredients
                       :description description)
        recipes))


;(suggest-recipe (list :milk :eggs :butter :pasta :onions))
