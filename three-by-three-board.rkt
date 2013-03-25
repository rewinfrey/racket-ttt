#lang racket
(require "board.rkt")
(provide three-by-three-board%)

(define three-by-three-board%
  (class board%

    (super-new)
    (inherit lookup-square)
    (inherit count-moves)
    (inherit get-board)
    (inherit draw?)
    (inherit update)
    (inherit valid-move?)
    (inherit available-moves)
    (inherit check-winner)
    (inherit get-help-board)

    (define win-lst '((0 1 2) (3 4 5) (6 7 8) (0 3 6) (1 4 7) (2 5 8) (0 4 8) (2 4 6)))

    (define/public (winner?)
      (check-winner win-lst))))
