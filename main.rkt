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

    ; If next char is numeric, add it to accumulator (acc-chars)
    ; 'cons' adds to front, needs to be reversed
    [(char-numeric? (first chars)) (parse-number (rest chars) (cons (first chars) acc-chars))]

    ; If non-number, stop accumulating
    [else
        (list (string->number (list->string (reverse acc-chars))) chars)]))

; History lookup helper
(define (get-history-val id history)
    ; Reverse history since cons will build backwards
    (let ([rev-history (reverse history)])

    ; Check if requested id exists (between 1 and list len)
    (if (and (>= id 1) (<= id (length rev-history)))
        ; If ID is invalid return #f (false)
        (list-ref rev-history (- id 1)) #f))) ; Subtract for 0-based index




; Eval function, takes two params
; 'chars' (remaining list to parse), 'history' (list of previous results)
; Returns two elem list
(define (eval-expr chars history)
    (cond ; Branches to look at varying char

    [(empty? chars) (list #f '())] ; If list is empty, return false and empty list

    ;If first char is whitespace, recursively call eval-expr
    [(char-whitespace? (first chars)) (eval-expr (rest chars) history)]

    ; Math part of conditional, here on is where the math logic steps in
    [(char-numeric? (first chars)) (parse-number chars '())] ; Start with empty accumulator

    ; History lookup
    [(char=? (first chars) #\$) ; Eval first char as $
    ; Let* allows for defining local vars sequentially and using prior results
        (let* ([num-result (parse-number (rest chars) '())] ; Parse the ID following the '$'
            [id-val (first num-result)]                     ; The parsed integer ID.
            [rem-chars (second num-result)])                ; Remaining text after ID
        
            (if id-val
                (list (get-history-val id-val history) rem-chars) ; Fetch from history and return
                (list #f rem-chars)))] ; Fail if no valid num attached to $

    ; Minus (-)
    [(char=? (first chars) #\-) ; Evaluate first char as -
     (let* ([operand-result (eval-expr (rest chars) history)] ; Recursively evaluate the next token
            [op-val (first operand-result)]
            [rem-chars (second operand-result)])
       
       (if op-val
           (list (- op-val) rem-chars) ; Negate the valid value
           (list #f rem-chars)))] ; Fail if the operand evaluation failed.

    ; Addition (+)
    [(char=? (first chars) #\+)
     (let* ([left-res (eval-expr (rest chars) history)] ; Evaluate the left operand
            [left-val (first left-res)]
            [left-rem (second left-res)]) ; Leftovers after left operand is parsed.
       
       (if (not left-val)
           (list #f left-rem) ; Fail early if left operand is invalid.
           
           (let* ([right-res (eval-expr left-rem history)] ; Evaluate right operand using left's leftovers
                  [right-val (first right-res)]
                  [right-rem (second right-res)])
             
             (if (not right-val)
                 (list #f right-rem)
                 (list (+ left-val right-val) right-rem)))))] ; Add values and return right's leftovers
    
    ; Multiplication (*)
    [(char=? (first chars) #\*) ; Same code as addition just swapped symbol
     (let* ([left-res (eval-expr (rest chars) history)]
            [left-val (first left-res)]
            [left-rem (second left-res)])
       (if (not left-val)
           (list #f left-rem)
           (let* ([right-res (eval-expr left-rem history)]
                  [right-val (first right-res)]
                  [right-rem (second right-res)])
             (if (not right-val)
                 (list #f right-rem)
                 (list (* left-val right-val) right-rem)))))]
    
    ; Division (/)
    [(char=? (first chars) #\/) ; Same code as * just new symbol
     (let* ([left-res (eval-expr (rest chars) history)]
            [left-val (first left-res)]
            [left-rem (second left-res)])
       (if (not left-val)
           (list #f left-rem)
           (let* ([right-res (eval-expr left-rem history)]
                  [right-val (first right-res)]
                  [right-rem (second right-res)])

             ; Unique code here for zero checking     
             (if (not right-val)
                 (list #f right-rem)
                 (if (= right-val 0)
                     (list #f right-rem) ; Trigger an error if right operand is 0
                     (list (quotient left-val right-val) right-rem))))))] 

    ; If nothing else return fail
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

            (define char-list (string->list (string-trim input))) ; Converts input to a list of characters, easier to parse

            (define eval-result (eval-expr char-list history)) ; Call eval function, passes char list and current history
            ; Eval function returns two element list containing result and leftover chars

            ; TEMP Test
            (displayln eval-result)

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
