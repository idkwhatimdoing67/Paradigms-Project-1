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


; Number Parser, helper to Eval Function
; Consumes numeric chars, build list of digits
(define (parse-number chars acc-chars)
    (cond
    ; If list is empty, end of input
    ; Reverse digits, convert to string then to num
    ; Return list
    [(empty? chars) (list (string->number (list->string (reverse acc-chars))) '())]

    ; If next char is numeric, add




; Eval function, takes two params
; 'chars' (remaining list to parse), 'history' (list of previous results)
; Returns two elem list
(define (eval-expr chars history)
    (cond ; Branches to look at varying char

    [(empty? chars) (list #f '())] ; If list is empty, return false and empty list

    ;If first char is whitespace, recursively call eval-expr
    [(char-whitespace? (first chars)) (eval-expr (rest chars) history)]

    ; Currently return false for non whitespace/empty lists.  Temp build
    [else (list #f chars)]))



; Defines main loop function, takes two params
; 'history' (list of past results) & 'history-id' (counter)
(define (eval-loop history history-id)

    ; 'when' is an if statement, if prompt is true then we execute this when
    (when prompt?
        (display "> ")) ;Prints prompt indicator without newline
    
    (define input (read-line)) ; Read user's input from console as string/bind to 'input'

    (cond ; Use 'switch' statement to check what user inputted

        ; If input is "quit" then return
        [(string=? (string-trim input) "quit") (void)] ;Void does nothing and stops recursion for program exit

        [else ;Condition for all other inputs

            (define char-list (string->list input)) ; Converts input to a list of characters, easier to parse

            (define eval-result (eval-expr char-list history)) ; Call eval function, passes char list and current history
            ; Eval function returns two element list containing result and leftover chars

            (define result-val (first eval-result)) ; Extract first element from returned list (numerical result or #f is failed)
            (define remaining-chars (second eval-result)) ; Extract remaining chars

            (cond ; switch block to decide success/failure

                [(or (not result-val) (not (empty? remaining-chars)))
                ; 'or' checks if either condition is true
                ; not result val true if we received a failure (#f)
                ; not empty is true if there is unparsed text which is error

                    (displayln "Error: Invalid Expression") ; Error msg

                    (eval-loop history history-id)] ; Recursion calls for error state, invalid expression doesn't modify history
                
                [else ; Sucess branch, triggers only if valid result AND no remaining chars
                
                (displayln "Evlatuation successful! (Placeholder)") ; Temp placeholder text
                
                (eval-loop history history-id)])])) ; Recursive call

;Starts program for first time, pass empty list and 1 for initial params
(eval-loop '() 1)
