(in-package :trivialib.red-black-tree)

; red-black-tree

(defvar +leaf+ '+leaf+)
(declaim (inline leaf))
(defun leaf () +leaf+)
(defpattern leaf () `(eq +leaf+))
(deftype leaf () `(eql +leaf+))
(deftype rb-tree ()
  `(or rb-node leaf))


(defstruct rb-node
  (color :red :type symbol)
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

(ftype (red black) t real t t rb-node)

(defun red (left label content right)
  (rb-node :red left label content right))
(defun black (left label content right)
  (rb-node :black left label content right))
(defpattern red (left label content right)
  `(rb-node :red ,left ,label ,content ,right))
(defpattern black (left label content right)
  `(rb-node :black ,left ,label ,content ,right))
