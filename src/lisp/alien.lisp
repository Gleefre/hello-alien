(defparameter *clicks* 0)

(define-alien-callable hello sb-alien:c-string ()
  (format nil "Hello alien world! [clicks: ~a]"
          (incf *clicks*)))

;; SBCL will search for HELLO function in main program by default
;; Main program is Java program, so we need to load
;; the libhello-alien.so library at the startup.
(push (lambda ()
        ;; On older androids it is impossible to open shared library and
        ;; get same handle as it is outside. We pass that handle manually
        ;; with pass_pointer_to_lisp and retrieve it with get-pointer-from-c.
        ;; So instead of simple (sb-alien:load-shared-object "libhello-alien.so")
        ;; we need to manually add it into the internals of sbcl.
        (push (sb-alien::make-shared-object
               :pathname (pathname "libhello-alien.so")
               :namestring "libhello-alien.so"
               :handle (sb-alien::get-pointer-from-c)
               :dont-save t)
              sb-alien::*shared-objects*))
      *init-hooks*)

(save-lisp-and-die "libcore.so" :callable-exports '(hello)
                                #+sb-core-compression :compression
                                #+sb-core-compression t)
