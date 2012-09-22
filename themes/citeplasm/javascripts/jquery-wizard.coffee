###
 Wizard Plugin for jQuery
 (c) 2012 Emergenesis
 Licensed Under the Terms of the GNU GPL v3 or later
###

$ = jQuery

wizardDefaultSettings = {}

log = (msg) ->
    console.log "[wizard] #{msg}"

get_pane = (id, panes) ->
    if id of panes
        return panes[id]
    return null

wizard = 
    init: (options) ->
        # Merge the options into the default settings. These are global, used
        # for each element in the following `each`. Element/graph-specific data
        # is stored in the element's `data`.
        wizardSettings = $.extend {}, wizardDefaultSettings, options
        
        # Processing for each element.
        return @each () ->
            $this = $(this)
            log "Initiating Wizard on #{@}"

            # We store the settings so other methods may access it.
            $this.data 'wizardSettings', wizardSettings

            # Let's store a reference to all the panes.
            $panes = $('.wizard-pane', $this)
            $active_pane = $panes.filter '.active'

            # Now let's match up the pane definitions provided 
            $panes.each () ->
                $pane = $(this)
                pane_id = $pane.attr('id')

                pane = get_pane pane_id, wizardSettings.panes
                if pane?
                    log "Pane #{$pane} has a definition"
                    pane.node = $pane
                else
                    log "Pane #{$pane} does not have a definition"

            # We first ensure there is a currently-active pane. If there isn't,
            # we simply select the first one and activate it.
            if $active_pane.length isnt 1
                log "There were no active panes. Activating first pane."
                
                $active_pane = $panes.filter(':first')
                $this.wizard 'show', $active_pane.attr('id')

    next: () ->
        return @each () ->
            console.log 'Advancing to next next pane.'
            $this = $(this)
            $panes = $('.wizard-pane', $this)
            $active = $ '.active', $this
            console.log $active

            if !$active?
                $.error 'Wizard was not initiated!'
                return
            
            active_id = $active.attr 'id'
            $next = $active.next('.wizard-pane')
            console.log $next
            if $next.length isnt 1
                log 'There is no next pane.'
                return

            $this.wizard 'show', $next.attr('id')

    show: (id) ->
        return @each () ->
            $this = $(this)
            $panes = $('.wizard-pane', $this)
            settings = $this.data 'wizardSettings'
            $active_pane = $panes.filter '.active'
            $target_pane = $ "##{id}"

            transition = $active_pane && $.support.transition && $active_pane.hasClass('fade')

            next = () ->
                $active_pane.removeClass 'active'
                $target_pane.addClass 'active'

                if transition
                    $target_pane.addClass 'in'

                # TODO run all steps in between this and the next.
            
                pane = get_pane id, settings.panes
                if pane?
                    pane.do()
            
            if transition 
                $active_pane.one($.support.transition.end, next)
            else
                next()

            $active_pane.removeClass 'in'


$.fn.wizard = (method) ->
    # global processing, applies to all elements

    if method of wizard
        wizard[method].apply this, Array.prototype.slice.call( arguments, 1 )
    else if  !method? || typeof method is 'object'
        wizard.init.apply this, arguments
    else
        $.error "Method #{method} is undefined on jQuery.wizard."

$ () ->
    $('body').on 'click.wizard.data-api', '[data-wizard-action="next"]', (e) ->
        e.preventDefault()
        target = $ $(this).data('target')
        target.wizard('next')

