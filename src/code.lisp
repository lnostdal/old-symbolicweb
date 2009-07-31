;;;; http://nostdal.org/ ;;;;

(in-package #:sw)

(declaim #.(optimizations :code.lisp))


#.(maybe-inline 'run-js)
(defun run-js (js-str viewport)
  "Send JS-STR (JavaScript code) to VIEWPORT for execution. You should probably use
RUN instead."
  (declare (string js-str)
           (viewport viewport))
  (append-to-response-data-of viewport js-str)
  (values))


#.(maybe-inline 'run)
(declaim (ftype (function (string (or viewport widget) &key (:server-only-p (member t nil)))
                          (values &optional))
                run))
(defun run (code-str target &key server-only-p)
  "Send JavaScript code to client(s) for execution.

CODE-STR: The JavaScript code.

TARGET: If supplied with a WIDGET this will transmit the JS code to
all contexts (browser sessions (users), tabs and windows) where that widget is
visible. If supplied with a VIEWPORT this will transmit the JS code to that
single viewport for execution there."
  (cond
    (server-only-p)

    ((zerop (length code-str))
     (warn "SW:RUN: Returning from RUN with no effect; no code in CODE-STR."))

    (t
     (if (typep target 'viewport)
         (run-js code-str target)
         (when-let (viewport (viewport-of target))
           (run-js code-str viewport)))))
  (values))
