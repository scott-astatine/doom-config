;;; config.el -*- lexical-binding: t; -*-

;; User config
(setq user-full-name "Scott Astatine"
      user-mail-address "scottastatine@gmail.com")

;;; Default Buf & Frame Name

(setq frame-title-format
      '(""
	(:eval
	 (if (s-contains-p org-roam-directory (or buffer-file-name ""))
	     (replace-regexp-in-string
	      ".*/[0-9]*-?" "☰ "
	      (subst-char-in-string ?_ ?  buffer-file-name))
	   "%b"))
	(:eval
	 (let ((project-name (projectile-project-name)))
	   (unless (string= "-" project-name)
	     (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

(setq doom-fallback-buffer-name "*Doom*"
      +doom-dashboard-name "*Doom*"
      doom-scratch-initial-major-mode 'lisp-interaction-mode
      )

;;; Fonts
(setq
 doom-font (font-spec :family "JetBrains Mono" :size 12 :antialias t)
 doom-variable-pitch-font (font-spec :family "Deja Vu Sans Mono" :size 17)
 doom-unicode-font (font-spec :family "Noto Color Emoji" :size 15)
 doom-big-font (font-spec :family "JetBrains Mono" :size 18)
 +zen-text-scale 0.9)
;;;

(setq doom-theme 'doom-monokai-classic)
(remove-hook 'window-setup-hook #'doom-init-theme-h)
(add-hook 'after-init-hook #'doom-init-theme-h 'append)
(delq! t custom-theme-load-path)


;;; Editor conf
(setq auto-save-default t
      make-backup-files t
      indent-tabs-mode t
      org-hide-emphasis-markers t
      doom-themes-enable-bold t
      doom-themes-enable-italic t
      confirm-kill-emacs nil
      blink-cursor-mode t
      blink-cursor-interval 0.5
      yas-triggers-in-field t
      ispell-dictionary "uk"
      emojify-emoji-set "twemoji-v2"
      evil-split-window-below t
      evil-vsplit-window-right t)

(setq-default indent-tabs-mode t)
(setq-default tab-width 4) ; Assuming you want your tabs to be four spaces wide
(defvaralias 'c-basic-offset 'tab-width)

;;;


;;; Centaur Tabs
(setq
 centaur-tabs-style "slant"
 centaur-tabs-set-bar nil
 centaur-tabs-height 22
 centaur-tabs-modified-marker "●"
 centaur-tabs-show-navigation-buttons nil
 centaur-tabs-adjust-buffer-order t
 )
;; Hide tabline in certain modes
(with-eval-after-load 'centaur-tabs
  (defun centaur-tabs-buffer-groups ()
    "Organize tabs into groups by buffer."
    (list
     (cond
      ((string-equal "*" (substring (buffer-name) 0 1)) "Emacs")
      ((memq major-mode '(org-mode
			  emacs-lisp-mode)) "Org Mode")
      ((derived-mode-p 'dired-mode) "Dired")
      ((derived-mode-p 'prog-mode
		       'text-mode) "Editing")
      (t "User"))))

  (defun centaur-tabs-hide-tab (buffer)
    "Hide from the tab bar by BUFFER name."
    (let ((name (format "%s" buffer)))
      (or
       ;; Current window is dedicated window
       (window-dedicated-p (selected-window))

       ;; Buffer name does match below blacklist
       (string-match-p
	(concat "^\\*\\("
		"e?shell\\|"
		"Completions\\|"
		"clangd\\|" ; lsp c/c++
		"Faces\\|"
		"Flycheck\\|"
		"Help\\|"
		"Doom\\|"
		"which-key\\|"
		"helpful\\|"
		"Occur"
		"\\).*")
	name)
       )))
  )
;;;

;;; Emms
(emms-all)
(emms-default-players)
(setq emms-source-file-default-directory "~/Music"
      emms-info-functions '(emms-info-tinytag)
      emms-playlist-buffer-name "Music"
      emms-mode-line-icon-color "#2c2fe9"
      emms-mode-line-icon-enabled-p nil
      emms-volume-amixer-card 1
      emms-mode-line-format "[ 🎶 %s ]")

(require 'emms-player-simple)
(require 'emms-source-file)
(require 'emms-source-playlist)
(setq emms-player-list '(emms-player-mpg321
			 emms-player-ogg123
			 emms-player-mpv
			 emms-player-mplayer
			 ))

(defun track-title-from-file-name (file)
  (with-temp-buffer
    (save-excursion (insert (file-name-nondirectory (directory-file-name file))))
    (ignore-error 'search-failed
      (search-forward-regexp (rx "." (+ alnum) eol))
      (delete-region (match-beginning 0) (match-end 0)))
    (buffer-string)))

(defun my-emms-track-description (track)
  (let ((artist (emms-track-get track 'info-artist))
	(title (emms-track-get track 'info-title)))
    (cond ((and artist title)
	   (concat artist " - " title))
	  (title title)
	  ((eq (emms-track-type track) 'file)
	   (track-title-from-file-name (emms-track-name track)))
	  (t (emms-track-simple-description track)))))

(setq emms-track-description-function 'my-emms-track-description)
;;;


;;; Doom Modline
(setq display-line-numbers-type 'relative
      display-time-format " 🗓 %d %a %H:%M:%S "
      display-time-interval 1
      doom-modeline-major-mode-icon t
      doom-modeline-height 23
      doom-modeline-bar-width 4
      doom-modeline-env-version nil
      display-time-default-load-average nil
      doom-modeline-mu4e t)

(display-time-mode 1)

(with-eval-after-load "doom-modeline"
  (doom-modeline-def-modeline 'main
    '(bar workspace-name window-number modals matches buffer-info remote-host checker parrot selection-info)
    '(
      objed-state persp-name battery grip
      irc mu4e gnus github buffer-position debug
      misc-info lsp minor-modes input-method indent-info
      buffer-encoding major-mode process vcs " ")))

(defun doom-modeline-conditional-buffer-encoding ()
  (setq-local doom-modeline-buffer-encoding
	      (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
				 '(coding-category-undecided coding-category-utf-8))
			   (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
		t)))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

;;; Pdf-Mode Config
(after! doom-modeline
  (doom-modeline-def-segment buffer-name
    "Display the current buffer's name, without any other information."
    (concat
     (doom-modeline-spc)
     (doom-modeline--buffer-name)))

  (doom-modeline-def-segment pdf-icon
    "PDF icon from all-the-icons."
    (concat
     (doom-modeline-spc)
     (doom-modeline-icon 'octicon "file-pdf" nil nil
			 :face (if (doom-modeline--active)
				   'all-the-icons-red
				 'mode-line-inactive)
			 :v-adjust 0.02)))

  (defun doom-modeline-update-pdf-pages ()
    "Update PDF pages."
    (setq doom-modeline--pdf-pages
	  (let ((current-page-str (number-to-string (eval `(pdf-view-current-page))))
		(total-page-str (number-to-string (pdf-cache-number-of-pages))))
	    (concat
	     (propertize
	      (concat (make-string (- (length total-page-str) (length current-page-str)) ? )
		      " P" current-page-str)
	      'face 'mode-line)
	     (propertize (concat "/" total-page-str) 'face 'doom-modeline-buffer-minor-mode)))))

  (doom-modeline-def-segment pdf-pages
    "Display PDF pages."
    (if (doom-modeline--active) doom-modeline--pdf-pages
      (propertize doom-modeline--pdf-pages 'face 'mode-line-inactive)))

  (doom-modeline-def-modeline 'pdf
    '(bar window-number pdf-pages pdf-icon buffer-name)
    '(misc-info matches major-mode process vcs)))
;;;


;;; Org
(after! org
  (setq org-directory "~/Documents/org/"
	org-archive-location (concat org-directory ".archive/%s::")
	org-roam-directory (concat org-directory "notes/")
	org-roam-db-location (concat org-roam-directory ".org-roam.db")
	org-journal-encrypt-journal t
	org-ellipsis "[↯]"
	org-journal-file-format "%Y%m%d.org"
	org-hide-emphasis-markers t
	)
  org-insert-heading-respect-content nil)

(setq org-confirm-babel-evaluate nil)

(defun doom-shut-up-a (orig-fn &rest args)
  (quiet! (apply orig-fn args)))

(advice-add 'org-babel-execute-src-block :around #'doom-shut-up-a)

;;;


;;; Splash

(let ((splash '("doom-emacs-color.png"
		"doom-emacs-color2.png"
		"doom-emacs-flugo-slant_out_purple-small.png"
		"doom-emacs-flugo-slant_out_bw-small.png")))
  (setq fancy-splash-image
	(concat doom-private-dir "splash/"
		(nth (random (length splash)) splash))))

;;; WhichKey
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-/:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

;;;

;;; Writeroom

(defvar +zen-serif-p t)

(after! writeroom-mode
  (defvar-local +zen--original-org-indent-mode-p nil)
  (defvar-local +zen--original-mixed-pitch-mode-p nil)
  ;; (defvar-local +zen--original-org-pretty-table-mode-p nil)
  (defun +zen-enable-mixed-pitch-mode-h ()
    "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
    (when (apply #'derived-mode-p +zen-mixed-pitch-modes)
      (if writeroom-mode
	  (progn
	    (setq +zen--original-mixed-pitch-mode-p mixed-pitch-mode)
	    (funcall (if +zen-serif-p #'mixed-pitch-serif-mode #'mixed-pitch-mode) 1))
	(funcall #'mixed-pitch-mode (if +zen--original-mixed-pitch-mode-p 1 -1)))))
  (pushnew! writeroom--local-variables
	    'display-line-numbers
	    'visual-fill-column-width
	    'org-adapt-indentation
	    'org-superstar-headline-bullets-list
	    'org-superstar-remove-leading-stars)
  (add-hook 'writeroom-mode-enable-hook
	    (defun +zen-prose-org-h ()
	      "Reformat the current Org buffer appearance for prose."
	      (when (eq major-mode 'org-mode)
		(setq display-line-numbers nil
		      visual-fill-column-width 60
		      org-adapt-indentation nil)
		(when (featurep 'org-superstar)
		  (setq-local
		   ;; org-superstar-headline-bullets-list '("🙘" "🙙" "🙚" "🙛")
		   org-superstar-headline-bullets-list '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
		   org-superstar-remove-leading-stars t)
		  (org-superstar-restart))
		(setq
		 +zen--original-org-indent-mode-p org-indent-mode
		 +zen--original-org-pretty-table-mode-p (bound-and-true-p org-pretty-table-mode))
		(org-indent-mode -1)
		(org-pretty-table-mode 1))))
  (add-hook 'writeroom-mode-disable-hook
	    (defun +zen-nonprose-org-h ()
	      "Reverse the effect of `+zen-prose-org'."
	      (when (eq major-mode 'org-mode)
		(when (featurep 'org-superstar)
		  (org-superstar-restart))
		(when +zen--original-org-indent-mode-p (org-indent-mode 1))
		(unless +zen--original-org-pretty-table-mode-p (org-pretty-table-mode -1))
		))))

;;;

;;; Treemacs

(after! :ui treemacs
  (setq treemacs-deferred-git-apply-delay        0.5
	treemacs-directory-name-transformer      #'identity
	treemacs-display-in-side-window          t
	treemacs-eldoc-display                   'simple
	treemacs-file-event-delay                5000
	treemacs-file-follow-delay               0.2
	treemacs-file-name-transformer           #'identity
	treemacs-follow-after-init               t
	treemacs-expand-after-init               t
	treemacs-is-never-other-window           nil
	treemacs-missing-project-action          'ask
	treemacs-move-forward-on-expand          nil
	treemacs-no-png-images                   nil
	treemacs-no-delete-other-windows         t
	treemacs-position                        'left
	treemacs-recenter-after-project-jump     'always
	treemacs-recenter-after-project-expand   'on-distance
	treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
	treemacs-show-cursor                     nil
	treemacs-sorting                         'alphabetic-asc
	treemacs-select-when-already-in-treemacs 'move-back
	treemacs-space-between-root-nodes        t
	treemacs-tag-follow-cleanup              t
	treemacs-tag-follow-delay                0.5
	treemacs-wide-toggle-width               70
	treemacs-width                           35
	treemacs-width-increment                 1

	treemacs-workspace-switch-cleanup        nil)
  (treemacs-follow-mode))

;;;

;;; Keymaps
(load-file "~/.doom.d/keymaps.el")

;;; LSP
(load-file "~/.doom.d/lsp.el")
