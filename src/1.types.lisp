(in-package :trivialib.red-black-tree)

; red-black-tree

(declaim (inline leaf rb-node red black))

(defconstant +leaf+ 1193941380623146742) ;; magic number
(defun leaf () +leaf+)
(deftype leaf () `(eql ,+leaf+))

(deftype rb-tree ()
  `(or rb-node leaf))

(defconstant +red+ 0)
(defconstant +black+ 1)

(defstruct rb-node
  (color +red+ :type bit)
  (left (leaf) :type rb-tree)
  (label 0 :type real)
  content
  (right (leaf) :type rb-tree))

;; (defmethod print-object ((o %leaf) s)
;;   (format s "LEAF"))

(defmethod print-object ((o rb-node) s)
  (match o
    ((rb-node color left label content right)
     (write (list color label content
		  left right) :stream s))))

(ftype red t real t t rb-node)
(defun red (left label content right)
  (rb-node +red+ left label content right))
(ftype black t real t t rb-node)
(defun black (left label content right)
  (rb-node +black+ left label content right))


(defpattern leaf () +leaf+)
(defpattern rb-node (color left label content right)
  `(class rb-node :color ,color :left ,left :label ,label :content ,content :right ,right))
(defpattern red (left label content right)
  `(rb-node +red+ ,left ,label ,content ,right))
(defpattern black (left label content right)
  `(rb-node +black+ ,left ,label ,content ,right))

