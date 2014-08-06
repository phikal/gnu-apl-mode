;;; -*- lexical-binding: t -*-

(require 'cl)

(cl-defun gnu-apl--trim (regexp string &optional (start t) (end t))
  (if (or start end)
    (let ((res string)
          (reg (cond ((and start end)
                      (concat "\\(\\`" regexp "\\)\\|\\(" regexp "\\'\\)"))
                     ((not end)
                      (concat "\\`" regexp))
                     (t
                      (concat regexp "\\'")))))
      (while (string-match reg res)
        (setq res (replace-match "" t t res)))
      res)
    string))

(cl-defun gnu-apl--trim-spaces (string &optional (start t) (end t))
  (gnu-apl--trim "[ \t]" string start end))

(cl-defun gnu-apl--trim-trailing-newline (string)
  (gnu-apl--trim "[\n\r]" string nil t))

(defun gnu-apl--open-new-buffer (name)
  (let ((buffer (get-buffer name)))
    (when buffer
      (delete-windows-on buffer)
      (kill-buffer buffer))
    (get-buffer-create name)))

(defun gnu-apl--string-match-start (string key)
  (and (>= (length string) (length key))
       (string= (subseq string 0 (length key)) key)))

(defun gnu-apl--kbd (definition)
  (if (functionp #'kbd)
      (kbd definition)
    (eval `(kbd ,definition))))

(cl-defmacro gnu-apl--when-let ((var value) &rest body)
  "Evaluate VALUE, if the result is non-nil bind it to VAR and eval BODY.

\(fn (VAR VALUE) &rest BODY)"
  (declare (indent 1))
  `(let ((,var ,value))
     (when ,var ,@body)))

(defun gnu-apl--current-line-number ()
  (save-restriction
    (widen)
    (save-excursion
      (beginning-of-line)
      (1+ (count-lines 1 (point))))))

(unless (fboundp 'cl-find)
  (defun cl-find (&rest args)
    (apply #'find args)))

(unless (fboundp 'cl-defun)
  (defmacro cl-defun (&rest args)
    `(defun* ,@args)))

(unless (fboundp 'cl-defmacro)
  (defmacro cl-defmacro (&rest args)
    `(defmacro* ,@args)))

(unless (fboundp 'cl-remove-if-not)
  (defun cl-remove-if-not (&rest args)
    (apply #'remove-if-not args)))
