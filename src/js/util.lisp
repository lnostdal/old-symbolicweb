;;;; http://nostdal.org/ ;;;;

(in-package #:sw)

(declaim #.(optimizations))


(defun alert (msg &optional (viewport-or-widget *viewport*))
  (let ((js-code (catstr "alert(decodeURIComponent(\"" (url-encode msg) "\"));")))
    (if *js-code-only-p*
        js-code
        (run js-code viewport-or-widget))))
(export 'alert)


(defun window-location-href (&optional (viewport *viewport*))
  (declare (type viewport viewport))
  (let ((js-code "return window.location.href;"))
    (if *js-code-only-p*
        js-code
        (run js-code viewport :async-p nil))))
(export 'window-location-href)


(defun (setf window-location-href) (new-href &optional (viewport *viewport*))
  (declare (type viewport viewport))
  (let ((js-code (catstr "window.location.href=\""
                         new-href ;;(cl-ppcre:regex-replace-all " " new-href "_")
                         "\";")))
    (if *js-code-only-p*
        js-code
        (run js-code viewport))))
(export 'window-location-href)


(defun get-title (&optional (viewport *viewport*))
  (declare (type viewport viewport))
  (let ((js-code "return document.title;"))
    (if *js-code-only-p*
        js-code
        (run js-code viewport :async-p nil))))
(export 'get-title)


(defun set-title (new-title &optional (viewport *viewport*))
  (declare (type viewport viewport))
  (let ((js-code (catstr "document.title = decodeURIComponent(\""
                         (url-encode new-title)
                         "\");")))
    (if *js-code-only-p*
        js-code
        (run js-code viewport))))
(export 'set-title)


(defun reload (&optional (viewport *viewport*))
  "Do a page reload equal to the user pressing F5 or Ctrl-R in the browser."
  (declare (type viewport viewport))
  (let ((js-code "window.location.reload();"))
    (if *js-code-only-p*
        js-code
        (run js-code viewport))))
(export 'reload)


(defmethod redraw ((p (eql t)))
  "Redraw all elements on the page without reloading (see RELOAD) the page."
  (declare (ignore p))
  (render *root*))
(export 'redraw)


(defmethod ping ((viewport viewport) &optional (timeout *timeout*))
  "Pings the client."
  (let ((irt-start (get-internal-real-time)))
    (run "return \"pong\";" viewport :async-p nil :timeout timeout)
    (values (- (get-internal-real-time) irt-start)
            internal-time-units-per-second
            viewport)))
(export 'ping)


(defun prompt (for-what &key (viewport *viewport*) (timeout *timeout*))
  (declare (type viewport viewport))
  (run (catstr "return prompt(decodeURIComponent(\"" (url-encode for-what) "\"));") viewport
       :timeout timeout
       :async-p nil))
(export 'prompt)


(defun fade-in (widget &key (speed 400) callback)
  "Returns WIDGET.
If CALLBACK is a string (JS-CODE-OF) it will be executed without a round-trip to the server."
  (declare (type widget widget))
  (when callback (error "TODO"))
  (flet ((js-code ()
           (catstr "$(\"#" (id-of widget) "\").fadeIn(" (princ-to-string speed) ");")))
    (declare (inline js-code))
    (if *js-code-only-p*
        (js-code)
        (progn
          (run (js-code) widget)
          widget))))
(export 'fade-in)


(defun fade-out (widget &key (speed 400) callback)
  "Returns WIDGET.
If CALLBACK is a string (JS-CODE-OF) it will be executed without a round-trip to the server."
  (declare (type widget widget))
  (when callback (error "TODO"))
  (flet ((js-code ()
           (catstr "$(\"#" (id-of widget) "\").fadeOut(" (princ-to-string speed) ");")))
    (declare (inline js-code))
    (if *js-code-only-p*
        (js-code)
        (progn
          (run (js-code) widget)
          widget))))
(export 'fade-out)


(defun set-loading-p (pred &optional (viewport *viewport*))
  (let ((js-code
         (if pred
             (js-set-css "sw-loading-spinner" "display" "block")
             (js-set-css "sw-loading-spinner" "display" "none"))))
    (if *js-code-only-p*
        js-code
        (progn
          (run js-code viewport)
          pred))))
(export 'set-loading-p)


(defun set-document-cookie (&key
                            (name (cookie-name-of (server-of *app*)))
                            (value (cookie-value-of *app*))
                            (viewport *viewport*))
  ;; TODO: Supplying NIL for value should remove the cookie.
  (declare (string name value)
           (optimize speed))
  (let ((js-code
         (catstr
           "document.cookie = \"" name "=" value ";"
           (if (generate-dynamic-subdomain *app*)
               "domain=.\" + window.location.hostname + \";"
               "")
           "expires=\" + (function(){ var date = new Date(); date.setFullYear(date.getFullYear()+1); return date.toUTCString(); })() + \";"
           "path=\" + window.location.pathname + \";"
           "\";")))
    (if *js-code-only-p*
        js-code
        (progn
          (run js-code viewport)
          value))))
(export 'set-document-cookie)