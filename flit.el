(defun flit-treesit-mark-node (node)
  (when (not node)
    (error "NODE was nil"))
  (set-mark (treesit-node-start node))
  (goto-char (treesit-node-end node)))

(defun flit-shrink-selection ()
  (interactive)
  (flit-treesit-mark-node
   (treesit-node-child
    (treesit-node-on (min (mark) (point)) (max (mark) (point)) nil t) 0 t))
  ;; (flit-treesit-mark-node
  ;;  (treesit-node-child (treesit-node-at (min (mark) (point))) 0))

  )

(defun flit-expand-selection ()
  (interactive)
  (if (region-active-p)
      (let* ((region-start (min (mark) (point)))
	     (node (treesit-node-at (min (mark) (point))))
	     (parent (treesit-node-on (- (min (mark) (point)) 1) (max (mark) (point)))))
	(if (not parent)
	    (error "node has no parent")
	  (progn
	    (flit-treesit-mark-node parent)
	    (when (= region-start (min (mark) (point)))
		;; Marking the parent doesn't seem to have done anything. Try navigating back a character and try again.
		;; (error "marking the parent did not seem to change the region")
		;; (goto-char region-start)
		;; (backward-char)
		;; (flit-treesit-mark-node (treesit-node-at (point))))))
	
	      (flit-treesit-mark-node (treesit-node-parent (treesit-node-prev-sibling parent)))))))
    (flit-treesit-mark-node (treesit-node-at (point)))))

(defun flit-select-prev-sibling ()
  (interactive)
  (flit-treesit-mark-node
   (treesit-node-prev-sibling
    (treesit-node-on (min (mark) (point)) (max (mark) (point))))))

(defun flit-select-next-sibling ()
  (interactive)
  (flit-treesit-mark-node
   (treesit-node-next-sibling
    (treesit-node-on (min (mark) (point)) (max (mark) (point))))))

(provide 'flit)
