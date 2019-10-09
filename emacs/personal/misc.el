(require 'use-package)

(desktop-save-mode 1)
(toggle-scroll-bar -1)

;; Clojure
(prelude-install-search-engine "CLJDocs" "https://clojuredocs.org/search?q=" "Search CLJ Docs: ")
(add-hook 'clojure-mode-hook #'parinfer-mode)

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

;; Purescript psc-ide
;; TODO PSCI mode check
(use-package psc-ide
  :ensure t)

(use-package purescript-mode
  :ensure t
  :hook (purescript-mode . (lambda ()
                           (psc-ide-mode)
                           (company-mode)
                           (flycheck-mode)
                           (turn-on-purescript-indentation))) )
