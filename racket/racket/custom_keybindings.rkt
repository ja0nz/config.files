#lang s-exp framework/keybinding-lang
(define (rebind key command)
  (keybinding
   key
   (λ (ed evt)
     (send (send ed get-keymap) call-function
           command ed evt #t))))

(keybinding "c:<" (λ (editor event) (send editor insert "◊")))
(keybinding "tab" (λ (editor event) (send editor auto-complete)))
