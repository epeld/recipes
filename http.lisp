
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
  ;(setf (hunchentoot:content-type*) "text/plain")
  (html:as-string html:main-page))
