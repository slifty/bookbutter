$ () ->

  summary = []
  summaryId = 0
  bookId = 0

  #THIS IS A HACK
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

    # Generate Graph
    heights = [[],[],[],[],[],[],[],[],[]]
    for node in summary
      height = node.height
      order = node.order
      heights[height][order] = node

    # Get base compression
    integrity_levels = [100,50,25,12.5,6,3,1.5,.75]
    base_level = 100
    base_level_index = 0
    for integrity_level in integrity_levels
      if integrity > integrity_level
        break
      base_level = integrity_level
      base_level_index = _j

    # Node count of higher levels of compression
    nodeCount = Math.ceil(heights[0].length * (base_level / 100))
    difference = base_level - integrity
    smallerNodes = Math.floor(difference / 100 * nodeCount)
    if(smallerNodes == 0)
      skipLimit = nodeCount + 1
    else
      skipLimit = Math.floor(nodeCount / smallerNodes)
      # Skip must be even right now
      skipLimit = skipLimit + skipLimit % 2

    compressionMatrix = []
    skipCounter = 0
    for x in [1...nodeCount] by 1
      if(skipCounter == skipLimit)
        compressionMatrix.push base_level_index + 1
        _k++
        skipCounter = 0
      else
        compressionMatrix.push base_level_index
        skipCounter++


    # Generate Text
    console.log base_level_index
    first = heights[base_level_index]
    second = heights[base_level_index + 1]
    blocks = []
    counter = 0

    for level in compressionMatrix
      if level == base_level_index
        blocks.push first[counter]
      if level == base_level_index + 1
        blocks.push second[Math.floor(counter / 2)]
        counter++
      counter++

    textArray = []
    for block in blocks
      if block == undefined
        continue
      text = block.text
      paragraphs = text.split /[\n\r]+/
      for paragraph in paragraphs
        textArray.push "<p>" + paragraph + "</p>"

    $("#bookContent").html(textArray.join "")


  $("#integrityLevelSelect").change ()->
    integrity = $("#integrityLevelSelect").val()
    renderSummary summary, integrity

  #END HACK
