(key-chord-define-global "hh" 'avy-goto-word-1) ;; First letter word
(key-chord-define-global "HH" 'crux-switch-to-previous-buffer)
(key-chord-define-global "GG" 'ace-window)
(key-chord-define-global "hf" 'avy-goto-char) ;; any char
(key-chord-define-global "hF" 'avy-goto-line) ;; any line
(key-chord-define-global "qq" 'avy-pop-mark) ;; pop back to last mark
(key-chord-define-global "kk" 'undo-tree-visualize)

;; Custom
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-M-SPC") 'easy-mark)
(global-set-key (kbd "s-SPC") 'easy-kill-help)
