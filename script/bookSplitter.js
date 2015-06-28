var fs = require("fs");

// Some guidelines: each line is about 70 character
// the Average paragraph was 240, including one-liners
var MIN_CHARACTER_COUNT = 400;
var MAX_CHARACTER_COUNT = 800;
// Note: We split on two newlines in a row because GITenberg books seem to
// have newlines throughout the paragraph to keep proper spacing.
var PARAGRAPH_DELIMITER = "\n\n"

var breakIntoParagraphs = function(rawBookString) {
  var paragraphs = rawBookString.split(PARAGRAPH_DELIMITER);
  // We'll add the delimeters back so that the book will rejoin back to the 
  // exact original.
  for (var i = 0; i < paragraphs.length; i++) {
    // There are newbreaks at the end of each line for formatting reasons,
    // but we don't want those so we'll remove them.
    paragraphs[i] = paragraphs[i].replace(/\n/g, " ") + PARAGRAPH_DELIMITER;
  }
  return paragraphs;
}

var mergeSmallBlocks = function(blocks) {
  var processedBlocks = [];
  var currentBlock = "";
  for (var i = 0; i < blocks.length; i++) {
    currentBlock = currentBlock + blocks[i];
    if (currentBlock.length > MIN_CHARACTER_COUNT || i == blocks.length - 1) {
      processedBlocks.push(currentBlock);
      currentBlock = "";
    }
  }

  return processedBlocks;
}

var splitLargeBlocks = function(blocks) {
  var processedBlocks = [];
  // To find a reasonable split location, we'll choose the first end-of-sentence 
  // after the index of the minimum block length
  for (var i = 0; i < blocks.length; i++) {
    var currentBlock = blocks[i];
    while (currentBlock.length > MAX_CHARACTER_COUNT) {
      var splitIndex = MIN_CHARACTER_COUNT + currentBlock.substring(MIN_CHARACTER_COUNT).indexOf('.');
      if (splitIndex == -1) {
        console.warn("Large paragraph could not be split: could not find a sentence break.");
        break;
      } else {
        processedBlocks.push(currentBlock.substring(0, splitIndex + 1)); 
        currentBlock = currentBlock.substring(splitIndex + 1);
      }
    }
    processedBlocks.push(currentBlock); 
  }

  return processedBlocks;
}

var splitBook = function(bookData, callback) {
  var srcPath = bookData["filePath"];
  fs.readFile(srcPath, 'utf8', function (err, bookString) {
    if (err) {
      return console.log(err);
    }
    
    var blocks = breakIntoParagraphs(bookString);
    blocks = mergeSmallBlocks(blocks);
    blocks = splitLargeBlocks(blocks);
    return callback(bookData, blocks)
  });
}

exports.splitBook = splitBook;
