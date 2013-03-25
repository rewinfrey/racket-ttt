#lang racket

(require racket/class)
(require "../lib/cli.rkt"
         "../lib/io.rkt")

(send (new cli% [in-io (new io%)]) start)

(printf "omg")
