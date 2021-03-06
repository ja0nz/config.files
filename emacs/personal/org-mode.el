(require 'use-package)
;; org-mode
;; Show lot of clocking history so it's easy to pick items off the `C-c I` list
;; (setq org-clock-history-length 23)

(defun eos/org-clock-in ()
  (interactive)
  (if (eq nil
          (condition-case nil
              (org-clock-in '(4))
            (error nil)))
      (org-clock-in)))

(global-set-key (kbd "s-i") #'eos/org-clock-in)
(global-set-key (kbd "s-u") #'org-clock-out)

;; (use-package org-gcal
;;   :ensure t
;;   :hook (org-agenda-mode . org-gcal-sync)
;;   :bind ("C-c M-k" . org-gcal-delete-at-point)
;;   :config
;;   (setq org-gcal-client-id "27237116424-qrn48jq6lt96ffci0c4u2refdl4bsogr.apps.googleusercontent.com"
;;         org-gcal-client-secret "123"
;;         org-gcal-file-alist '(("jan.peteler@gmail.com" .  "~/emacs/gcal.org"))))

(use-package org
  :hook ((org-mode . (lambda () (org-bullets-mode) (org-indent-mode) (turn-on-visual-line-mode)))
         (org-shiftup-final . windmove-up)
         (org-shiftdown-final . windmove-down)
         (org-shiftleft-final . windmove-left)
         (org-shiftright-final . windmove-right))
  :bind ("C-c M-j" . counsel-org-goto)
  :config
  (progn
    (setq org-agenda-files (list "~/emacs/index.org")
          org-capture-templates
          '(;; ("a" "Appointment" entry (file  "~/emacs/gcal.org")
            ;;  "* %?\n  :PROPERTIES:\n  :calendar-id: jan.peteler@gmail.com\n  :END:\n:org-gcal:\n%^T--%^T\n:END:\n")
            ("b" "Blog idea" entry (file+headline "~/emacs/index.org" "Blog Topics")
             "* %?\n%T" :prepend t)
            ("l" "Timeline - current buffer!" entry (file+headline (lambda () (buffer-file-name)) "Timeline")
             "* %t\n- %?" :prepend t)
            ("c" "TODOs - current buffer!" entry (file+headline (lambda () (buffer-file-name)) "TODOs")
             "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))"
             :prepend t)
            ("t" "TODOs" entry (file+headline "~/emacs/index.org" "TODOs")
             "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n"
             :prepend t)
            ("r" "Resource" entry (file "~/emacs/index.org")
             "* %?\n%u" :prepend t))
          org-support-shift-select 'always
          org-goto-interface 'outline-path-completion
          org-outline-path-complete-in-steps nil
          org-refile-targets
          '(("index.org" :maxlevel . 2)))))
