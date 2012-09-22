$ = jQuery

$(document).ready () ->
    console.log "Loading demo..."

    $wizard     = $('.wizard')

    wizardDefinition = 
        panes:
            unlinked:
                name: "Unlinked"
                do: () -> 
                    console.log "Doing unlinked..."
                    return true
                undo: () ->
                    console.log "Undoing unlinked..."
                    return true

    $wizard.wizard wizardDefinition
