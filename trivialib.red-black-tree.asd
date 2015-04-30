#|
  This file is a part of trivialib.red-black-tree project.
  Copyright (c) 2015 Masataro Asai (guicho2.71828@gmail.com)
|#

#|
  Red-Black tree implementation using Trivia, original code by m2ym

  Author: Masataro Asai (guicho2.71828@gmail.com)
|#



(in-package :cl-user)
(defpackage trivialib.red-black-tree-asd
  (:use :cl :asdf))
(in-package :trivialib.red-black-tree-asd)


(defsystem trivialib.red-black-tree
  :version "0.1"
  :author "Masataro Asai"
  :mailto "guicho2.71828@gmail.com"
  :license "LLGPL"
  :depends-on (:trivia :alexandria)
  :pathname "src"
  :components
  ((:file "package")
   (:file "types")
   (:file "rb-tree"))
  :serial t
  :description "Red-Black tree implementation using Trivia, original code by m2ym"
  :in-order-to ((test-op (load-op :trivialib.red-black-tree.test))))
