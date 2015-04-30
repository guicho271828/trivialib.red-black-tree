(in-package :cl-user)
(defpackage trivialib.red-black-tree
  (:use :cl :alexandria :trivia)
  (:shadowing-import-from :immutable-struct :defstruct :ftype)
  (:export :leaf
           :leaf-p
           :rb-tree
           :rb-node
           :rb-node-p
           :rb-node-color
           :rb-node-left
           :rb-node-label
           :rb-node-content
           :rb-node-right
           :red :black
           :rb-member
           :rb-member-node
           :rb-minimum-node
           :rb-minimum
           :rb-maximum-node
           :rb-maximum
           :rb-insert
           :rb-remove-minimum-node
           :rb-remove
           :rb-node-next-node
           :rb-node-previous-node
           :rb-member-node-after
           :rb-member-node-before
           :rb-member-after
           :rb-member-before
           :rb-remove-after
           :rb-remove-before
           :leafp))
