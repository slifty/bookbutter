var bookSplitter = require ("./bookSplitter");
var mongoose = require("../dist/server/models/mongoose.js");
var bookModel = require("../dist/server/models/book.js");

var BOOK_DIR = __dirname + "/books/";
var BOOK_DATA = [
  {
    "filePath"   : BOOK_DIR + "The-Adventures-of-Sherlock-Holmes-Adventure-I.txt",
    "imageUrl"   : "http://www.gutenberg.org/cache/epub/48320/pg48320.cover.medium.jpg",
    "title"      : "The Adventures of Sherlock Holmes",
    "subtitle"   : "Adventure I",
    "chapters"   : 0,
    "paragraphs" : 0
  }
];

var createBook = function(bookData, blocks) {
  var leaves = [];
  for (var i = 0; i < blocks.length; i++) {
    var nextLeaf = new bookModel.Leaf({
      text: blocks[i],
      chapter: 1
    });
    leaves.push(nextLeaf);
  }
  console.log("saving book");
  var book = new bookModel.Book({
    title: bookData["title"],
    subtitle: bookData["subtitle"],
    imageUrl: bookData["imageUrl"],
    description: "description",
    sampleText: "sampletext",
    leaves: leaves,
    chapters: 0,
    paragraphs: 0
  });
  book.save(function (err) {if (err) console.log(err)});
}

for (var i = 0; i < BOOK_DATA.length; i++) {
  bookSplitter.splitBook(BOOK_DATA[i], createBook);
}

