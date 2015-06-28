$ () ->

  summary = []
  summaryId = 0
  bookId = 0

  # THIS IS ALL A HACK
  # Load the first book

  $.get('books')
    .done (books) ->
      if books.length == 0
        alert "there aren't any books yet"
        return

      book = books[0]
      bookId = book._id
      $.get('summaries')
        .done (summaries) ->
          for summary in summaries
            if book._id == summary.bookId
              summaryId = summary._id
          if summaryId == 0
            alert "there isn't a summary yet"
            return
          else
            loadBook bookId, summaryId

  loadBook = (bookId, summaryId) ->
    $.get('summaries/' + summaryId)
      .done (summaryArray) ->
        summary = buildSummary summaryArray
        renderSummary summary, 100

  buildSummary = (summaryArray) ->
    return summaryArray

  renderSummary = (summary, integrity) ->
    loss = 100 - integrity
    # Each node contributes 100 * 1/N * compression_level of loss
    # so with 100 nodes, if you had ONE node at 50% compression, it would be an integrity level of 99.5%
    # Step 1 is to define base compression
    # Step 2 is to identify how many nodes will be base+1 compression
    # Step 3 is to distribute those nodes
    # Step 4 is to select the nodes

    # Get base compression
    integrity_levels = [100,50,25,12.5,6,3,1.5,.75]
    base_level = 100
    for integrity_level in integrity_levels
      if integrity > integrity_level
        break
      base_level = integrity_level

    # Node count of higher levels of compression
    nodeCount = Math.ceil(summary.length * (base_level / 100))
    difference = base_level - integrity
    smallerNodes = Math.floor(difference / 100 * nodeCount)
    if(smallerNodes == 0)
      skipLimit = nodeCount + 1
    else
      skipLimit = Math.floor(nodeCount / (smallerNodes + 1))

    compressionMatrix = []
    skipCounter = 0
    for x in [1...nodeCount] by 1
      if(skipCounter == skipLimit)
        compressionMatrix.push base_level / 2
        _j++
        skipCounter = 0
      else
        compressionMatrix.push base_level
      skipCounter++

    $("#integrityLevelSelect").change ()->
      integrity = $("#integrityLevel").val()
      renderSummary summary, integrity

  #END HACK
