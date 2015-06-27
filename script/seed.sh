#/bin/bash

mongo books --eval "db.books.drop()"

mongo books --eval "db.books.insert({
  'title': 'Test Book2',
  'description': 'Test description',
  'sampleText': 'BlahBlahBlah',
  'leaves': [{
    'text': 'first leaf',
    'chapter': 1
  }, {
    'text': 'second leaf',
    'chapter': 1
  }, {
    'text': 'third leaf',
    'chapter': 1
  }, {
    'text': 'fourth leaf',
    'chapter': 1
  }],
  'chapters': 7,
  'paragraphs': 2838
})"
