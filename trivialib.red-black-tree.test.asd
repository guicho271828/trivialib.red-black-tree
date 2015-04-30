#|
  This file is a part of trivialib.red-black-tree project.
  Copyright (c) 2015 Masataro Asai (guicho2.71828@gmail.com)
|#


(in-package :cl-user)
(defpackage trivialib.red-black-tree.test-asd
  (:use :cl :asdf))
(in-package :trivialib.red-black-tree.test-asd)


(defsystem trivialib.red-black-tree.test
  :author "Masataro Asai"
  :license "LLGPL"
  :depends-on (:trivialib.red-black-tree
               :iterate
               :fiveam)
  :components ((:module "t"
                :components
                ((:file "package"))))
  :perform (load-op :after (op c) (eval (read-from-string "(every #'fiveam::TEST-PASSED-P (5am:run! :trivialib.red-black-tree))"))
))
