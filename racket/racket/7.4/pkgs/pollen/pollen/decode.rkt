#lang racket/base
(require xml
         txexpr/base
         racket/list
         racket/match
         sugar/list
         sugar/define
         sugar/test
         "setup.rkt"
         "private/splice.rkt"
         "unstable/typography.rkt")

(provide (all-from-out "unstable/typography.rkt")) ; bw compat, includes `whitespace?`

(define (->list/tx x)
  ;; same as ->list but catches special case of single txexpr,
  ;; which is itself a list, but in this case should be wrapped into a list,
  ;; for use with append-map.
  (cond
    [(txexpr? x) (list x)]
    [(list? x) x]
    [else (list x)]))

(define decode-proc-output-contract (or/c txexpr-element? txexpr-elements?))

;; decoder wireframe
(define+provide/contract (decode tx-in
                                 #:txexpr-tag-proc [txexpr-tag-proc values]
                                 #:txexpr-attrs-proc [txexpr-attrs-proc values]
                                 #:txexpr-elements-proc [txexpr-elements-proc values]
                                 #:txexpr-proc [txexpr-proc values]
                                 #:block-txexpr-proc [block-txexpr-proc values]
                                 #:inline-txexpr-proc [inline-txexpr-proc values]
                                 #:string-proc [string-proc values]
                                 #:entity-proc [entity-proc values]
                                 #:cdata-proc [cdata-proc values]
                                 #:exclude-tags [excluded-tags empty]
                                 #:exclude-attrs [excluded-attrs empty])
  ((xexpr/c)  
   (#:txexpr-tag-proc (txexpr-tag? . -> . txexpr-tag?)
    #:txexpr-attrs-proc (txexpr-attrs? . -> . txexpr-attrs?)
    #:txexpr-elements-proc (txexpr-elements? . -> . txexpr-elements?)
    #:txexpr-proc (txexpr? . -> . decode-proc-output-contract)
    #:block-txexpr-proc (block-txexpr? . -> . decode-proc-output-contract)
    #:inline-txexpr-proc (txexpr? . -> . decode-proc-output-contract)
    #:string-proc (string? . -> . decode-proc-output-contract)
    #:entity-proc ((or/c symbol? valid-char?) . -> . decode-proc-output-contract)
    #:cdata-proc (cdata? . -> . decode-proc-output-contract)
    #:exclude-tags txexpr-tags?
    #:exclude-attrs txexpr-attrs?) . ->* . decode-proc-output-contract)
  (let loop ([x tx-in])
    (match x
      [(? txexpr?)
       (define-values (tag attrs elements) (txexpr->values x))
       (cond
         [(or (memq tag excluded-tags)
              (for/or ([attr (in-list attrs)])
                      (member attr excluded-attrs))) x] ; because it's excluded
         [else
          ;; we apply processing here rather than do recursive descent on the pieces
          ;; because if we send them back through loop, certain element types are ambiguous
          ;; e.g., ((p "foo")) tests out as both txexpr-attrs and txexpr-elements
          (define decoded-txexpr
            (make-txexpr (txexpr-tag-proc tag) 
                         (txexpr-attrs-proc attrs) 
                         (txexpr-elements-proc (append-map (λ (x) (->list/tx (loop x))) elements))))
          (txexpr-proc ((if (block-txexpr? decoded-txexpr)
                            block-txexpr-proc
                            inline-txexpr-proc) decoded-txexpr))])]
      [(? string?) (string-proc x)]
      [(? symbol?) (entity-proc x)]
      [(? valid-char?) (entity-proc x)]
      [(? cdata?) (cdata-proc x)]
      [else (raise-argument-error 'decode "decodable thing" x)])))

(module-test-external
 (require racket/list txexpr racket/function)
 (define (doubler x) (list x x))
 (define (doubletag x) (txexpr (string->symbol (format "~a~a" (get-tag x) (get-tag x))) (get-attrs x) (get-elements x)))
 (check-equal? (decode #:txexpr-elements-proc identity '(p "foo")) '(p "foo"))
 ;; can't use doubler on txexpr-elements because it needs a list, not list of lists
 (check-equal? (decode #:txexpr-elements-proc (λ (elems) (append elems elems)) '(p "foo")) '(p "foo" "foo"))
 (check-equal? (decode #:block-txexpr-proc identity '(p "foo")) '(p "foo"))
 (check-equal? (decode #:block-txexpr-proc doubler '(p "foo")) (list '(p "foo") '(p "foo")))
 (check-equal? (decode #:block-txexpr-proc doubler '(p "foo")) (list '(p "foo") '(p "foo")))
 (check-equal? (decode #:txexpr-proc doubletag '(root (p "foo") (b "bar"))) '(rootroot (pp "foo") (bb "bar")))
 (check-equal? (decode #:block-txexpr-proc doubletag '(root (p "foo") (b "bar"))) '(rootroot (pp "foo") (b "bar")))
 (check-equal? (decode #:inline-txexpr-proc doubletag '(root (p "foo") (b "bar"))) '(root (p "foo") (bb "bar")))
 (check-equal? (decode #:inline-txexpr-proc identity '(p (span "foo"))) '(p (span "foo")))
 (check-equal? (decode #:inline-txexpr-proc doubler '(p (span "foo"))) '(p (span "foo") (span "foo")))
 (check-equal? (decode #:string-proc identity '(p (span "foo"))) '(p (span "foo")))
 (check-equal? (decode #:string-proc doubler '(p (span "foo"))) '(p (span "foo" "foo")))
 (check-equal? (decode #:entity-proc identity '(p (span "foo" 'amp))) '(p (span "foo" 'amp)))
 (check-equal? (decode #:entity-proc identity '(p 42)) '(p 42))
 (check-equal? (decode #:entity-proc doubler '(p 42)) '(p 42 42))
 (check-equal? (decode #:entity-proc identity '(p amp)) '(p amp))
 ;; next text doesn't work because list of symbol elements is ambiguous with tagged X-expression
 ;; is there a general patch for this? maybe, but for now it's better to not patch selectively
 ;; otherwise ambiguous expressions will have erratic misbehavior (instead of merely consistent misbehavior)
 ;;(check-equal? (decode #:entity-proc doubler '(p amp)) '(p amp amp))
 (check-equal? (decode-elements #:string-proc identity '("foo")) '("foo"))
 (check-equal? (decode-elements #:string-proc doubler '("foo")) '("foo" "foo")))

;; it would be nice to not repeat this, but with all the keywords, it's simpler to repeat than do a macro
(define+provide/contract decode-elements 
  ((txexpr-elements?)  
   (#:txexpr-tag-proc (txexpr-tag? . -> . txexpr-tag?)
    #:txexpr-attrs-proc (txexpr-attrs? . -> . txexpr-attrs?)
    #:txexpr-elements-proc (txexpr-elements? . -> . txexpr-elements?)
    #:txexpr-proc (txexpr? . -> . decode-proc-output-contract)
    #:block-txexpr-proc (block-txexpr? . -> . decode-proc-output-contract)
    #:inline-txexpr-proc (txexpr? . -> . decode-proc-output-contract)
    #:string-proc (string? . -> . decode-proc-output-contract)
    #:entity-proc ((or/c symbol? valid-char?) . -> . decode-proc-output-contract)
    #:cdata-proc (cdata? . -> . decode-proc-output-contract)
    #:exclude-tags txexpr-tags?
    #:exclude-attrs txexpr-attrs?) . ->* . decode-proc-output-contract)
  (make-keyword-procedure
   (λ (kws kwargs . args)
     (define temp-tag (gensym "temp-tag"))
     (define elements (first args))
     (get-elements (keyword-apply decode kws kwargs (list (cons temp-tag elements)))))))

(define+provide/contract (block-txexpr? x)
  (any/c . -> . boolean?)
  ;; Mostly this is used inside `decode`,
  ;; so rather than test for `txexpr?` at the beginning (which is potentially slow)
  ;; just look at the tag.
  (and (pair? x) (memq (get-tag x) (setup:block-tags)) #t))

(define+provide/contract (decode-linebreaks elems [maybe-linebreak-proc '(br)]
                                            #:separator [newline (setup:linebreak-separator)])
  ((txexpr-elements?)
   ((or/c #f txexpr-element?
          (txexpr-element? txexpr-element? . -> . (or/c #f txexpr-element?))) #:separator string?)
   . ->* . txexpr-elements?)
  (unless (string? newline)
    (raise-argument-error 'decode-linebreaks "string" newline))
  (define linebreak-proc (match maybe-linebreak-proc
                           [(? procedure? proc) proc]
                           [val (λ (e1 e2) val)]))
  (define elems-vec (list->vector elems))
  (filter values
          (for/list ([(elem idx) (in-indexed elems-vec)])
                    (cond
                      [(zero? idx) elem] ; pass first item
                      [(= idx (sub1 (vector-length elems-vec))) elem] ; pass through last item
                      [(equal? elem newline)
                       (define prev (vector-ref elems-vec (sub1 idx)))
                       (define next (vector-ref elems-vec (add1 idx)))
                       ;; only convert if neither adjacent tag is a block
                       ;; (because blocks automatically force a newline before & after)
                       (if (or (block-txexpr? prev) (block-txexpr? next))
                           #false ; flag for filtering
                           (linebreak-proc prev next))]
                      [else elem]))))

(module-test-external
 (check-equal? (decode-linebreaks '("foo" "\n" "bar")) '("foo" (br) "bar"))
 (check-equal? (decode-linebreaks '("foo" "\n" "bar") #f) '("foo" "bar"))
 (check-equal? (decode-linebreaks '("\n" "foo" "\n" "bar" "\n")) '("\n" "foo" (br) "bar" "\n"))
 (check-equal? (decode-linebreaks '((p "foo") "\n" (p "bar"))) '((p "foo") (p "bar")))
 (check-equal? (decode-linebreaks '("foo" "\n" (p "bar"))) '("foo" (p "bar")))
 (check-equal? (decode-linebreaks '("foo" "moo" "bar")) '("foo" "moo" "bar"))
 (check-equal? (decode-linebreaks '("foo" "moo" "bar") "moo") '("foo" "moo" "bar"))
 (check-equal? (decode-linebreaks '("foo" "\n\n" "bar")) '("foo" "\n\n" "bar")))


;; Find adjacent newline characters in a list and merge them into one item
;; Scribble, by default, makes each newline a separate list item.
;; Ignore empty strings.
;; Descend into txexprs.
(define+provide/contract (merge-newlines x)
  (txexpr-elements? . -> . txexpr-elements?)
  (define newline-pat (regexp (format "^~a+$" (setup:newline))))
  (define (newline? x) (match x
                         [(regexp newline-pat) #true]
                         [_ #false]))  
  (define (merge-newline-slice xs)
    (match xs
      ;; if first member of slice is newline, they all are
      [(cons (? newline?) _) (list (apply string-append xs))]
      [_ xs]))
  (define (empty-string? x) (equal? x ""))
  (let loop ([x x])
    (match x
      [(? pair? x) #:when (not (attrs? x))
                   (define xs (map loop (filter-not empty-string? x)))
                   (append-map merge-newline-slice (slicef xs newline?))]
      [_ x])))

(module-test-external
 (require racket/list)
 (check-equal? (merge-newlines empty) empty)
 (check-equal? (merge-newlines '((p ((id "")) "\n" "" "\n"))) '((p ((id "")) "\n\n")))
 (check-equal? (merge-newlines '((p "\n" "" "\n"))) '((p "\n\n")))
 (check-equal? (merge-newlines '(p "\n" "\n" "foo" "\n" "\n\n" "bar" (em "\n" "\n" "\n"))) 
               '(p "\n\n" "foo" "\n\n\n" "bar" (em "\n\n\n"))))

(define+provide/contract (decode-paragraphs elements-in [maybe-wrap-proc 'p]
                                            #:linebreak-proc [linebreak-proc decode-linebreaks]
                                            #:force? [force-paragraph #f])
  ((txexpr-elements?) ((or/c txexpr-tag? ((listof xexpr?) . -> . txexpr?))
                       #:linebreak-proc (txexpr-elements? . -> . txexpr-elements?)
                       #:force? boolean?) 
                      . ->* . txexpr-elements?)
  (define paragraph-separator (setup:paragraph-separator))
  (unless (string? paragraph-separator)
    (raise-argument-error 'decode-paragraphs "string" paragraph-separator))
  
  (define (prep-paragraph-flow elems)
    (linebreak-proc (merge-newlines (trimf elems whitespace?))))
  
  (define (paragraph-break? x)
    (define paragraph-pattern (pregexp (format "^~a+$" paragraph-separator)))
    (match x
      [(pregexp paragraph-pattern) #true]
      [_ #false]))
  
  (define (explicit-or-implicit-paragraph-break? x)
    (or (paragraph-break? x) (block-txexpr? x)))

  (define wrap-proc (match maybe-wrap-proc
                      [(? procedure? proc) proc]
                      [_ (λ (elems) (list* maybe-wrap-proc elems))]))

  (define (wrap-paragraph elems)
    (match elems
      [(list (? block-txexpr?) ...) elems] ; leave a series of block xexprs alone
      [_ (list (wrap-proc elems))])) ; otherwise wrap in p tag

  (define elements (prep-paragraph-flow elements-in))
  (if (ormap explicit-or-implicit-paragraph-break? elements) ; need this condition to prevent infinite recursion
      ;; use `append-map` on `wrap-paragraph` rather than `map` to permit return of multiple elements
      (append-map wrap-paragraph
                  (append-map (λ (es) (filter-split es paragraph-break?)) (slicef elements block-txexpr?))) ; split into ¶¶, using both implied and explicit paragraph breaks
      (if force-paragraph
          ;; upconverts non-block elements to paragraphs
          (append-map wrap-paragraph (slicef elements block-txexpr?)) 
          elements)))            

(module-test-external
 (check-equal? (decode-paragraphs '("First para" "\n\n" "Second para"))
               '((p "First para") (p "Second para")))
 (check-equal? (decode-paragraphs '("First para" "\n\n" "Second para" "\n" "Second line"))
               '((p "First para") (p "Second para" (br) "Second line")))
 (check-equal? (decode-paragraphs '("First para" "\n\n" (div "Second block")))
               '((p "First para") (div "Second block")))
 (check-equal? (decode-paragraphs '((div "First block") "\n\n" (div "Second block")))
               '((div "First block") (div "Second block")))
 (check-equal? (decode-paragraphs '("First para" "\n\n" "Second para") 'ns:p)
               '((ns:p "First para") (ns:p "Second para")))
 (check-equal? (decode-paragraphs '("First para" "\n\n" "Second para" "\n" "Second line")
                                  #:linebreak-proc (λ (x) (decode-linebreaks x '(newline))))
               '((p "First para") (p "Second para" (newline) "Second line")))
 (check-equal? (decode-paragraphs '("foo" "\n\n" (div "bar") (div "zam")))
               '((p "foo") (div "bar") (div "zam")))
 (check-equal? (decode-paragraphs '("foo" "\n\n" (div "bar") "\n\n" (div "zam")))
               '((p "foo") (div "bar") (div "zam")))
 (check-equal? (decode-paragraphs '("foo")) '("foo"))
 (check-equal? (decode-paragraphs '("foo") #:force? #t) '((p "foo")))
 (check-equal? (decode-paragraphs '((div "foo"))) '((div "foo")))
 (check-equal? (decode-paragraphs '((div "foo")) #:force? #t) '((div "foo")))
 (check-equal? (decode-paragraphs '("foo" "\n\n" (div "bar"))) '((p "foo") (div "bar")))
 (check-equal? (decode-paragraphs '("foo" (div "bar"))) '((p "foo") (div "bar")))
 (check-equal? (decode-paragraphs '("foo" (div "bar")) #:force? #t) '((p "foo") (div "bar")))
 (check-equal? (decode-paragraphs '("foo" (div "bar") "zam")) '((p "foo") (div "bar") (p "zam")))
 (check-equal? (decode-paragraphs '("foo" (span "zing") (div "bar") "zam")) '((p "foo" (span "zing")) (div "bar") (p "zam")))
 (check-equal? (decode-paragraphs '("foo" (span "zing") (div "bar") "zam") #:force? #t) '((p "foo" (span "zing")) (div "bar") (p "zam"))))

(define+provide detect-paragraphs decode-paragraphs) ; bw compat
(define+provide detect-linebreaks decode-linebreaks) ; bw compat