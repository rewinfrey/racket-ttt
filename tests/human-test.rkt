#lang racket

(require rackunit
         rackunit/text-ui
         "test-helper.rkt")

(provide human-tests)

(define human-tests
  (test-suite
    "Human tests"
    (display-suite "Human tests")

    (test-case
      "#get-move: returns evaluation of provided move lambda"
      (display-sub-suite "get-move")
      (display-case "returns evaluation of provided move lambda")
      (check-equal? (send test-player get-move test-board) "1"))
  )
)
