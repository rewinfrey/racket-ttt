#lang racket

(require rackunit
         rackunit/text-ui
         "test-helper.rkt")

(provide game-tests)

(define game-tests
  (test-suite
    "Game tests"
    (display-suite "Game tests")

    (test-suite
      "player-token tests"
      (display-sub-suite "player-token")

      (test-case
        "returns x when current player is player1"
        (display-case "returns x when current player is player1")
        (clear-board)
        (check-equal? (send test-game player-token) #\x))

      (test-case
        "returns o when current player is player2"
        (display-case "returns o when current player is player2")
        (send test-board update "0" #\x)
        (check-equal? (send test-game player-token) #\o)))

    (test-case
      "#get-board: returns game board as a string"
      (display-sub-suite "get-board")
      (display-case "returns game board as a string")
      (clear-board)
      (check-equal? (send test-game get-board) "         "))

    (test-suite
      "move-num tests"
      (display-sub-suite "move-num")

      (test-case
        "returns 0 when board is empty"
        (display-case "returns 0 when board is empty")
        (clear-board)
        (check-eq? (send test-game move-num) 0))

      (test-case
        "returns 1 after one move is made"
        (display-case "returns 1 after one move is made")
        (send test-board update "0" #\x)
        (check-eq? (send test-game move-num) 1)))

    (test-case
      "#move: updates the board at the given square with the current player's token"
      (display-sub-suite "move")
      (display-case "updates the board at the given square with the current player's token")
      (clear-board)
      (send test-game move "0")
      (check-equal? (string-ref (send test-game get-board) 0) #\x))

    (test-suite
      "next-move tests"
      (display-sub-suite "next-move")

        (test-case
          "invokes human move lambda if current player is not ai and sets the move"
          (display-case "invokes human move lambda if current player is not ai and sets the move")
          (clear-board)
          (send test-game move "0")
          (send test-game next-move)
          (check-equal? (send test-game get-board) "xo       "))

        (test-case
          "returns best move if current player is ai and sets the move"
          (display-case "returns best move if current player is ai and sets the move")
          (clear-board)
          (to-block-board)
          (to-win-board)
          (send test-game next-move)
          (check-equal? (send test-game get-board) "oo xxx   ")))

    (test-case
      "#get-help-board: returns string of board's open moves as integers and closed moves as -"
      (display-sub-suite "get-help-board")
      (display-case "returns string of board's open moves as integers and closed moves as -")
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
      (display-sub-suite "winner?")
      (test-case
        "returns winning player's token when the board has a winner"
        (display-case "returns winning player's token when the board has a winner")
        (clear-board)
        (to-win-board)
        (send test-game move "5")
        (check-equal? (send test-game winner?) #\x))

      (test-case
        "returns #f if board doesn't have a winner"
        (display-case "returns #f if board doesn't have a winner")
        (clear-board)
        (check-equal? (send test-game winner?) #f)))

    (test-suite
      "draw?"
      (display-sub-suite "draw?")
      (test-case
        "returns #f if current board state is not a draw"
        (display-case "returns #f if current board state is not a draw")
        (check-equal? (send test-game draw?) #f))

      (test-case
        "returns #t if current board state has draw"
        (display-case "returns #t if current board state is not a draw")
        (to-draw-board)
        (send test-game move "7")
        (send test-game move "8")
        (check-equal? (send test-game draw?) #t)))

    (test-suite
      "finished?"
      (display-sub-suite "finished?")

      (test-case
        "returns #t if current board state has winner or draw"
        (display-case "returns #t if current board state has winner or draw")
        (check-equal? (send test-game finished?) #t))

      (test-case
        "returns #f if current board state lacks winner or draw"
        (display-case "returns #f if current board state lacks winner or draw")
        (clear-board)
        (check-equal? (send test-game finished?) #f)))
  )
)
