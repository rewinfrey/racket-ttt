#lang racket
(require rackunit
         rackunit/text-ui
         "test-helper.rkt"
         "../lib/player.rkt"
         "../lib/ai.rkt")

(provide cli-tests)

(define cli-tests
  (test-suite
    "cli-interface tests"

    (test-case
      "#output: sends string to output to io object"
      (parameterize ([current-output-port output-buffer])
        (send test-cli output "test")
        (check-equal? (get-output-bytes output-buffer #t) #"test\n")))

    (test-case
      "#input: gets input from io object"
      (parameterize ([current-input-port test-input-buffer])
        (check-equal? (send test-cli input) "test")))

    (test-case
      "#blank-line: outputs a blank line"
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli blank-line)
        (check-equal? (get-output-string output-buffer)
                      blank-line-test)))

    (test-case
      "#clear-screen: sends clear screen message to io"
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli clear-screen)
        (check-equal? (get-output-string output-buffer)
                      clear-screen-test)))

    (test-case
      "#welcome-prompt: outputs welcome prompt string"
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli welcome-prompt)
        (check-equal? (get-output-string output-buffer)
                      welcome-test)))

    (test-case
      "#menu: outputs menu options"
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli menu)
        (check-equal? (get-output-string output-buffer)
                      menu-test)))
    (test-case
      "#error-selection: outputs error message and prompts for valid menu selection"
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli error-selection)
        (check-equal? (get-output-string output-buffer)
                      error-selection-test)))

    (test-case
      "#output-board: sends board to io"
      (clear-board)
      (to-block-board)
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli output-board (send test-board get-board))
        (check-equal? (get-output-string output-buffer)
                      (output-board-test " o | o |   "
                                         "   |   |   "
                                         "   |   |   "))))

    (test-case
      "#draw-prompt: returns draw message"
      (check-equal? (send test-cli draw-prompt) draw-prompt-test))

    (test-suite
      "winner-prompt"

      (test-case
        "returns winner message for x when x is winner"
        (clear-board)
        (to-win-board)
        (send test-game move "5")
        (check-equal? (send test-cli winner-prompt test-game) winner-x-test))

      (test-case
        "returns winner message for o when o is winner"
        (clear-board)
        (to-block-board)
        (send test-game move "3")
        (send test-game move "2")
        (check-equal? (send test-cli winner-prompt test-game) winner-o-test)))

    (test-suite
      "valid-move?"

      (test-case
        "returns #f if move is invalid"
        (clear-board)
        (to-draw-board)
        (check-equal? (send test-cli valid-move? test-game "0") #f))

      (test-case
        "returns #t if move is valid"
        (check-equal? (send test-cli valid-move? test-game "8") #t)))

    (test-suite
      "get-move"

      (test-case
        "prompts user for move and returns move if move is valid"
        (clear-board)
        (reset output-buffer)
        (let ([input-buffer (open-input-string "0\n")])
          (parameterize ([current-output-port output-buffer]
                        [current-input-port input-buffer])
            (check-equal? (send test-cli get-move test-game) "0")
            (check-equal? (get-output-string output-buffer) get-move-test))))


      (test-case
        "displays error message and reprompts for move if move is invalid"
        (to-draw-board)
        (reset output-buffer)
        (let ([input-buffer (open-input-string "0\n7\n")])
          (parameterize ([current-output-port output-buffer]
                         [current-input-port input-buffer])
            (check-equal? (send test-cli get-move test-game) "7")
            (check-equal? (get-output-string output-buffer)
                          (string-append get-move-test
                                         move-error-test
                                         get-move-test))))))

    (test-case
      "#output-game: outputs a help board and the current game-board"
      (reset output-buffer)
      (clear-board)
      (parameterize ([current-output-port output-buffer])
        (send test-cli output-game test-game "test")
        (check-equal? (get-output-string output-buffer)
                      (output-game-test "test"
                                        " 0 | 1 | 2 "
                                        " 3 | 4 | 5 "
                                        " 6 | 7 | 8 "
                                        "   |   |   "
                                        "   |   |   "
                                        "   |   |   "))))

    (test-suite
      "move-prompt"

      (test-case
        "returns 'x to move:' when current player is player1"
        (check-equal? (send test-cli move-prompt test-game) x-prompt-test))

      (test-case
        "returns 'o to move:' when current player is player2"
        (send test-game move "0")
        (check-equal? (send test-cli move-prompt test-game) o-prompt-test)))

    (test-suite
      "game-selection"

      (test-case
        "returns game mode selection if input is valid"
        (reset output-buffer)
        (let ([input-buffer (open-input-string "1\n")])
          (parameterize ([current-output-port output-buffer]
                         [current-input-port input-buffer])
            (check-equal? (send test-cli game-selection) "1"))))

      (test-case
        "prompts user with error message until valid selection is input"
        (reset output-buffer)
        (let ([input-buffer (open-input-string "not-valid\n1\n")])
          (parameterize ([current-output-port output-buffer]
                         [current-input-port input-buffer])
            (send test-cli game-selection)))))

    (test-case
      "#get-help-board: returns help board as string"
      (clear-board)
      (check-equal? (send test-cli get-help-board test-game) "012345678"))

    (test-suite
      "make-players-pair-for"

      (test-case
        "returns human player human player pair when game mode selection is 1"
        (let ([players-pair (send test-cli make-players-pair-for "1")])
          (check-true (is-a? (car players-pair) player%))
          (check-true (is-a? (cdr players-pair) player%))))

      (test-case
        "returns human player computer player pair when game mode selection is 2"
        (let ([players-pair (send test-cli make-players-pair-for "2")])
          (check-true (is-a? (car players-pair) player%))
          (check-true (is-a? (cdr players-pair) ai%))))

      (test-case
        "returns computer player human player pair when game mode selection is 3"
        (let ([players-pair (send test-cli make-players-pair-for "3")])
          (check-true (is-a? (car players-pair) ai%))
          (check-true (is-a? (cdr players-pair) player%))))

      (test-case
        "returns computer player computer player pair when game mode selection is 4"
        (let ([players-pair (send test-cli make-players-pair-for "4")])
          (check-true (is-a? (car players-pair) ai%))
          (check-true (is-a? (cdr players-pair) ai%)))))

    (test-case
      "#get-square: returns the square at a given index in the board"
      (clear-board)
      (check-equal? ((send test-cli get-square 3) (send test-board get-board) 0 0) #\space)
      (send test-game move "0")
      (check-equal? ((send test-cli get-square 3) (send test-board get-board) 0 0) #\x)
      (send test-game move "1")
      (check-equal? ((send test-cli get-square 3) (send test-board get-board) 0 1) #\o))

    (test-case
      "#play-again?: asks user if they would like to play again"
      (reset output-buffer)
      (let ([input-buffer (open-input-string "exit")])
      (parameterize ([current-output-port output-buffer]
                     [current-input-port input-buffer])
        (send test-cli play-again?)
        (check-equal? (get-output-string output-buffer) play-again?-test))))



  )
)

(run-tests cli-tests)
