(defparameter *clicks* 0)

(define-alien-callable hello sb-alien:c-string ()
  (format nil "Hello alien world! [clicks: ~a]" (incf *clicks*)))

;; SBCL will search for HELLO function in main program by default
;; Main program is Java program, so we need to load
;; the lib.gleefre.wrap.so library at the startup.
(push (lambda ()
        ;; On older androids it is impossible to open a shared library and
        ;; get same handle as it is outside. We pass that handle manually
        ;; with pass_pointer_to_lisp and retrieve it with get-pointer-from-c.
        ;; So instead of simple (sb-alien:load-shared-object "lib.gleefre.wrap.so")
        ;; we need to manually add it into the internals of sbcl.
        (push (sb-alien::make-shared-object
               :pathname (pathname "lib.gleefre.wrap.so")
               :namestring "lib.gleefre.wrap.so"
               :handle (sb-alien::get-pointer-from-c)
               :dont-save t)
              sb-alien::*shared-objects*)
        ;; SBCL enables float traps at startup, but doesn't disable them when
        ;; initalize_lisp returns. So we do it here ourselves. Note: It might be
        ;; better to use sb-int:set-floating-point-modes.
        ;;
        ;; Also, SBCL doesn't enable float traps back when entering alien callbacks
        ;; either, so you might want to enable and disable them in callbacks too.
        (setf (sb-vm:floating-point-modes) (dpb 0 sb-vm:float-traps-byte (sb-vm:floating-point-modes))))
      *init-hooks*)

(save-lisp-and-die "lib.gleefre.core.so"
                   :callable-exports '(hello)
                   #+sb-core-compression :compression
                   #+sb-core-compression t)
