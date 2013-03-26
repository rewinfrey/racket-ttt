#lang racket
(require "player.rkt")
(provide human%)

(define human%
  (class player%
    (init in-move)
    (define move in-move)

    (super-new)
    (inherit get-token)

    (define/override (get-move board)
      (move board))))
