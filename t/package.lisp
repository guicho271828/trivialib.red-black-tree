#|
  This file is a part of trivialib.red-black-tree project.
  Copyright (c) 2015 Masataro Asai (guicho2.71828@gmail.com)
|#

(in-package :cl-user)
(defpackage :trivialib.red-black-tree.test
  (:use :cl
        :iterate
        :trivialib.red-black-tree
        :fiveam
        :trivia :alexandria))
(in-package :trivialib.red-black-tree.test)



(def-suite :trivialib.red-black-tree)
(in-suite :trivialib.red-black-tree)

;; run test with (run! test-name) 

(defparameter *tree* (leaf))

(iter (for i from 0 below 10000)
      (setf *tree* (rb-insert *tree* i)))

(test rb-tree
  (iter (for i below 50)
	(is (= i (rb-member i *tree*))))
  (is (= 0 (rb-minimum *tree*)))
  (is (= 49 (rb-maximum *tree*)))
  (iter (for i from 1 below 49)
	(is (= (1- i)
	       (rb-node-label
		(rb-node-previous-node
		 (rb-member-node i *tree*) *tree*))))
	(is (= (1+ i)
	       (rb-node-label
		(rb-node-next-node
		 (rb-member-node i *tree*) *tree*))))))

(test rb-remove
  (iter (for i from 0 to 49)
	(is (= i (rb-maximum (rb-remove-after *tree* i)))))
  (iter (for i from 0 to 49)
	(is (= i (rb-minimum (rb-remove-before *tree* i))))))
