#lang racket
(require "player.rkt")
(provide ai%)

(define ai%
  (class player%
    (super-new)

    (inherit get-token)

    (define/override (get-move board)
      (let* ([result (minimax 0 1 (get-token) board)])
        (sleep 0.5)
        (cdr (argmax car result))))

    ; private
    (define (minimax ply me my-token board)
      (for/list ([current-move (available-moves board)])
        (cond
          [(= 9 (length (available-moves board)))
           (cons 1000 (car (shuffle (available-moves board))))]
          [else
            (update board current-move my-token)
            (cond
              [(has-winner? board)
                 (undo board current-move)
                 (score-win ply me current-move)]
              [(has-draw? board)
                 (undo board current-move)
                 (score-draw current-move)]
              [else
                 (let ([scores (minimax (+ 1 ply) (- me) (opposite my-token) board)])
                   (undo board current-move)
                   (find-best-score-for scores current-move me))])])))

    (define (available-moves board)
      (send board available-moves))

    (define (update board move token)
      (send board update move token))

    (define (undo board move)
      (update board move #\space))

    (define (has-winner? board)
      (send board winner?))

    (define (has-draw? board)
      (send board draw?))

    (define (score-win ply me move)
      (if (= me 1)
        (cons (- 9999 ply) move)
        (cons (+ -9999 ply) move)))

    (define (score-draw move)
      (cons 0 move))

    (define (find-best-score-for scores move me)
      (if (= me 1)
        (cons (car (argmin car scores)) move)
        (cons (car (argmax car scores)) move)))

    (define (opposite token)
      (if (equal? #\x token)
        #\o
        #\x))))
