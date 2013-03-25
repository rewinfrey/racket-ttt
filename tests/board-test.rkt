#lang racket

(require rackunit
         rackunit/text-ui
         "../lib/board.rkt"
         "test-helper.rkt")

(define board-tests
  (test-suite
    "Board tests"

    (test-case
      "#get-board: returns the game board"
      (clear-board)
      (check-equal? (send test-board get-board) "         "))

    (test-case
      "#update: updates the game board for a given square and a given token"
      (send test-board update "0" #\x)
      (check-equal? (send test-board get-board) "x        "))

    (test-suite
      "valid-move?"

      (test-case
        "returns #t if a move is valid"
        (check-equal? (send test-board valid-move? "1") #t))

      (test-case
        "returns #f if a move is invalid"
        (check-equal? (send test-board valid-move? "0") #f)))

    (test-case
      "#lookup-square: returns the requested game square"
      (check-equal? (send test-board lookup-square 0) #\x))

    (test-suite
      "count-moves"

      (test-case
        "returns 1 after one move is made"
        (check-eq? (send test-board count-moves) 1))

      (test-case
        "returns 2 after two moves are made"
        (send test-board update "1" #\o)
        (check-eq? (send test-board count-moves) 2)))

    (test-case
      "#available-moves: returns list of still valid moves"
      ; current board state:
      ;  x | o | 2
      ; -----------
      ;  3 | 4 | 5
      ; -----------
      ;  6 | 7 | 8
      (check-equal? (send test-board available-moves) '("2" "3" "4" "5" "6" "7" "8")))

    (test-suite
      "draw?"
      (test-case
        "returns #f if the board state is not a draw"
        ; current board state:
        ;  x | o | 2
        ; -----------
        ;  3 | 4 | 5
        ; -----------
        ;  6 | 7 | 8
        (check-equal? (send test-board draw?) #f))

      (test-case
        "returns #t if the board state is a draw"
        ; current board state:
        ;  x | o | 2
        ; -----------
        ;  3 | 4 | 5
        ; -----------
        ;  6 | 7 | 8
        (to-draw-board)
        (send test-board update "7" #\x)
        (send test-board update "8" #\o)
        (check-equal? (send test-board draw?) #t)))

    (test-suite
      "winner?"

      (test-case
        "returns false if the board state doesn't have a winner"
        ; current board state:
        ;  0 | 1 | 2
        ; -----------
        ;  3 | 4 | 5
        ; -----------
        ;  6 | 7 | 8
        (clear-board)
        (check-equal? (send test-board winner?) #f))

      (test-case
        "returns winning player token if the board state has a winner"
        ; current board state:
        ;  0 | 1 | 2
        ; -----------
        ;  x | x | x
        ; -----------
        ;  6 | 7 | 8
        (to-win-board)
        (send test-board update "5" #\x)
        (check-equal? (send test-board winner?) #\x)))

    (test-suite
      "get-help-board"

      (test-case
        "returns string of current board state with valid moves listed as numbers"
        ; current board state:
        ;  0 | 1 | 2
        ; -----------
        ;  3 | 4 | 5
        ; -----------
        ;  6 | 7 | 8
        (clear-board)
        (check-equal? (send test-board get-help-board) "012345678"))

      (test-case
        "returns string of current board state with invalid moves listed as -"
        ; current board state:
        ;  x | x | x
        ; -----------
        ;  x | x | x
        ; -----------
        ;  x | x | x
        (x-out-board)
        (check-equal? (send test-board get-help-board) "---------"))

      (test-case
        "returns string of both valid moves and invalid moves"
        ; current board state:
        ;  o | o | 2
        ; -----------
        ;  x | x | 5
        ; -----------
        ;  6 | 7 | 8
        (clear-board)
        (to-block-board)
        (to-win-board)
        (check-equal? (send test-board get-help-board) "--2--5678")))
  )
)

(run-tests board-tests)