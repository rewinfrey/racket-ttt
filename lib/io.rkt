#lang racket

(require racket/class)
(provide (all-defined-out))

(define io%
  (class object%

    (super-new)

    (define/public (input)
      (read-line))

    (define/public (output msg)
      (printf "~a~n" msg))

    (define/public (clear-screen)
      (printf "\e[2J \e[0;0H"))

    (define/public (output-board sq1 sq2 sq3)
      (printf " ~a | ~a | ~a ~n" sq1 sq2 sq3))))


