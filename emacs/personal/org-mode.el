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

(defun my-org-mode-config ()
  "For use in `org-mode-hook'."
  (local-set-key (kbd "C-c C-d") 'org-gcal-delete-at-point))


(setq org-agenda-files (list "~/emacs/gcal.org"
                             "~/emacs/index.org"))

(setq org-capture-templates
      '(("a" "Appointment" entry (file  "~/emacs/gcal.org" )
         "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n")
        ("b" "Blog idea" entry (file+headline "~/emacs/index.org" "Blog Topics")
         "* %?\n%T" :prepend t)
        ("t" "To Do Item" entry (file+headline "~/emacs/index.org" "To Do")
         "* TODO %?\n%u" :prepend t)
        ("n" "Note" entry (file+headline "~/emacs/index.org" "Notes")
         "* %?\n%u" :prepend t)
        ))

(use-package org-gcal
             :ensure t
             :config
             (setq org-gcal-client-id "27237116424-qrn48jq6lt96ffci0c4u2refdl4bsogr.apps.googleusercontent.com"
                   org-gcal-client-secret "n7TxntiydoSLTNjm0oD-3Om4"
                   org-gcal-file-alist '(("jan.peteler@gmail.com" .  "~/emacs/gcal.org")
                                         ("iavak751kkqg5hdlo72kqb6voo@group.calendar.google.com" .  "~/emacs/tracktime.org"))))

(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1) ))
(add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))
(add-hook 'org-mode-hook 'my-org-mode-config)
