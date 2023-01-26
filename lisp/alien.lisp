(define-alien-callable hello sb-alien:c-string ()
  "Hello alien world :/")

(save-lisp-and-die "alien.core" :callable-exports '(hello))
