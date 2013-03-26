#lang racket
(provide player%)

(define player%
  (class object%
    (init in-token)

    (define token in-token)

    (super-new)

    (define/public (get-token)
      token)

    (define/public (get-move board)
      void)))
