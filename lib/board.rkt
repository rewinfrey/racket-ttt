#lang racket
(require racket/class)

(provide board%)

(define board%
  (class object%
    (define board-size 9)
    (define gameboard (make-string board-size #\space))
    (define char-list '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8))
    (define win-lst '((0 1 2) (3 4 5) (6 7 8) (0 3 6) (1 4 7) (2 5 8) (0 4 8) (2 4 6)))

    (super-new)

    (define/public (get-board)
      gameboard)

    (define/public (update move token)
      (string-set! gameboard (string->number move) token))

    (define/public (valid-move? move)
      (cond
        [(empty? (string->list move)) #f]
        [(and (all-numeric? (string->list move))
              (> (length (string->list gameboard)) (string->number move))
              (equal? #\space (string-ref gameboard (string->number move)))) #t]
        [else #f]))

    (define/public (lookup-square index)
      (string-ref gameboard index))

    (define/public (count-moves)
      (length (remove* '(#\space) (string->list gameboard))))

    (define/public (available-moves)
      (remove* '(#f) (open-squares-list)))

    (define/public (draw?)
      (= board-size (count-moves)))

    (define/public (winner?)
      (check-winner win-lst))

    (define/public (get-help-board)
      (let ([result (make-string board-size #\-)])
        (for ([square gameboard]
              [board-index board-size]
              [move-option (take char-list board-size)])
          (cond
            [(equal? #\space square) (string-set! result board-index move-option)]
            [else #f]))
        result))

    ;private
    (define (all-numeric? lst)
      (cond
        [(empty? lst) #t]
        [(char-numeric? (car lst)) (all-numeric? (cdr lst))]
        [else #f]))

    (define (open-squares-list)
      (for/list ([index (length (string->list gameboard))]
                 [square gameboard])
        (if (equal? square #\space)
          (number->string index)
          #f)))

    (define (check-winner lst)
      (cond
        [(empty? lst) #f]
        [(and (equal? (lookup-square (first (car lst)))
                      (lookup-square (second (car lst))))
              (equal? (lookup-square (second (car lst)))
                      (lookup-square (third (car lst))))
              (not (equal? #\space (lookup-square (third (car lst)))))) (lookup-square (third (car lst)))]
        [else (check-winner (cdr lst))]))))
