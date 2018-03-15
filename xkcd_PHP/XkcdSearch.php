<?php
/**
 * GET requests served from ~/Sites as localhost
 * Accept search word as query string parameter or command line parameter
 **/

require 'DbCache.php';
require 'Comic.php' ;

if (empty($_GET['search']) and empty($argv[1])) {
    http_response_code(400);
    echo "Provide a search query string parameter or command line arguement.";
    return;
}

//get the search word from the user input
$searchWord = $_GET['search'] ?? $argv[1];
const MAX_COMIC_NUMBER = 1952;

$cache = new DbCache();

//TODO: Create a PHPUnit to assert that 'red' returns comic number 4 or whatever it is
//TODO: Create a PHPUnit to assert that all comics below $cache->getMaxNumber() are persisted

//Search the persisted comics first.
$comic = $cache->fetchComicIfExists($searchWord);
if ($comic != null) {
    $comic->displayComicAndExit();
}

//Search the REST response comics second.
$comicNumbers = range($cache->getMaxNumber() + 1, MAX_COMIC_NUMBER);
foreach ($comicNumbers as $comicNumber) {
    $comic = new Comic($comicNumber, null);

    //Persist the comic objects as they are retrieved.
    $cache->persistComic($comic);

    //If the transcript has the search word, display and exit
    if (stripos($comic->getTranscript(), $searchWord) !== false) {
        $comic->displayComicAndExit();
    }
}

//If it's not in the REST response, there is no XKCD with that search word.
http_response_code(404);
exit("\n\nNo relevant XKCD comic found for search word: {$searchWord}.\n\n");

