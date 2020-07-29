;;; init.el --- emacs's initialize file
;;; Commentary:
;;; Code:

;;; == load bears private config file ==

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/private")

(require 'bears-variables)
(require 'bears-defaults)
(require 'bears-functions)
(require 'bears-packages)

;;; == user config file ==
(load-file "~/.emacs.d/private/bears-user-file.el")

(defvar-local bears--current-user-file-version bears--user-file-version)
(setq bears--user-file-version "")

(unless (file-exists-p "~/.bearsmacs.el")
  (copy-file "~/.emacs.d/private/bears-user-file.el" "~/.bearsmacs.el"))

(load-file "~/.bearsmacs.el")

(if nil (string= bears--current-user-file-version bears--user-file-version)
  (display-warning :warning "Mismatch in a .bearsmacs file version! Please check changes."))

(bears-configurations)
(bears-user-init)

(bears-load-theme-args bears-gui-theme bears-terminal-theme)

(require 'bears-style)
(require 'bears-bind)
(require 'bears-configuration)

(when use-bears-default-configurations
  (add-hook 'prog-mode-hook 'bears-prog-configuration)
  (add-hook 'markdown-mode-hook 'bears-prog-configuration)
  (add-hook 'lisp-interaction-mode-hook 'bears-common-configuration)
  (add-hook 'emacs-lisp-mode-hook 'bears-prog-configuration)
  (add-hook 'text-mode-hook 'bears-common-configuration)
  (add-hook 'sh-mode-hook 'bears-common-configuration)
  (add-hook 'c++-mode-hook 'bears-c++-configuration)
  (add-hook 'c-mode-hook 'bears-c-configuration)
  (add-hook 'python-mode-hook 'bears-python-configuration)
  (add-hook 'gitignore-mode-hook 'bears-common-configuration)
  (add-hook 'gitattributes-mode-hook 'bears-common-configuration)
  (add-hook 'gitconfig-mode-hook 'bears-common-configuration)
  (add-hook 'cmake-mode-hook 'bears-prog-configuration)
  (add-hook 'ninja-mode-hook 'bears-prog-configuration)
  (add-hook 'ttcn-3-mode-hook 'bears-ttcn3-configuration)
  (add-hook 'glsl-mode-hook 'bears-c-configuration))

(when use-bears-default-packages
  (setq bears-packages (append bears-packages bears-default-packages))
  )

(require 'cl-lib)
(setq bears-packages (cl-set-difference bears-packages bears-disabled-packages))

(while bears-packages
  (load-file
   (format "~/.emacs.d/private/packages/bears-%s.el" (pop bears-packages))))

(bears-user-config)

;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions
;;               (lambda (frame)
;;                 (unless (string= bears-theme "")
;;                   (load-file (format "~/.emacs.d/private/themes/bears-%s.el" bears-theme)))
;;                 )
;;               )
;;   )

;; (load custom-file 'noerror 'nomessage)

;;; init.el ends here
