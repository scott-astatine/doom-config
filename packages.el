;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! info-colors)
(package! which-key-posframe)


(unpin! evil)
(unpin! ivy)
(unpin! vertico)
(unpin! lsp-mode)

;; (when (package! eaf :recipe (:host github
;;                              :repo "manateelazycat/emacs-application-framework"
;;                              :files ("*.el" "*.py" "app" "core")
;;                              :build (:not compile)))

;;   (package! ctable :recipe (:host github :repo "kiwanami/emacs-ctable"))
;;   (package! deferred :recipe (:host github :repo "kiwanami/emacs-deferred"))
;;   (package! epc :recipe (:host github :repo "kiwanami/emacs-epc")))


;; (package! theme-magic)

;; (use-package! theme-magic
;;   :commands theme-magic-from-emacs
;;   :config
;;   (defadvice! theme-magic--auto-extract-16-doom-colors ()
;;     :override #'theme-magic--auto-extract-16-colors
;;     (list
;;      (face-attribute 'default :background)
;;      (doom-color 'error)
;;      (doom-color 'success)
;;      (doom-color 'type)
;;      (doom-color 'keywords)
;;      (doom-color 'constants)
;;      (doom-color 'functions)
;;      (face-attribute 'default :foreground)
;;      (face-attribute 'shadow :foreground)
;;      (doom-blend 'base8 'error 0.1)
;;      (doom-blend 'base8 'success 0.1)
;;      (doom-blend 'base8 'type 0.1)
;;      (doom-blend 'base8 'keywords 0.1)
;;      (doom-blend 'base8 'constants 0.1)
;;      (doom-blend 'base8 'functions 0.1)
;;      (face-attribute 'default :foreground))))

;; (package! calctex
;;   :recipe (:host github :repo "johnbcoughlin/calctex"
;; 	   :files ("*.el" "calctex/*.el" "calctex-contrib/*.el" "org-calctex/*.el" "vendor"))
;;   :pin "67a2e76847a9ea9eff1f8e4eb37607f84b380ebb")
