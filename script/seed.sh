#/bin/bash

mongo tldr --eval "db.books.drop()"
mongo tldr --eval "db.summarynodes.drop()"

mongo tldr --eval "db.books.insert({
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

mongo tldr --eval "db.books.insert({
  'title': '7 Book2',
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
  }, {
    'text': 'fifth leaf',
    'chapter': 1
  }, {
    'text': 'sixth leaf',
    'chapter': 1
  }, {
    'text': 'seventh leaf',
    'chapter': 1
  }],
  'chapters': 7,
  'paragraphs': 2838
})"
