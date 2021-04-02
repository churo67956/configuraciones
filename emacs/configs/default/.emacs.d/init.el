(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;;Refleja los cambios en los buffers al cambiar de una rama a otra de git, sin necesidad de realizar un reverse
(global-auto-revert-mode 1)

;;move among panels 
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)


;;Assing a file a determinate mode
;;(add-to-list 'auto-mode-alist '("\\.md\\'" . org-mode))

;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(package-selected-packages (quote (projectile melpa-upstream-visit magit))))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; )

;; recentf mode to open saved files using C-x C-r
(recentf-mode 1)
(defvar recentf-max-menu-items 25)
(defvar recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; supported languages for org-mode execution
;; also in a transparent mode not confirmation needed
(org-babel-do-load-languages
 'org-babel-load-languages
 '((latex . t)
   (python . t)
   (scala .t)
   (org . t)
   (octave .t)
   (shell . t)))
;;disable code evaluate confirmation from the user
;;(defun my-org-confirm-babel-evaluate (lang body)
 ;; (not (member lang '("latex" "shell" "scala" "org" "python" "octave"))))
;;   (not (string= lang "shell")))
;;(defvar org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)
(setq org-confirm-babel-evaluate nil        ;; for running code blocks
      org-confirm-elisp-link-function nil   ;; for elisp links
      org-confirm-shell-link-function nil)  ;; for shell links
 
;;fancy statusline
(require 'powerline)
(powerline-default-theme)

;;enable google-translate 
(require 'google-translate)
(require 'google-translate-default-ui)
(global-set-key "\C-ct" 'google-translate-at-point)
(global-set-key "\C-cT" 'google-translate-query-translate)
;; set principal target language to avoid request
(setq  google-translate-default-target-language "es")
;; set pricipal source language to avoid request
(setq  google-translate-default-source-language "en")

(use-package google-translate
  :ensure t
  :custom
  (google-translate-backend-method 'curl)
  :config
   (defun google-translate--search-tkk () "Search TKK." (list 430675 2721866130)))

;; enable a template system
(defvar yas-snippet-dirs
  '("~/Documentos/Proyectos/configuraciones/emacs/snippets" ;;personal snippets
    "~/Documentos/Proyectos/configuraciones/emacs/snippets/yasnippet-snippets/snippets" ;;remote snippets
    ))
(require 'yasnippet)
(yas-global-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yasnippet-snippets projectile melpa-upstream-visit magit))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun xah-beginning-of-line-or-block ()
  "Move cursor to beginning of line or previous paragraph.

• When called first time, move cursor to beginning of char in current line. (if already, move to beginning of line.)
• When called again, move cursor backward by jumping over any sequence of whitespaces containing 2 blank lines.

URL `http://ergoemacs.org/emacs/emacs_keybinding_design_beginning-of-line-or-block.html'
Version 2017-05-13"
  (interactive)
  (let (($p (point)))
    (if (or (equal (point) (line-beginning-position))
            (equal last-command this-command ))
        (if (re-search-backward "\n[\t\n ]*\n+" nil "NOERROR")
            (progn
              (skip-chars-backward "\n\t ")
              (forward-char ))
          (goto-char (point-min)))
      (progn
        (back-to-indentation)
        (when (eq $p (point))
          (beginning-of-line))))))


(global-set-key (kbd "C-a a") 'xah-beginning-of-line-or-block)
