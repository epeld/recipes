
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
;; Endpoints

(hunchentoot:define-easy-handler (main-page :uri "/") ()
  (html:as-string html:main-page))


(hunchentoot:define-easy-handler (recipe :uri "/recipe") (name)
  (let ((recipe (recipes:find-recipe name)))
    (if recipe
        (html:as-string html:recipe-page recipe)
        (progn
          (setf (hunchentoot:return-code*) hunchentoot:+http-not-found+)
          (html:as-string html:recipe-not-found name)))))


(hunchentoot:define-easy-handler (recipe :uri "/recipes") ()
  (html:as-string html:recipes-list))
