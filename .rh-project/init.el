;; -*- coding: utf-8 -*-

(require 'lsp-mode)
(require 'flycheck)

;;; stancia-mir-s0/wui
;;; /b/{

(defvar stancia-mir-s0/wui-build-buffer-name
  "*stancia-mir-s0/wui-build*")

(defun stancia-mir-s0/wui-lint ()
  (interactive)
  (rh-project-compile
   "yarn-run lint wui"
   stancia-mir-s0/wui-build-buffer-name))

(defun stancia-mir-s0/wui-build ()
  (interactive)
  (rh-project-compile
   "yarn-run build wui"
   stancia-mir-s0/wui-build-buffer-name))

(defun stancia-mir-s0/wui-clean ()
  (interactive)
  (rh-project-compile
   "yarn-run clean wui"
   stancia-mir-s0/wui-build-buffer-name))

(defun stancia-mir-s0/wui-clean ()
  (interactive)
  (rh-project-compile
   "yarn-run clean wui"
   stancia-mir-s0/wui-build-buffer-name))

(defvar stancia-mir-s0/wui-buffer-name
  "*stancia-mir-s0/wui*")

(defun stancia-mir-s0/local-wui-start ()
  (interactive)
  (rh-project-run-shell-command
   "yarn-run start wui"
   stancia-mir-s0/wui-buffer-name))

(defun stancia-mir-s0/local-wui-dev ()
  (interactive)
  (rh-project-run-shell-command
   "yarn-run dev wui"
   stancia-mir-s0/wui-buffer-name))

(defun stancia-mir-s0/local-kill ()
  (interactive)
  (rh-project-kill-shell-process
   stancia-mir-s0/wui-buffer-name))

(defun stancia-mir-s0/wui-hydra-define ()
  (defhydra stancia-mir-s0/wui-hydra (:color blue :columns 4)
    "@stancia-mir-s0/wui project commands"
    ("u" stancia-mir-s0-hydra/body "@stancia-mir-s0/")
    ("l" stancia-mir-s0/wui-lint "lint")
    ("b" stancia-mir-s0/wui-build "build")
    ("c" stancia-mir-s0/wui-clean "clean")
    ("o" stancia-mir-s0/local-wui-dev "local-dev")
    ("t" stancia-mir-s0/local-wui-start "local-start")
    ("k" stancia-mir-s0/local-kill "local-kill")))

(stancia-mir-s0/wui-hydra-define)

;;; /b/}

;;; stancia-mir-s0 common command
;;; /b/{

(defvar stancia-mir-s0/build-buffer-name
  "*stancia-mir-s0-build*")

(defun stancia-mir-s0/auto-code ()
  (interactive)
  (rh-project-compile
   "auto-code-groups"
   stancia-mir-s0/build-buffer-name))

(defun stancia-mir-s0/lint ()
  (interactive)
  (rh-project-compile
   "yarn-run app:lint"
   stancia-mir-s0/build-buffer-name))

(defun stancia-mir-s0/build ()
  (interactive)
  (rh-project-compile
   "yarn-run app:build"
   stancia-mir-s0/build-buffer-name))

(defun stancia-mir-s0/clean ()
  (interactive)
  (rh-project-compile
   "yarn-run app:clean"
   stancia-mir-s0/build-buffer-name))

;;; /b/}

;;; stancia-mir-s0
;;; /b/{

(defun stancia-mir-s0/hydra-define ()
  (defhydra stancia-mir-s0-hydra (:color blue :columns 5)
    "@stancia-mir-s0 workspace commands"
    ("a" stancia-mir-s0/auto-code "auto-code")
    ("l" stancia-mir-s0/lint "lint")
    ("b" stancia-mir-s0/build "build")
    ("c" stancia-mir-s0/clean "clean")
    ("g" stancia-mir-s0/wui-hydra/body "wui/")))

(stancia-mir-s0/hydra-define)

(define-minor-mode stancia-mir-s0-mode
  "stancia-mir-s0 project-specific minor mode."
  :lighter " stancia-mir-s0"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "<f9>") #'stancia-mir-s0-hydra/body)
            map))

(add-to-list 'rm-blacklist " stancia-mir-s0")

(defun stancia-mir-s0/lsp-deps-providers-path (path)
  (concat (expand-file-name (rh-project-get-root))
          "node_modules/.bin/"
          path))

(defun stancia-mir-s0/lsp-javascript-setup ()
  ;; (setq-local lsp-deps-providers (copy-tree lsp-deps-providers))

  (plist-put
   lsp-deps-providers
   :local (list :path #'stancia-mir-s0/lsp-deps-providers-path))

  (lsp-dependency 'typescript-language-server
                  '(:local "typescript-language-server"))

  (lsp--require-packages)

  (lsp-dependency 'typescript '(:local "tsserver"))

  (add-hook
   'lsp-after-initialize-hook
   #'stancia-mir-s0/flycheck-add-eslint-next-to-lsp))

(defun stancia-mir-s0/flycheck-add-eslint-next-to-lsp ()
  (when (seq-contains-p '(js2-mode typescript-mode web-mode) major-mode)
    (flycheck-add-next-checker 'lsp 'javascript-eslint)))

(defun stancia-mir-s0/flycheck-after-syntax-check-hook-once ()
  (remove-hook
   'flycheck-after-syntax-check-hook
   #'stancia-mir-s0/flycheck-after-syntax-check-hook-once
   t)
  (flycheck-buffer))

(eval-after-load 'lsp-javascript #'stancia-mir-s0/lsp-javascript-setup)

(defun stancia-mir-s0-setup ()
  (when buffer-file-name
    (let ((project-root (rh-project-get-root))
          file-rpath ext-js)
      (when project-root
        (setq file-rpath (expand-file-name buffer-file-name project-root))
        (cond
         ;; This is required as tsserver does not work with files in archives
         ((bound-and-true-p archive-subfile-mode)
          (company-mode 1))

         ((or (setq
               ext-js
               (string-match-p
                (concat "\\.ts\\'\\|\\.tsx\\'\\|\\.js\\'\\|\\.jsx\\'"
                        "\\|\\.cjs\\'\\|\\.mjs\\'")
                file-rpath))
              (string-match-p "^#!.*node"
                              (or (save-excursion
                                    (goto-char (point-min))
                                    (thing-at-point 'line t))
                                  "")))

          (when (boundp 'rh-js2-additional-externs)
            (setq-local rh-js2-additional-externs
                        (append rh-js2-additional-externs
                                '("require" "exports" "module" "process"
                                  "__dirname"))))

          (setq-local flycheck-idle-change-delay 3)
          (setq-local flycheck-check-syntax-automatically
                      ;; '(save mode-enabled)
                      '(save idle-change mode-enabled))
          (setq-local flycheck-javascript-eslint-executable
                      (concat (expand-file-name project-root)
                              "node_modules/.bin/eslint"))
                              ;; ".yarn/sdks/eslint/bin/eslint.js"))

          (setq-local lsp-enabled-clients '(ts-ls))
          ;; (setq-local lsp-headerline-breadcrumb-enable nil)
          (setq-local lsp-before-save-edits nil)
          (setq-local lsp-modeline-diagnostics-enable nil)
          (add-hook
           'flycheck-after-syntax-check-hook
           #'stancia-mir-s0/flycheck-after-syntax-check-hook-once
           nil t)

          (lsp)
          ;; (lsp-headerline-breadcrumb-mode -1)

          (prettier-mode 1)))))))

;;; /b/}
