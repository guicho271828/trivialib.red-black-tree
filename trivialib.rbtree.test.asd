#|
  This file is a part of trivialib.rbtree project.
  Copyright (c) 2015 Masataro Asai (guicho2.71828@gmail.com)
|#


(in-package :cl-user)
(defpackage trivialib.rbtree.test-asd
  (:use :cl :asdf))
(in-package :trivialib.rbtree.test-asd)


(defsystem trivialib.rbtree.test
  :author "Masataro Asai"
  :license "LLGPL"
  :depends-on (:trivialib.rbtree
               :fiveam)
  :components ((:module "t"
                :components
                ((:file "package"))))
  :perform (load-op :after (op c) (eval (read-from-string "(every #'fiveam::TEST-PASSED-P (5am:run! :trivialib.rbtree))"))
))
