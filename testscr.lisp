
(in-package :cl-user)

(uiop:quit (if (handler-case
                   (progn
                     (asdf:load-system :trivialib.red-black-tree.test)
                     (eval (read-from-string "(every #'fiveam::TEST-PASSED-P (5am:run! :trivialib.red-black-tree))"))
)
                 (serious-condition (c)
                   (describe c)
                   (uiop:quit 2)))
               0 1))


