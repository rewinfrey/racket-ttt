#lang racket
(require rackunit
         rackunit/text-ui
         "tests/ai-test.rkt"
         "tests/board-test.rkt"
         "tests/cli-test.rkt"
         "tests/game-test.rkt"
         "tests/human-test.rkt"
         "tests/io-test.rkt"
         "tests/player-test.rkt")

(define (test-runner test)
  (let ([exit-status (run-tests test)])
    (if (= 0 exit-status)
      (printf "\n")
      (display exit-status))))

(test-runner player-tests)
(test-runner human-tests)
(test-runner ai-tests)
(test-runner board-tests)
(test-runner game-tests)
(test-runner io-tests)
(test-runner cli-tests)
