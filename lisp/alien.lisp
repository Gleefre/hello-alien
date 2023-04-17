(defparameter *clicks* 0)

(define-alien-callable hello sb-alien:c-string ()
  (format nil "Hello alien world! [clicks: ~a]"
          (incf *clicks*)))

;; SBCL will search for HELLO function in main program by default
;; Main program is Java program, so we need to load
;; the libhello-alien.so library at the startup.
(push (lambda ()
        (sb-alien:load-shared-object "libhello-alien.so"))
      *init-hooks*)

(save-lisp-and-die "alien.core" :callable-exports '(hello))
