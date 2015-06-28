
$ () ->

  # THIS IS A HACK

  $.get('books')
    .done (books) ->
      if books.length == 0
        alert "there aren't any books yet"
        return

      book = books[0]
      $.get('summaries')
        .done (summaries) ->
          summaryId = 0
          console.log(summaries)
          for summary in summaries
            if book._id == summary.bookId
              summaryId = summary._id
          if summaryId == 0
            $.post('/books/' + book._id + '/start')
              .done (response) ->
                summaryId = response.summaryId
                prepareJobs summaryId
          else
            prepareJobs summaryId


  # HACK IS OVER

  prepareJobs = (summaryId) ->
    $.get('/summaries/' + summaryId + '/jobs')
      .done (parts) ->
        console.log(parts)

  textLength = 900
  targetLength = textLength / 2
  tooShort = .9
  tooLong = 1.1
  circle = new ProgressBar.Circle '#progress',
    trailColor: '#ced4d8'
    strokeWidth: 10
    trailWidth: 1
    from:
      width: 10
    to:
      width: 10
    step: (state, circle) ->
      circle.path.setAttribute 'stroke-width', state.width
      if circle.value() < tooShort
        circle.path.setAttribute 'stroke', '#f1c40f'
      else if circle.value() > tooLong
        circle.path.setAttribute 'stroke', '#c0392b'
      else
        circle.path.setAttribute 'stroke', '#2ecc71'



  $('#summaryText').keyup () ->
    length = $(this).val().length
    ratio = length / targetLength
    circle.set ratio
    if ratio < tooShort
      $('#tooShort').show()
      $('#tooLong').hide()
      $('#justRight').hide()

    else if ratio > tooLong
      $('#tooShort').hide()
      $('#tooLong').show()
      $('#justRight').hide()

    else
      $('#tooShort').hide()
      $('#tooLong').hide()
      $('#justRight').show()

  $('#tooShort').hide()
  $('#tooLong').hide()
  $('#justRight').hide()

