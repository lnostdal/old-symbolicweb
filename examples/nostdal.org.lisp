;;;; http://nostdal.org/ ;;;;

(in-package #:sw)


(defclass nostdal-app (application)
  ()

  (:metaclass mvc-stm-class))

(set-uri 'nostdal-app "/")


(defmethod render-viewport ((viewport viewport) (app nostdal-app))
  (let ((main
         (mk-html
           (:div
            (:h1 "nostdal.org")
            (:p "Nothing much here for now. Check out some sauce at "
                (:a :href "http://gitorious.org/~lnostdal" "gitorious") ".")

            (:p "I'll add something here later.")

            (:hr :width "100%")
            (:a :href "mailto:larsnostdal@gmail.com" "Lars Rune Nøstdal")
            (:pre "λ(:linux :lighttpd :sbcl :sw-mvc :sw-stm :sw-db :sw-http :symbolicweb)λ")))))
    (setf (margin-of main) "1%")
    (add-to (root) main)))