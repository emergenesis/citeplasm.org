$ = jQuery

json_dir    = '/assets/citeplasm/javascripts'
json0       = "#{json_dir}/demo_initial_data.json"
json1       = "#{json_dir}/demo_graph_data.json"

log = (msg, error = false) ->
    if error
        $.error msg
    else
        console.log msg

$(document).ready () ->
    log "Loading demo..."

    $wizard     = $('.wizard')
    $graph      = $('.graph')

    # TODO do functions should check if it needs to be done, e.g. when coming from
    # farther ahead.
    # FIXME undo functions should be able to remove nodes (see T23)
    wizardDefinition = 
        panes:
            whatisagraph:
                do: () -> 
                    $graph.graphDemo
                        initial_data: json0
                    $graph.graphDemo 'start'
                undo: () ->
                    log 'Unable to remove nodes. NYI.', true
            webofdocs:
                do: () -> 
                    $graph.graphDemo 'add', json1
                undo: () ->
                    log 'Unable to remove nodes. NYI.', true
            linked:
                do: () ->
                    # If the graph is already in a linked state, i.e. we're
                    # coming from a future pane, don't toggle it.
                    if !$graph.hasClass 'linked'
                        $graph.graphDemo 'toggleState', 'linked'
                undo: () ->
                    $graph.graphDemo 'toggleState', 'linked'

    # panes: Lavoisier -> web documents -> linked documents -> semantic metadata -> notes/ideas -> papers
    # 1 - introduction  : overview of demo + reqs
    # 2 - lavoiser      : intro to research topic
    # 3 - web of docs   : a web of documents, unlinked
    # 4 - semantic md   : a single document now has facts about, shown in a different color
    # 5 - linked        : now all documents have md and are now linked
    # 6 - notes/papers  : user-generated content is also linked to the graph
    # 7 - social        : friends and colleagues are added to the graph

    $wizard.wizard wizardDefinition

