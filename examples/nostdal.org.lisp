;;;; http://nostdal.org/ ;;;;

(in-package #:sw)


(defclass nostdal-app (application)
  ()

  (:metaclass mvc-stm-class))

(set-uri 'nostdal-app "/nostdal.org")


(defmethod render-viewport ((viewport viewport) (app nostdal-app))
  (let ((main
         (mk-html
           (:div
            (:h1 "nostdal.org")

            (:ul
             (:li (:a :href "http://gitorious.org/~lnostdal" "gitorious"))
             (:li (:a :href "text-input" "text-input-app")))

            (:hr :width "100%")
            (:pre "λ(:linux :lighttpd :sbcl :sw-http :sw-mvc :sw-stm :sw-db :symbolicweb)λ")))))
    (setf (margin-of main) "1%")
    (add-to (root) main)))
