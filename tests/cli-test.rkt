#lang racket
(require rackunit
         rackunit/text-ui
         "test-helper.rkt"
         "../lib/human.rkt"
         "../lib/ai.rkt")

(provide cli-tests)

(define cli-tests
  (test-suite
    "CLI tests"
    (display-suite "CLI tests")

    (test-case
      "#output: sends string to output to io object"
      (display-sub-suite "output")
      (display-case "sends string to output to io object")
      (parameterize ([current-output-port output-buffer])
        (send test-cli output "test")
        (check-equal? (get-output-bytes output-buffer #t) #"test\n")))

    (test-case
      "#input: gets input from io object"
      (display-sub-suite "input")
      (display-case "gets input from io object")
      (let ([input-buffer (open-input-string "test\n")])
        (parameterize ([current-input-port input-buffer])
          (check-equal? (send test-cli input) "test"))))

    (test-case
      "#blank-line: outputs a blank line"
      (display-sub-suite "blank-line")
      (display-case "outputs a blank line")
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli blank-line)
        (check-equal? (get-output-string output-buffer)
                      blank-line-test)))

    (test-case
      "#clear-screen: sends clear screen message to io"
      (display-sub-suite "clear-screen")
      (display-case "sends clear screen message to io")
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli clear-screen)
        (check-equal? (get-output-string output-buffer)
                      clear-screen-test)))

    (test-case
      "#welcome-prompt: outputs welcome prompt string"
      (display-sub-suite "welcome-prompt")
      (display-case "outputs welcome prompt string")
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli welcome-prompt)
        (check-equal? (get-output-string output-buffer)
                      welcome-test)))

    (test-case
      "#menu: outputs menu options"
      (display-sub-suite "menu")
      (display-case "outputs menu options")
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli menu)
        (check-equal? (get-output-string output-buffer)
                      menu-test)))
    (test-case
      "#error-selection: outputs error message and prompts for valid menu selection"
      (display-sub-suite "error-selection")
      (display-case "outputs error message and prompts for valid menu selection")
      (reset output-buffer)
      (parameterize ([current-output-port output-buffer])
        (send test-cli error-selection)
        (check-equal? (get-output-string output-buffer)
                      error-selection-test)))

    (test-case
      "#output-board: sends board to io"
      (display-sub-suite "output-board")
      (display-case "sends board to io")
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
      (display-sub-suite "draw-prompt")
      (display-case "returns draw message")
      (check-equal? (send test-cli draw-prompt) draw-prompt-test))

    (test-suite
      "winner-prompt"
      (display-sub-suite "winner-prompt")

      (test-case
        "returns winner message for x when x is winner"
        (display-case "returns winner message for x when x is winner")
        (clear-board)
        (to-win-board)
        (send test-game move "5")
        (check-equal? (send test-cli winner-prompt test-game) winner-x-test))

      (test-case
        "returns winner message for o when o is winner"
        (display-case "returns winner message for o when o is winner")
        (clear-board)
        (to-block-board)
        (send test-game move "3")
        (send test-game move "2")
        (check-equal? (send test-cli winner-prompt test-game) winner-o-test)))

    (test-suite
      "human-move"
      (display-sub-suite "human-move")

      (test-case
        "prompts user for move and returns move if move is valid"
        (display-case "prompts user for move and returns move if move is valid")
        (clear-board)
        (reset output-buffer)
        (let ([input-buffer (open-input-string "0\n")]
              [move (send test-cli human-move test-io)])
          (parameterize ([current-output-port output-buffer]
                        [current-input-port input-buffer])
            (check-equal? (move test-board) "0")
            (check-equal? (get-output-string output-buffer) get-move-test))))


      (test-case
        "displays error message and reprompts for move if move is invalid"
        (display-case "displays error message and reprompts for move if move is invalid")
        (to-draw-board)
        (reset output-buffer)
        (let ([input-buffer (open-input-string "0\n7\n")]
              [move (send test-cli human-move test-io)])
          (parameterize ([current-output-port output-buffer]
                         [current-input-port input-buffer])
            (check-equal? (move test-board) "7")
            (check-equal? (get-output-string output-buffer)
                          (string-append get-move-test
                                         blank-line-test
                                         move-error-test
                                         blank-line-test
                                         get-move-test))))))

    (test-case
      "#output-game: outputs a help board and the current game-board"
      (display-sub-suite "output-game")
      (display-case "outputs a help board and the current game-board")
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
      (display-sub-suite "move-prompt")

      (test-case
        "returns 'x to move:' when current player is player1"
        (display-case "returns 'x to move:' when current player is player1")
        (check-equal? (send test-cli move-prompt test-game) x-prompt-test))

      (test-case
        "returns 'o to move:' when current player is player2"
        (display-case "returns 'o to move:' when current player is player2")
        (send test-game move "0")
        (check-equal? (send test-cli move-prompt test-game) o-prompt-test)))

    (test-suite
      "game-selection"
      (display-sub-suite "game-selection")

      (test-case
        "returns game mode selection if input is valid"
        (display-case "returns game mode selection if input is valid")
        (reset output-buffer)
        (let ([input-buffer (open-input-string "1\n")])
          (parameterize ([current-output-port output-buffer]
                         [current-input-port input-buffer])
            (check-equal? (send test-cli game-selection) "1"))))

      (test-case
        "prompts user with error message until valid selection is input"
        (display-case "prompts user with error message until valid selection is input")
        (reset output-buffer)
        (let ([input-buffer (open-input-string "not-valid\n1\n")])
          (parameterize ([current-output-port output-buffer]
                         [current-input-port input-buffer])
            (send test-cli game-selection)))))

    (test-case
      "#get-help-board: returns help board as string"
      (display-sub-suite "get-help-board")
      (display-case "returns help board as string")
      (clear-board)
      (check-equal? (send test-cli get-help-board test-game) "012345678"))

    (test-suite
      "make-players-pair-for"
      (display-sub-suite "make-players-pair-for")

      (test-case
        "returns '(human human) pair when game mode selection is 1"
        (display-case "returns '(human human) when game mode selection is 1")
        (let ([players-pair (send test-cli make-players-pair-for "1")])
          (check-true (is-a? (car players-pair) human%))
          (check-true (is-a? (cdr players-pair) human%))))

      (test-case
        "returns '(human ai) pair when game mode selection is 2"
        (display-case "returns '(human ai) pair when game mode selection is 2")
        (let ([players-pair (send test-cli make-players-pair-for "2")])
          (check-true (is-a? (car players-pair) human%))
          (check-true (is-a? (cdr players-pair) ai%))))

      (test-case
        "returns '(ai human) pair when game mode selection is 3"
        (display-case "returns '(ai human) pair when game mode selection is 3")
        (let ([players-pair (send test-cli make-players-pair-for "3")])
          (check-true (is-a? (car players-pair) ai%))
          (check-true (is-a? (cdr players-pair) human%))))

      (test-case
        "returns '(ai ai) pair when game mode selection is 4"
        (display-case "returns '(ai ai) pair when game mode selection is 4")
        (let ([players-pair (send test-cli make-players-pair-for "4")])
          (check-true (is-a? (car players-pair) ai%))
          (check-true (is-a? (cdr players-pair) ai%)))))

    (test-case
      "#get-square: returns the square at a given index in the board"
      (display-sub-suite "get-square")
      (display-case "returns the square at a given index in the board")
      (clear-board)
      (check-equal? ((send test-cli get-square 3) (send test-board get-board) 0 0) #\space)
      (send test-game move "0")
      (check-equal? ((send test-cli get-square 3) (send test-board get-board) 0 0) #\x)
      (send test-game move "1")
      (check-equal? ((send test-cli get-square 3) (send test-board get-board) 0 1) #\o))

    (test-suite
      "play-again?"
      (display-sub-suite "play-again?")

      (test-case
        "returns #f if the user chooses not to play again"
        (display-case "returns #f if the user chooses not to play again")
        (let ([input-buffer (open-input-string "n\n")])
        (parameterize ([current-input-port input-buffer]
                       [current-output-port output-buffer])
          (check-false (send test-cli play-again?)))))

      (test-case
        "returns #t if the user chooses to play again"
        (display-case "returns #t if the user chooses to play again")
        (let ([input-buffer (open-input-string "y\n")])
          (parameterize ([current-input-port input-buffer]
                         [current-output-port output-buffer])
            (check-true (send test-cli play-again?))))))

    (test-suite
      "display-end-game"
      (display-sub-suite "display-end-game")

      (test-case
        "displays 'The winner is x!' when x wins"
        (display-case "displays 'The winner is x!' when x wins")

        (clear-board)
        (reset output-buffer)
        (to-win-board)
        (send test-game move "5")
        (parameterize ([current-output-port output-buffer])
          (send test-cli display-end-game test-game)
          (check-equal? (get-output-string output-buffer) (output-game-test "The winner is x!" " 0 | 1 | 2 " " - | - | - " " 6 | 7 | 8 " "   |   |   " " x | x | x " "   |   |   "))))

      (test-case
        "displays 'The winner is o!' when o wins"
        (display-case "displays 'The winner is o!' when o wins")

        (clear-board)
        (reset output-buffer)
        (to-block-board)
        (send test-game move "3")
        (send test-game move "2")
        (parameterize ([current-output-port output-buffer])
          (send test-cli display-end-game test-game)
          (check-equal? (get-output-string output-buffer) (output-game-test "The winner is o!" " - | - | - " " - | 4 | 5 " " 6 | 7 | 8 " " o | o | o " " x |   |   " "   |   |   "))))

    (test-case
      "displays It's a draw! when game ends in draw"
      (display-case "displays 'It's a draw!' when game ends in draw")
      (clear-board)
      (reset output-buffer)
      (to-draw-board)
      (send test-game move "7")
      (send test-game move "8")
      (parameterize ([current-output-port output-buffer])
        (send test-cli display-end-game test-game)
        (check-equal? (get-output-string output-buffer) (output-game-test "It's a draw!" " - | - | - " " - | - | - " " - | - | - " " x | x | o " " o | o | x " " x | o | x ")))))

    (test-case
      "#start: sets up a new game and plays until game is finished"
      (display-sub-suite "start")
      (display-case "sets up a new game and plays until game is finished")

      (reset output-buffer)
      (let ([input-buffer (open-input-string "1\n0\n1\n3\n4\n6\nn\n")])
        (parameterize ([current-output-port output-buffer]
                      [current-input-port input-buffer])
         (send test-cli start)
         (check-equal? (get-output-string output-buffer)
                       (string-append clear-screen-test
                                      welcome-test
                                      menu-test
                                      (output-game-test x-prompt-test " 0 | 1 | 2 " " 3 | 4 | 5 " " 6 | 7 | 8 " "   |   |   " "   |   |   " "   |   |   ")
                                      get-move-test
                                      (output-game-test o-prompt-test " - | 1 | 2 " " 3 | 4 | 5 " " 6 | 7 | 8 " " x |   |   " "   |   |   " "   |   |   ")
                                      get-move-test
                                      (output-game-test x-prompt-test " - | - | 2 " " 3 | 4 | 5 " " 6 | 7 | 8 " " x | o |   " "   |   |   " "   |   |   ")
                                      get-move-test
                                      (output-game-test o-prompt-test " - | - | 2 " " - | 4 | 5 " " 6 | 7 | 8 " " x | o |   " " x |   |   " "   |   |   ")
                                      get-move-test
                                      (output-game-test x-prompt-test " - | - | 2 " " - | - | 5 " " 6 | 7 | 8 " " x | o |   " " x | o |   " "   |   |   ")
                                      get-move-test
                                      (output-game-test winner-x-test " - | - | 2 " " - | - | 5 " " - | 7 | 8 " " x | o |   " " x | o |   " " x |   |   ")
                                      play-again?-test
                                      clear-screen-test)))))
  )
)
