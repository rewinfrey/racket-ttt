#lang racket
(require racket/class)
(require  "io.rkt" "player.rkt" "human.rkt" "ai.rkt" "board.rkt" "game.rkt")
(provide cli%)

(define cli%
  (class object%
    (init in-io)
    (define io in-io)
    (super-new)

    (define/public (start)
      (clear-screen)
      (welcome-prompt)
      (let* ([selection    (game-selection)]
             [players-pair (make-players-pair-for selection)]
             [game         (new game% [in-player1 (car players-pair)] [in-player2 (cdr players-pair)] [in-board (new board%)])])
        (play game)))

    (define/public (play game)
      (output-game game (move-prompt game))
      (send game next-move)
      (cond
        [(send game finished?)
         (display-end-game game)
         (if (play-again?)
             (start)
             (clear-screen))]
        [else (play game)]))

;tested
    (define/public (display-end-game game)
        (if (send game winner?)
          (output-game game (winner-prompt game))
          (output-game game (draw-prompt))))

;tested
    (define/public (play-again?)
      (output "Would you like to play again? (y/n)")
      (let ([response (input)])
        (cond
          [(or (equal? "y" response) (equal? "Y" response))]
          [(or (equal? "n" response) (equal? "N" response)) #f]
          [else (play-again?)])))

;tested
    (define/public (get-square row-size)
      (lambda (board index offset)
        (string-ref board (+ offset (* index row-size)))))

;tested
    (define/public (welcome-prompt)
      (blank-line)
      (output "Welcome to Racket (Scheme) Tic Tac Toe!"))

;tested
    (define/public (menu)
      (blank-line)
      (output "Enter the number of the game mode you wish to play:")
      (output "1. Human vs. Human")
      (output "2. Human vs. Computer")
      (output "3. Computer vs. Human")
      (output "4. Computer vs. Computer")
      (blank-line)
      (output "Enter your selection: "))

;tested
    (define/public (validate-game-selection input)
      (cond
        [(equal? input "1") input]
        [(equal? input "2") input]
        [(equal? input "3") input]
        [(equal? input "4") input]
        [else (error-selection)
              (game-selection)]))

;tested
    (define/public (get-help-board game) (send game get-help-board))

;tested
    (define/public (game-selection)
      (menu)
      (validate-game-selection (input)))

    (define/public (make-human token)
      (new human% [in-token token] [in-move (human-move io)]))

    (define/public (make-ai token)
      (new ai% [in-token token]))

    (define/public (human-move io)
      (lambda (board)
        (define (get-move board)
          (send io output "Please enter your move:")
          (let ([move (send io input)])
            (cond
              [(send board valid-move? move) move]
              [else (send io output "\n")
                    (send io output "I'm sorry, you've choosen an invalid square. Please choose a number from the possible moves board.")
                    (send io output "\n")
                    (get-move board)])))
        (get-move board)))

;tested
    (define/public (make-players-pair-for selection)
      (cond
        [(equal? selection "1") (cons (make-human #\x) (make-human #\o))]
        [(equal? selection "2") (cons (make-human #\x) (make-ai #\o))]
        [(equal? selection "3") (cons (make-ai #\x)    (make-human #\o))]
        [(equal? selection "4") (cons (make-ai #\x)    (make-ai #\o))]))

;tested
    (define/public (move-prompt game)
      (let ([move-num (send game move-num)])
        (if (= 0 (modulo move-num 2))
          "x to move:"
          "o to move:")))

;tested
    (define/public (error-selection)
      (clear-screen)
      (blank-line)
      (output "I'm sorry, I didn't understand your selection.")
      (blank-line)
      (output "Please choose game mode 1, 2, 3 or 4"))

;tested
    (define/public (winner-prompt game)
      (let ([winner (send game winner?)])
      (~a "The winner is " winner "!")))

;tested
    (define/public (draw-prompt)
      "It's a draw!")

;tested
    (define/public (output-game game msg)
      (clear-screen)
      (output "Possible moves:")
      (output-board (get-help-board game))
      (output msg)
      (output-board (send game get-board)))

    ; io functions
    (define/public (output msg)
      (send io output msg))

;tested
    (define/public (output-board board)
      (let ([row-size 3])
      (blank-line)
      (for ([i 3])
           (send io output-board ((get-square row-size) board i 0) ((get-square row-size) board i 1) ((get-square row-size) board i 2))
           (if (< i 2)
             (output "-----------")
             (blank-line)))))

; tested
    (define/public (blank-line)
      (output ""))

; tested
    (define/public (clear-screen)
      (send io clear-screen))

; tested
    (define/public (input)
      (send io input))))
