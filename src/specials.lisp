;;;; http://nostdal.org/ ;;;;

(in-package #:sw)


(defvar *server* nil)
(export '*server*)

(defvar *app* nil)
(export '*app*)

(defvar *viewport* nil)
(export '*viewport*)


;; Ok, this might be somewhat of a "wrong" thing to do.. TODO: Not a special variable.
(define-symbol-macro *root* (root-widget-of *viewport*))
(export '*root*)


;; TODO: Is this really useful? It seems be bound in server-sw-http.lisp then only used in viewport.lisp.
(defvar *request-type* :unknown
  ":AJAX, :COMET, :REGULAR or :UNKNOWN.")
(export '*request-type*)


(defvar *js-code-only-p* nil
  "Used by the macros JS-CODE-OF and WITH-JS-CODE-FROM (src/js/util.lisp).")


;; :AROUND INITIALIZE-INSTANCE ((.. widget) ..)
(defvar *currently-constructing-widget* nil)


;; (ajax.lisp)
(defvar *current-event* nil
  "This will contain an instance of EVENT (widgets/events.lisp).")


;;; Stuff for HTML-CONTAINER (widgets/html-container.lisp).
(defvar *creating-html-container-p* nil)
(defvar *html-container-children* nil)


(defvar *request-time* nil)
