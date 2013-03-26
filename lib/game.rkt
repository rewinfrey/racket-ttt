#lang racket
(provide game%)

(define game%
  (class object%
    (init in-player1)
    (init in-player2)
    (init in-board)

    (define player1 in-player1)
    (define player2 in-player2)
    (define gameboard in-board)

    (super-new)

    (define/public (player-token)
      (send (current-player) get-token))

    (define/public (get-board)
      (send gameboard get-board))

    (define/public (move-num)
      (send gameboard count-moves))

    (define/public (move user-move)
      (send gameboard update user-move (player-token)))

    (define/public (next-move)
      (move (send (current-player) get-move gameboard)))

    (define/public (get-help-board)
      (send gameboard get-help-board))

    (define/public (winner?)
      (send gameboard winner?))

    (define/public (draw?)
      (send gameboard draw?))

    (define/public (finished?)
      (or (winner?)
          (draw?)))

    ;private
    (define (current-player)
     (if (= 0 (modulo (move-num) 2))
       player1
       player2))))
