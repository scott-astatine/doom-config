;;; keymaps.el -*- lexical-binding: t; -*-

(map!
 :desc "Win Left" 		"C-h" #'evil-window-left
 :desc "Win Right" 		"C-l" #'evil-window-right
 :desc "End of Line" :n		"E" #'end-of-line
 :desc "Next Buffer" :n 	"L" #'centaur-tabs-forward
 :desc "Previous Buffer" :n 	"H" #'centaur-tabs-backward)

(map! :leader
      ;;; Sidebar
      :desc "Project sidebar"  "e" #'treemacs-select-window

      :desc "Kill Buffer" :n "d" #'kill-buffer

      ;;; Emms
       (:when (featurep! :app emms)
	(:prefix-map ("m" . "Emms")
	 :desc "Play/Pause"		"SPC" #'emms-pause
	 :desc "Stop"            	"s" #'emms-stop
	 :desc "Next"            	"n" #'emms-next
	 :desc "Previous"        	"p" #'emms-previous
	 :desc "Browser"        	"b" #'emms-browser
	 :desc "Vol ＋"         	"i" #'emms-volume-raise
	 :desc "Vol ➖"           	"d" #'emms-volume-lower
	 :desc "Seek ⏩"           	"l" #'emms-seek-forward
	 :desc "Seek ⏪"           	"h" #'emms-seek-backward
	 :desc "Add Playlist"		"a" #'emms-add-directory-tree
	 :desc "Open"			"o" #'emms-play-file)))

(map! :i "]" nil
      :i "[" nil)

(map! :map treemacs-mode-map
      :n "a"   #'treemacs-create-file)
