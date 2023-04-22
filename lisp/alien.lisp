#+quicklisp (ql:quickload :cffi)
#+quicklisp (ql:quickload :split-sequence)

#+quicklisp
(cffi:define-foreign-library liblog
  (t (:default "liblog")))

#+quicklisp
(cffi:defcfun "__android_log_print" :int
  (priority log-priority)
  (tag :string)
  (control-string :string)
  &rest)

#+quicklisp
(cffi:defcenum log-priority
  :unknown
  :default
  :verbose
  :debug
  :info
  :warn
  :error
  :fatal
  :silent)

#+quicklisp
(defun log-and-die (condition hook)
  (declare (ignore hook))
  (--android-log-print :error "COMMON-LISP" (princ-to-string condition))
  (dolist (line (split-sequence:split-sequence
                 #\newline
                 (with-output-to-string (s)
                   (sb-debug:print-backtrace :stream s))))
    (--android-log-print :error "COMMON-LISP" line)))

(defparameter *clicks* 0)

(define-alien-callable hello sb-alien:c-string ()
  (format nil "Hello alien world! [clicks: ~a]"
          (incf *clicks*)))

;; SBCL will search for HELLO function in main program by default
;; Main program is Java program, so we need to load
;; the libhello-alien.so library at the startup.
(push (lambda ()
        #+quicklisp (cffi:load-foreign-library 'liblog)
        #+quicklisp (setf *debugger-hook* #'log-and-die)
        (sb-alien:load-shared-object "libhello-alien.so"))
      *init-hooks*)

(save-lisp-and-die "libcore.so" :callable-exports '(hello)
                                #+sb-core-compression :compression
                                #+sb-core-compression t)
