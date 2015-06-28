Server API:

Protocol: REST

/books GET

response:

[{
  id: 123,
  title: 'Sherlock Holmes',
  description: 'A guy figures things out.',
  sampleText: 'Blah blah blah blah',
  chapters: 23,
  paragraphs: 2847,
  screenshot: 'https://www.example.com/book.jpeg'
}, {
  ...
}]

/books/#{id}

{
  id: 123,
  title: 'Sherlock Holmes',
  description: 'A guy figures things out.',
  sampleText: 'Blah blah blah blah',
  chapters: 23,
  paragraphs: 2847,
  screenshot: 'https://www.example.com/book.jpeg'
}

/books/#{id}/start?chapters=1,2,3 POST // chapters is optional and defaults to every one

response: 

{
  summaryId: 1
}

/summaries GET # does not return paragraphs

[{
  bookId: 123
}, {
  bookId: 1234
}, {
  bookId: 123
}]

/summaries/#{summaryId} GET

response:

{
  bookId: 123, 
  paragraphs: [{
    compression: 0.00,
    id: 12
    parent: {
      compression: 0.05,
      id: 123
    }
  }]
}

/summaries/#{summaryId}/jobs GET

response:

[{
  text: "Blah blah blah",
  id: 123
}, {
  text: "Blah blah",
  id: 1234
}]

/summaries/#{summaryId}/jobs/summarize?ids=123,1234 POST

request:

{
  text: "Blah..."
}

response: 

{
  text: "Blah...",
  id: 12345
}



