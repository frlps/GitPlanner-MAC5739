(define (domain git)

    (:requirements :strips :typing)

    (:types file)

    (:predicates
        ;; file exists in workspace but has never been source-controlled
        (untracked ?f - file)

        ;; a file modification has been added to the staging area but not committed
        (staged ?f - file)

        ;; all changes were added to the staging area and then committed.
        (committed ?f - file)

        ;; already tracked file has no modifications in workspace (typically after being committed)
        (clean ?f - file)

        ;; file has been modified but this change has not been staged
        (modified-in-workspace ?f - file)

        ;; file has been deleted but this change has not been staged
        (deleted-in-workspace ?f - file)
    )

    ;; git add <new-file>
    (:action git-add-new
        :parameters (?f - file)
        :precondition (and 
            (untracked ?f - file)
        )
        :effect (and
            (staged ?f - file)
            (not (untracked ?f - file))
        )
    )

    ;; git add <old-file>
    (:action git-add
        :parameters (?f - file)
        :precondition (and 
            (modified-in-workspace ?f - file)
        )
        :effect (and
            (staged ?f - file)
        )
    )
    
    ;; git rm <old-file>
    (:action git-rm
        :parameters (?f - file)
        :precondition (and 
            (committed ?f - file)
        )
        :effect (and
            (deleted-in-workspace ?f - file)
        )
    )
    
    ;; git checkout -- <old-file>
    (:action git-checkout
        :parameters (?f - file)
        :precondition (and 
            (committed ?f - file)
            (modified-in-workspace ?f - file)
        )
        :effect (and
            (clean ?f - file))
        )
    )
    
    ;; git reset -- <old-file>
    (:action git-reset
        :parameters (?f - file)
        :precondition (and 
            (staged ?f - file)
            (modified-in-workspace ?f - file)
        )
        :effect (and
            (not (staged ?f - file))
        )
    )
    
    ;; git reset -- <new-file>
    (:action git-reset-new
        :parameters (?f - file)
        :precondition (and 
            (staged ?f - file)
        )
        :effect (and
            (untracked ?f - file)
            (not (staged ?f - file))
        )
    )

    ;; git commit <file>
    (:action git-commit
        :parameters (?f - file)
        :precondition (and 
            (staged ?f - file)
        )
        :effect (and
            (committed ?f - file)
            (clean ?f - file)
        )
    )
)
