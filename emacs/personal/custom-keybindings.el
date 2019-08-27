(key-chord-define-global "hh" 'avy-goto-word-1) ;; First letter word
(key-chord-define-global "HH" 'crux-switch-to-previous-buffer)
(key-chord-define-global "GG" 'ace-window)
(key-chord-define-global "hf" 'avy-goto-char) ;; any char
(key-chord-define-global "hF" 'avy-goto-line) ;; any line
(key-chord-define-global "ff" 'avy-pop-mark) ;; pop back to last mark
(key-chord-define-global "kk" 'undo-tree-visualize)

;; Custom
(global-set-key (kbd "C-c c") 'org-capture)
(toggle-scroll-bar -1)

