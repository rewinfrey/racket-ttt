#lang racket

(require rackunit
         rackunit/text-ui
         "test-helper.rkt")

(define game-tests
  (test-suite
    "Game tests"

    (test-suite
      "player-token tests"

      (test-case
        "returns x when current player is player1"
        (clear-board)
        (check-equal? (send test-game player-token) #\x))

      (test-case
        "returns o when current player is player2"
        (send test-board update "0" #\x)
        (check-equal? (send test-game player-token) #\o)))

    (test-case
      "#get-board: returns game board as a string"
      (clear-board)
      (check-equal? (send test-game get-board) "         "))

    (test-suite
      "move-num tests"

      (test-case
        "returns 0 when board is empty"
        (clear-board)
        (check-eq? (send test-game move-num) 0))

      (test-case
        "returns 1 after one move is made"
        (send test-board update "0" #\x)
        (check-eq? (send test-game move-num) 1)))

    (test-suite
      "valid-move?"

      (test-case
        "returns #t when submitted move is available on the board"
        (clear-board)
        (check-equal? (send test-game valid-move? "0") #t))

      (test-case
        "returns #f when submitted move is not available on the board"
        (send test-board update "0" #\x)
        (check-equal? (send test-game valid-move? "0") #f)))

    (test-case
      "#move: updates the board at the given square with the current player's token"
      (clear-board)
      (send test-game move "0")
      (check-equal? (string-ref (send test-game get-board) 0) #\x))

    (test-suite
      "next-move tests"

        (test-case
          "returns #f if current player is not ai"
          (clear-board)
          (to-draw-board)
          ;test-game's player2 is human
          (check-equal? (send test-game next-move) #f))

        (test-case
          "returns best move if current player is ai"
          ;test-game's player1 is ai
          (send test-game move "7")
          (check-equal? (send test-game next-move) "8")))

    (test-case
      "#get-help-board: returns string of board's open moves as integers and closed moves as -"
      ; current board state:
      ;  o | o | 2
      ; -----------
      ;  x | x | 5
      ; -----------
      ;  6 | 7 | 8
      (clear-board)
      (to-block-board)
      (to-win-board)
      (check-equal? (send test-game get-help-board) "--2--5678"))

    (test-suite
      "winner?"
      (test-case
        "returns winning player's token when the board has a winner"
        (clear-board)
        (to-win-board)
        (send test-game move "5")
        (check-equal? (send test-game winner?) #\x))

      (test-case
        "returns #f if board doesn't have a winner"
        (clear-board)
        (check-equal? (send test-game winner?) #f)))

    (test-suite
      "draw?"
      (test-case
        "returns #f if current board state is not a draw"
        (check-equal? (send test-game draw?) #f))

      (test-case
        "returns #t if current board state has draw"
        (to-draw-board)
        (send test-game move "7")
        (send test-game move "8")
        (check-equal? (send test-game draw?) #t)))

    (test-suite
      "finished?"
      (test-case
        "returns #t if current board state has winner or draw"
        (check-equal? (send test-game finished?) #t))

      (test-case
        "returns #f if current board state lacks winner or draw"
        (clear-board)
        (check-equal? (send test-game finished?) #f)))
  )
)

(run-tests game-tests)
