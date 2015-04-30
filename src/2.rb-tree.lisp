(in-package :trivialib.red-black-tree)

(ftype rb-member real rb-tree t)
(defun rb-member (x tree)
  (when-let ((node (rb-member-node x tree)))
    (rb-node-content node)))

(ftype rb-member-node real rb-tree (or null rb-node))
(defun rb-member-node (x tree)
  (match tree
    ((leaf) nil)
    ((rb-node _ left label _ right)
     (cond ((< x label) (rb-member-node x left))
           ((> x label) (rb-member-node x right))
           (t           tree)))))


(ftype balance rb-tree rb-tree)
(defun balance (tree)
  (match tree
    ((or (black (red (red a x xc b) y yc c) z zc d)
         (black (red a x xc (red b y yc c)) z zc d)
         (black a x xc (red (red b y yc c) z zc d))
         (black a x xc (red b y yc (red c z zc d))))
     (red (black a x xc b) y yc (black c z zc d)))
    (otherwise tree)))

(ftype (rb-minimum-node rb-maximum-node)
       rb-tree (values (or null rb-tree)
                       (or null real)))
(defun rb-minimum-node (tree)
  (ematch tree
    ((rb-node _ (leaf) label _ _)
     (values tree label))
    ((rb-node _ left _ _ _)
     (rb-minimum-node left))
    ((leaf)
     (values nil nil))))

(defun rb-maximum-node (tree)
  (ematch tree
    ((rb-node _ _ label _ (leaf))
     (values tree label))
    ((rb-node _ _ _ _ right)
     (rb-maximum-node right))
    ((leaf)
     (values nil nil))))

(ftype (rb-minimum rb-maximum)
       rb-tree (values t (or real null)))

(defun rb-minimum (tree)
  (ematch tree
    ((rb-node _ (leaf) label content _)
     (values content label))
    ((rb-node _ left _ _ _)
     (rb-minimum left))
    ((leaf)
     (values nil nil))))

(defun rb-maximum (tree)
  (ematch tree
    ((rb-node _ _ label content (leaf))
     (values content label))
    ((rb-node _ _ _ _ right)
     (rb-maximum right))
    ((leaf)
     (values nil nil))))

(ftype rb-insert
       rb-tree real &optional t
       rb-node)
(defun rb-insert (tree x &optional (xc x))
  (labels ((ins (tree)
	     (match tree
	       ((leaf) (red (leaf) x xc (leaf)))
	       ((rb-node color left label content right)
		(cond
		  ((< x label)
		   (balance (rb-node color (ins left) label content right)))
		  ((> x label)
		   (balance (rb-node color left label content (ins right))))
		  (t (rb-node color left label xc right)))))))
    (ematch (ins tree)
      ((rb-node _ left label content right)
       (black left label content right)))))

(ftype rb-remove-minimum-node rb-tree (values rb-tree t (or real null)))
(defun rb-remove-minimum-node (tree)
  (let (min-label min-content)
    (labels
	((rec (tree)
	   (ematch tree
	     ((leaf) tree)
	     ((rb-node _ (leaf) label content right)
	      (setf min-label label
		    min-content content)
	      right)
	     ((rb-node color left label content right)
	      (balance (rb-node color (rec left) label content right))))))
      (values (rec tree)
	      min-content
	      min-label))))

(ftype rb-remove rb-tree real rb-tree)
(defun rb-remove (tree x)
  (labels
      ((rec (tree)
	 (match tree
           ((rb-node color left y content right)
	    (cond
              ((< x y)
               (if (leaf-p left)
                   (balance (rb-node color left y content right))
                   (balance (rb-node color (rec left) y content right))))
              ((= x y)
               ;; the node was found! the things in the left are smaller and
               ;; those in the right are larger than x
               (multiple-value-ematch (rb-remove-minimum-node right)
                 (((leaf) nil nil)
                  left)
                 ((subtree content label)
                  (balance
                   (rb-node color left label content subtree)))))
              ((> x y)
               (if (leaf-p right)
                   (balance (rb-node color left y content right))
                   (balance (rb-node color left y content (rec right))))))))))
    (declare (ftype (function (rb-node) rb-tree) rec))
    (if (typep tree 'leaf)
        tree
        (match (rec tree)
          ((and x (leaf)) x)
          ((rb-node _ left y content right)
           (black left y content right))))))

(defun rb-node-next-node (node tree)
  (match node
    ((rb-node _ _ _ _ (and right (type rb-node)))
     (rb-minimum-node right))
    (_ (%rb-node-next-node-rec node tree))))

(defun %rb-node-next-node-rec (node tree)
  (match tree
    ((leaf) tree)
    ((rb-node _ (guard left (eq (rb-maximum-node left) node)) _ _ _)
     tree)

    ((rb-node _ left label _ right)
     (match node
       ((rb-node _ _ x _ _)
	(cond ((< x label) (%rb-node-next-node-rec node left))
	      ((> x label) (%rb-node-next-node-rec node right))
	      (t right)))))))

(defun rb-node-previous-node (node tree)
  (match node
    ((rb-node _ (and left (type rb-node)) _ _ _)
     (rb-maximum-node left))
    (_ (%rb-node-previous-node-rec node tree))))

(defun %rb-node-previous-node-rec (node tree)
  (match tree
    ((leaf) tree)
    ((rb-node _ _ _ _ (guard right (eq (rb-minimum-node right) node)))
     tree)
    ((rb-node _ left label _ right)
     (match node
       ((rb-node _ _ x _ _)
	(cond ((< x label) (%rb-node-previous-node-rec node left))
	      ((> x label) (%rb-node-previous-node-rec node right))
	      (t left)))))))

(defun rb-member-node-after (x tree)
  (match tree
    ((leaf) tree)
    ((rb-node _ left label _ right)
     (cond ((< x label)
	    (match (rb-maximum-node left)
	      ((rb-node _ _ y _ _)
	       (if (< y x)
		   tree
		   (rb-member-node-after x left)))
	      (_ tree)))
           ((< label x)
	    (match (rb-minimum-node right)
	      ((and min (rb-node _ _ y _ _))
	       (if (< x y)
		   min
		   (rb-member-node-after x right)))
	      (_ tree)))
           (t
	    (rb-minimum-node right))))))

(defun rb-member-node-before (x tree)
  (match tree
    ((leaf) tree)
    ((rb-node _ left label _ right)
     (cond ((< x label)
	    (match (rb-maximum-node left)
	      ((and max (rb-node _ _ y _ _))
	       (if (< y x)
		   max
		   (rb-member-node-before x left)))
	      (_ tree)))
           ((< label x)
	    (match (rb-minimum-node right)
	      ((rb-node _ _ y _ _)
	       (if (< x y)
		   tree
		   (rb-member-node-before x right)))
	      (_ tree)))
           (t
	    (rb-maximum-node left))))))
(defun rb-member-after (x tree)
  (rb-node-content
   (rb-member-node-after x tree)))
(defun rb-member-before (x tree)
  (rb-node-content
   (rb-member-node-before x tree)))

(defun rb-remove-after (tree x)
  (match tree
    ((leaf) tree)
    ((rb-node color left label content right)
     (cond ((< x label)
	    (match (rb-maximum-node left)
	      ((rb-node _ _ y _ _)
	       (if (< y x)
		   left
		   (rb-remove-after left x)))
	      (_ (leaf))))
           ((< label x)
	    (match (rb-minimum-node right)
	      ((rb-node _ _ y _ _)
	       (if (< x y)
		   (balance (rb-node color left label content (leaf)))
		   (balance (rb-node color left label content 
				     (rb-remove-after right x)))))
	      (_ tree)))
           (t
	    (balance (rb-node color left label content (leaf))))))))

(defun rb-remove-before (tree x)
  (match tree
    ((leaf) tree)
    ((rb-node color left label content right)
     (cond ((< x label)
	    (match (rb-maximum-node left)
	      ((rb-node _ _ y _ _)
	       (if (< y x)
		   (balance (rb-node color (leaf) label content right))
		   (balance (rb-node color (rb-remove-before left x)
				     label content right))))
	      (_ (leaf))))
           ((< label x)
	    (match (rb-minimum-node right)
	      ((rb-node _ _ y _ _)
	       (if (< x y)
		   right
		   (rb-remove-before right x)))
	      (_ tree)))
           (t
	    (balance (rb-node color (leaf) label content right)))))))

