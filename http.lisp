
(in-package #:http)


;;
;; Life Cycle

(defvar acceptor
  nil
  "The hunchentoot acceptor used for serving http")


(defun stop ()
  "Stop the http server"
  (when acceptor
    (hunchentoot:stop acceptor)
    (setf acceptor nil)))


(defun start (&optional (port 4242))
  "Start the http server"
  (let ((acc (make-instance 'hunchentoot:easy-acceptor :port port)))
    ;; Stop anything currently running
    (stop)
    (setf acceptor acc)
    (hunchentoot:start acceptor)))


;;
;; Util

(defun split-ingredients (s)
  "Split on whitespace, convert to keyword"
  (let (ingredients)
    (loop for c across s
       with word
       do
         (if (member c '(#\Tab #\Space #\Newline #\Return))
             (when word
               (push (coerce (nreverse word) 'string)
                     ingredients)
               (setf word nil))
             (push c word))
       finally
         (when word
           (push (coerce (nreverse word) 'string)
                 ingredients)))
    
    ingredients))

;;
;; Endpoints

(hunchentoot:define-easy-handler (main-page :uri "/") ()
  (html:as-string html:main-page))


(hunchentoot:define-easy-handler (new-recipe :uri "/new-recipe") (name ingredients description)
  (let ((recipe (when (eq :post (hunchentoot:request-method*))
                  (recipes:new-recipe name (split-ingredients ingredients) description))))
    (html:as-string html:new-recipe-page recipe)))


(hunchentoot:define-easy-handler (recipe :uri "/recipe") (name)
  (let ((recipe (recipes:find-recipe name)))
    (if recipe
        (html:as-string html:recipe-page recipe)
        (progn
          (setf (hunchentoot:return-code*) hunchentoot:+http-not-found+)
          (html:as-string html:recipe-not-found name)))))


(hunchentoot:define-easy-handler (recipes :uri "/recipes") ()
  (html:as-string html:recipes-list

                  ;; Produce urls pointing to the recipe-endpoint above
                  (lambda (recipe)
                    (concatenate 'string
                                 "/recipe?name="
                                 (string (recipes:name recipe))))))
