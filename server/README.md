Server API:

Protocol: REST

/books GET

response:

[{
  id: 123,
  name: 'Sherlock Holmes',
  description: 'A guy figures things out.',
  sampleText: 'Blah blah blah blah',
  chapters: 23,
  paragraphs: 2847
}, {
  ...
}]

/books/start?bookId=4&chapters=1,2,3 POST // chapters is optional and defaults to every one

response: 

{
  summaryId: 1
}

/summaries/#{summaryId}?compression=<=50% GET // compression is optional and defaults to 0%

response:

{
  maxCompression: 0.25, 
  compression: 0.25,
  text: "Blah blah blah" // the most compressed version that is <= to `compression`
}

/jobs GET

response:

[{
  text: "Blah blah blah",
  id: 123
}, {
  text: "Blah blah",
  id: 1234
}]

/jobs/summarize?ids=123,1234 POST

request:

{
  text: "Blah..."
}

response: 

{
  text: "Blah...",
  id: 12345
}



