#lang racket

(require rackunit
         rackunit/text-ui
         "test-helper.rkt")

(provide player-tests)

(define player-tests
  (test-suite
    "Player tests"
    (display-suite "Player tests")

    (test-suite
      "get-token"
      (display-sub-suite "get-token")

      (test-case
        "returns x for player1"
        (display-case "returns x for player1")
        (check-equal? (send test-ai get-token) #\x))

      (test-case
        "returns o for player2"
        (display-case "returns o for player2")
        (check-equal? (send test-player get-token) #\o)))
  )
)
