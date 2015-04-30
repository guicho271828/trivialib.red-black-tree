#|
  This file is a part of trivialib.rbtree project.
  Copyright (c) 2015 Masataro Asai (guicho2.71828@gmail.com)
|#

#|
  Red-Black tree implementation using Trivia, original code by m2ym

  Author: Masataro Asai (guicho2.71828@gmail.com)
|#



(in-package :cl-user)
(defpackage trivialib.rbtree-asd
  (:use :cl :asdf))
(in-package :trivialib.rbtree-asd)


(defsystem trivialib.rbtree
  :version "0.1"
  :author "Masataro Asai"
  :mailto "guicho2.71828@gmail.com"
  :license "LLGPL"
  :depends-on (:trivia :alexandria)
  :components ((:module "src"
                :components
                ((:file "package"))))
  :description "Red-Black tree implementation using Trivia, original code by m2ym"
  :in-order-to ((test-op (load-op :trivialib.rbtree.test))))
