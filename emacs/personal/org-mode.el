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

(global-set-key (kbd "C-c I") #'eos/org-clock-in)
(global-set-key (kbd "C-c O") #'org-clock-out)

(use-package org-gcal
  :ensure t
  :hook (org-agenda-mode . org-gcal-sync)
  :bind ("C-c M-k" . org-gcal-delete-at-point)
  :config
  (setq org-gcal-client-id "27237116424-qrn48jq6lt96ffci0c4u2refdl4bsogr.apps.googleusercontent.com"
        org-gcal-client-secret "n7TxntiydoSLTNjm0oD-3Om4"
        org-gcal-file-alist '(("jan.peteler@gmail.com" .  "~/emacs/gcal.org"))))

(use-package org
  :hook (org-mode . (lambda () (org-bullets-mode) (org-indent-mode)))
  :config
  (progn
    (setq org-agenda-files (list "~/emacs/gcal.org" "~/emacs/index.org")
          org-capture-templates
          '(("a" "Appointment" entry (file  "~/emacs/gcal.org" )
             "* %?\n  :PROPERTIES:\n  :calendar-id: jan.peteler@gmail.com\n  :END:\n:org-gcal:\n%^T--%^T\n:END:\n")
            ("b" "Blog idea" entry (file+headline "~/emacs/index.org" "Blog Topics")
             "* %?\n%T" :prepend t)
            ("t" "To Do Item" entry (file+headline "~/emacs/index.org" "To Do")
             "* TODO %?\n%u" :prepend t)
            ("n" "Note" entry (file+headline "~/emacs/index.org" "Notes")
             "* %?\n%u" :prepend t)
            ))
    ))
