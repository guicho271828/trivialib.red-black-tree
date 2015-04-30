#|
    incomplete
|#

(in-package :cl-user)
(defpackage :trivialib.red-black-tree.bench
  (:use :cl
        :iterate
        :trivialib.red-black-tree
        :fiveam
        :trivia :alexandria))
(in-package :trivialib.red-black-tree.bench)



(def-suite :trivialib.red-black-tree.bench)
(in-suite :trivialib.red-black-tree.bench)

;; run test with (run! test-name) 

(defparameter *tree* (leaf))

(test insert
  (finishes
    (time (iter (for i from 0 below 10000)
                (setf *tree* (rb-insert *tree* i))))))

(test retrieve
  (finishes
    (let ((data (iter (repeat 10000) (collect (random 10000) result-type 'vector))))
      (time
       (iter (for datum in-vector data)
             (unless (rb-member datum *tree*)
               (fail "not found")))))))

;; incomplete
;; (test rb-remove-max
;;   (iter (for i from 0 to 49)
;; 	(is (= i (rb-maximum (rb-remove-after *tree* i)))))
;;   (iter (for i from 0 to 49)
;; 	(is (= i (rb-minimum (rb-remove-before *tree* i))))))
