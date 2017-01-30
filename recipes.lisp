;;;; recipes.lisp

(in-package #:recipes)


(defvar recipes
  nil
  "The database of available recipes")


(defclass recipe ()
  ((name :reader name
         :type string
         :initarg :name)
   
   (main-ingredients :reader main-ingredients
                     :type (list string)
                     :initarg :ingredients)
   
   (description :reader description
                :type string
                :initarg :description))
  
  (:documentation "Represents a cooking recipe"))


(defmethod print-object ((recipe recipe) stream)
  (format stream "#<RECIPE FOR ~a>" (name recipe)))


(defun ingredients-match-recipe-p (ingredients recipe)
  "Verify that the ingredients satisfy a given recipe"
  (let ((diff (set-difference (main-ingredients recipe) ingredients)))
    (not diff)))


(defun available-recipes (available-ingredients)
  "Filter the list of recipes, finding the ones compatible with the given ingredients"
  (loop for recipe in recipes 
     when (ingredients-match-recipe-p available-ingredients recipe)
       collect recipe))


(defun new-recipe (name ingredients description)
  "Construct a new recipe, but doesn't add it do the list"
  (make-instance 'recipe
                 :name (string-upcase name)
                 :ingredients (mapcar #'string-upcase ingredients)
                 :description description))


(defun register-recipe (recipe)
  "Register a new recipe in the list"
  (push recipe recipes))


(defun def-recipe (name ingredients description)
  "Short-hand for creating and registering a recipe"
  (let ((recipe (new-recipe name ingredients description)))
    (register-recipe recipe)
    recipe))


(defun find-recipe (name)
  "Find a recipe with a given name"
  (find-if (lambda (recipe)
             (string-equal name (name recipe)))
           recipes))


(defun sorted ()
  "Return a list of recipes in alphabetical order"
  (stable-sort recipes
               #'string-lessp
               :key #'name))
