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

; Defines main loop function, takes two params
; 'history' (list of past results) & 'history-id' (counter)
(define (eval-loop history history-id)

    ; 'when' is an if statement, if prompt is true then we execute this when
    (when prompt?
        (display "> ")) ;Prints prompt indicator without newline
    
    (define input (read-line)) ; Read user's input from console as string/bind to 'input'

    (cond ; Use 'switch' statement to check what user inputted

        ; If input is "quit" then return
        [(string=? input "quit") (void)] ;Void does nothing and stops recursion for program exit

        [else ;Condition for all other inputs

            (displayln (string-append "You typed: " input)) ; Placeholder for testing

            ; Recursive call, call with same params to keep going
            (eval-loop history history-id)]))

;Starts program for first time, pass empty list and 1 for initial params
(eval-loop '() 1)
