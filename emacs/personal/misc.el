(require 'use-package)

(desktop-save-mode 1)
(toggle-scroll-bar -1)

;; Multi term
(use-package multi-term
  :ensure t
  :config (setq multi-term-program "/usr/bin/fish"))

;; Clojure
(prelude-install-search-engine "CLJDocs" "https://clojuredocs.org/search?q=" "Search CLJ Docs: ")

(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :config (setq parinfer-auto-switch-indent-mode t)
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
             pretty-parens  ; different paren styles for different modes.
             ;; lispy         ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
             ;; paredit        ; Introduce some paredit commands.
             ;; smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
             smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

;; Purescript
(prelude-install-search-engine "Pursuit" "https://pursuit.purescript.org/search?q=" "Search Pursuit: ")

;; ensure psc-ide package
(use-package purescript-mode
  :ensure t
  :bind (("s-SPC" . company-complete))
  :config (setq psc-ide-rebuild-on-save t)
  :hook (purescript-mode . (lambda ()
                             (psc-ide-mode)
                             (company-mode)
                             (flycheck-mode)
                             (turn-on-purescript-indentation))) )

;; set Iosevka font only if it available
(defun rag-set-face (frame)
  "Configure faces on frame creation"
  (select-frame frame)
  (if (display-graphic-p)
      (progn
        (when (member "Iosevka" (font-family-list))
          (progn
            (set-frame-font "Iosevka-12" nil t))))))
(add-hook 'after-make-frame-functions #'rag-set-face)

;; set frame font when running emacs normally
(when (member "Iosevka" (font-family-list))
  (progn
    (set-frame-font "Iosevka-12" nil t)))
