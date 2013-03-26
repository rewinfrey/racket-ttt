#lang racket

(require rackunit
         rackunit/text-ui
         "test-helper.rkt")

(provide ai-tests)

(define ai-tests
  (test-suite
  "AI tests"
  (display-suite "AI tests")

  ; board map:
  ;  0 | 1 | 2
  ; -----------
  ;  3 | 4 | 5
  ; -----------
  ;  6 | 7 | 8

  (test-suite
    "get-move tests"
    (display-sub-suite "get-move")

    (test-case
       "Identifies draw"
       (display-case "identifies draw")
       ; ai is x, should identify square 7 or 8 as draw
       ;  x | x | o
       ; -----------
       ;  o | o | x
       ; -----------
       ;  x | 7 | 8
       (check-equal? (send test-ai get-move (to-draw-board)) (or "7"
                                                                  "8")))
     (test-case
       "Blocks opponent win"
       (display-case "blocks opponent win")
       ; ai is x, should identify square 2 as best move
       ;  o | o | 2
       ; -----------
       ;    |   |
       ; -----------
       ;    |   |
       (clear-board)
       (check-equal? (send test-ai get-move (to-block-board)) "2"))

     (test-case
       "Identifies win"
       (display-case "identifies win")
       ; ai is x, should identify square 5 as best move
       ;    |   |
       ; -----------
       ;  x | x | 5
       ; -----------
       ;    |   |
       (check-equal? (send test-ai get-move (to-win-board)) "5"))

     (test-case
       "Prioritizes win over block"
       (display-case "prioritizes win over block")
       ; ai is x, should identify win with square 5 as better than block in square 2
       ;  o | o | 2
       ; -----------
       ;  x | x | 5
       ; -----------
       ;    |   |
       (check-equal? (send test-ai get-move test-board) "5"))

     (test-case
       "Prevents opponent from creating a fork"
       (display-case "prevents opponent from creating a fork")
       ; ai is x, should identify square 4 as best move
       ;  o |   |
       ; -----------
       ;    | 4 |
       ; -----------
       ;    |   |
       (clear-board)
       (to-fork-board)
       (check-equal? (send test-ai get-move test-board) "4"))
    )

  (test-case
    "Returns player token"
    (display-sub-suite "get-token")
    (display-case "returns player-token")
    (check-equal? (send test-ai get-token) #\x))
  )
)
