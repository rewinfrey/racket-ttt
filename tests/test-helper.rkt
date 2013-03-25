#lang racket

(require "../lib/io.rkt"
         "../lib/player.rkt"
         "../lib/ai.rkt"
         "../lib/board.rkt"
         "../lib/game.rkt"
         "../lib/cli.rkt")

(provide (all-defined-out))

(define test-board  (new board%))
(define test-ai     (new ai% [in-token #\x]))
(define win-lst    '((0 1 2) (3 4 5) (6 7 8) (0 3 6) (1 4 7) (2 5 8) (0 4 8) (2 4 6)))
(define test-player (new player% [in-token #\o]))
(define test-game   (new game% [in-player1 test-ai] [in-player2 test-player] [in-board test-board]))
(define test-io     (new io%))
(define test-cli    (new cli% [in-io test-io]))

(define output-buffer
  (open-output-string))

(define test-input-buffer
  (open-input-string "test\n"))

(define (reset port)
  (get-output-bytes port #t))

(define (port-splitter port)
  (let ([output (get-output-string port)])
    (string-split output)))

(define (contains? elem lst)
  (cond
    [(member elem lst) #t]
    [else #f]))

(define full-human-human-game-io
  (open-input-string "1\n0\n1\n3\n4\n5\nn\n"))

(define (to-block-board)
  (send test-board update "0" #\o)
  (send test-board update "1" #\o)
  test-board)

(define (to-win-board)
  (send test-board update "3" #\x)
  (send test-board update "4" #\x)
  test-board)

(define (to-draw-board)
  (send test-board update "0" #\x)
  (send test-board update "1" #\x)
  (send test-board update "2" #\o)
  (send test-board update "3" #\o)
  (send test-board update "4" #\o)
  (send test-board update "5" #\x)
  (send test-board update "6" #\x)
  test-board)

(define (x-out-board)
  (send test-board update "0" #\x)
  (send test-board update "1" #\x)
  (send test-board update "2" #\x)
  (send test-board update "3" #\x)
  (send test-board update "4" #\x)
  (send test-board update "5" #\x)
  (send test-board update "6" #\x)
  (send test-board update "7" #\x)
  (send test-board update "8" #\x)
  test-board)

(define (to-fork-board)
  (send test-board update "0" #\o))

(define (clear-board)
  (for ([i '("0" "1" "2" "3" "4" "5" "6" "7" "8")])
    (send test-board update i #\space)))

(define output-help-board
  (string-append "\n"
                 " 0 | 1 | 2 "
                 "\n-----------\n"
                 " 3 | 4 | 5 "
                 "\n-----------\n"
                 " 6 | 7 | 8 "
                 "\n\n"))

(define output-board
  (string-append "\n"
                 "   |   |   "
                 "\n-----------\n"
                 "   |   |   "
                 "\n-----------\n"
                 "   |   |   "
                 "\n\n"))

(define menu
  (string-append "\n"
                 "Enter the number of the game mode you wish to play:\n"
                 "1. Human vs. Human\n"
                 "2. Human vs. Computer\n"
                 "3. Computer vs. Human\n"
                 "4. Computer vs. Computer\n"
                 "\n"
                 "Enter your selection: \n"))


(define clear-screen-test
  "\e[2J \e[0;0H")

(define x-prompt-test
  "x to move:")

(define o-prompt-test
  "o to move:")

(define blank-line-test
  "\n")

(define draw-prompt-test
  "It's a draw!")

(define winner-x-test
  "The winner is x!")

(define winner-o-test
  "The winner is o!")

(define welcome-test
  (string-append blank-line-test
                 "Welcome to Racket (Scheme) Tic Tac Toe!\n"))

(define error-selection-test
  (string-append clear-screen-test
                 blank-line-test
                 "I'm sorry, I didn't understand your selection.\n"
                 blank-line-test
                 "Please choose game mode 1, 2, 3 or 4\n"))

(define menu-test
  (string-append blank-line-test
                 "Enter the number of the game mode you wish to play:\n"
                 "1. Human vs. Human\n"
                 "2. Human vs. Computer\n"
                 "3. Computer vs. Human\n"
                 "4. Computer vs. Computer\n"
                 blank-line-test
                 "Enter your selection: \n"))

(define get-move-test
  "Please enter your move:\n")

(define move-error-test
  (string-append blank-line-test
                 "I'm sorry, you've choosen an invalid square. Please choose a number from the possible moves board.\n"
                 blank-line-test))

(define row-spacer-test
  "\n-----------\n")

(define (output-board-test row1 row2 row3)
  (string-append blank-line-test
                 row1
                 row-spacer-test
                 row2
                 row-spacer-test
                 row3
                 blank-line-test
                 blank-line-test))

(define (output-game-test msg help-row1 help-row2 help-row3 row1 row2 row3)
  (string-append clear-screen-test
                 "Possible moves:\n"
                 (output-board-test help-row1 help-row2 help-row3)
                 msg
                 blank-line-test
                 (output-board-test row1 row2 row3)))

(define play-again?-test
  "Would you like to play again? (y\n)\n")
