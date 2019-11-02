#lang racket/base
(require racket/match
         racket/list)
(provide (all-defined-out))

(define (split-metas x [meta-key 'define-meta])
  (apply hasheq
         (let loop ([x ((if (syntax? x) syntax->datum values) x)])
           (match x
             [(list (== meta-key eq?) key val)
              (unless (symbol? key)
                (raise-argument-error meta-key "valid meta key" key))
              (list key val)]
             [(? list? xs) (append-map loop xs)]
             [_ null]))))

(module+ test
  (require rackunit)
  (check-equal? (split-metas 'root) (hasheq))
  (check-equal? (split-metas '(root)) (hasheq))
  (check-exn exn:fail:contract? (λ () (split-metas '(root (define-meta 42 "bar")))))
  (check-equal? (split-metas '(root (div #:kw #f (define-meta foo "bar") "hi") "zim" (define-meta foo "boing") "zam")) '#hasheq((foo . "boing")))
  (check-equal? (split-metas '(root (div #:kw #f (define-meta foo 'bar) "hi") "zim" (define-meta foo 'boing) "zam")) '#hasheq((foo . 'boing)))
  (check-equal? (split-metas #'(root (define-meta dog "Roxy") (define-meta dog "Lex"))) '#hasheq((dog . "Lex")))
  (check-equal? (split-metas #'(root (define-meta dog "Roxy") (div (define-meta dog "Lex")))) '#hasheq((dog . "Lex"))))