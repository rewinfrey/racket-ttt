#lang racket

(require rackunit
         rackunit/text-ui
         "test-helper.rkt")

(define player-tests
  (test-suite
    "Player tests"

    (test-suite
      "get-token"

      (test-case
        "returns x for player1"
        (check-equal? (send test-ai get-token) #\x))

      (test-case
        "returns o for player2"
        (check-equal? (send test-player get-token) #\o)))

    (test-suite
      "best-move"

      (test-case
        "#best-move: returns false if player is human"
        (check-equal? (send test-player best-move test-board) #f))

      (test-case
        "returns move if player is ai"
        (clear-board)
        (to-win-board)
        (check-not-equal? (send test-ai best-move test-board) #f)))
  )
)

(run-tests player-tests)
