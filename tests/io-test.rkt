#lang racket

(require rackunit
         rackunit/text-ui
         "test-helper.rkt")

(define io-tests
  (test-suite
    "io tests"

    (test-case
      "#input: reads string input up to a new line character"
      (parameterize ([current-input-port test-input-buffer])
        (check-equal? (send test-io input) "test")))

    (test-case
      "#output: writes string to output port"
      (parameterize ([current-output-port output-buffer])
        (send test-io output "test")
        (check-equal? (get-output-bytes output-buffer #t) #"test\n")))

    (test-case
      "#output-board: writes board as string to output port"
      (parameterize ([current-output-port output-buffer])
        (send test-io output-board "0" "1" "2")
        (check-equal? (get-output-bytes output-buffer #t) #" 0 | 1 | 2 \n")))

    (test-case
      "#clear-screen: clears the screen and places cursor at top-left of screen"
      (parameterize ([current-output-port output-buffer])
        (send test-io clear-screen)
        (check-equal? (get-output-bytes output-buffer #t) #"\e[2J \e[0;0H")))
  )
)

(run-tests io-tests)
