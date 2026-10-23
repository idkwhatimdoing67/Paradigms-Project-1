#lang racket
; Tells interpreter to use standard Racket lang library/syntax rules

; Define prompt as a "function" name
; ? is Racket's way of defining output as a boolean
(define prompt?

    ; 'let' creates local scope and binds vars
    ; Calls current-cmd-line-args and assigns to local var 'args'
    ; Racket returns cmd line args as a Vector (fixed array)
    (let [(args (current-command-line-arguments))]
        (cond ; Racket's if/else or switch statement.  Allows to check conditionals
            [(= (vector-length args) 0) #t] ; If length of 'args' vector = 0

            ; vector-ref is a reference to the vector at index 0
            ; 'string=?' chesk if element matches "-b", if so then return false (#f)
            [(string=? (vector-ref args 0) "-b") #f]

            ; Same check as prior, only applying to if "--batch" rather than "-b"
            [(string=? (vector-ref args 0) "--batch") #f]

            ; Else, return true (#t)
            [else #t])))

; Test block for prompt
(if prompt?
    (displayln "Prompt ON") ; If true
    (displayln "Nuh uh")) ; If false
