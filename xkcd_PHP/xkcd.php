<?php
    //GET requests served from ~/Sites as localhost
    //Accept search word as query parameter or command line arguement
    if (empty($_GET['search']) and empty($argv[1])) {
        http_response_code(400);
        echo "Provide a search query parameter or command line arguement.";
        return;
    }
    
    //get the search word from the user input
    $search_word = $_GET['search'] ?? $argv[1];
    const MAX_COMIC_NUM = 1952; //1952 Max number comic as of 2/11/18
    
    $conn = pg_pconnect("dbname=comics");
    /** DB setup
     createdb comic
     CREATE TABLE xkcd (id INT PRIMARY KEY, transcript VARCHAR);
     */
    
    function getComicRest(int $comic_num): StdClass {
        $url = "https://xkcd.com/{$comic_num}/info.0.json";
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $json_response = curl_exec($ch);    //GET RESTful web request
        return json_decode($json_response);
    }
    
    function checkCache(string $search_word, $conn): int {
        $result = pg_query($conn, "SELECT * FROM xkcd");
        $arr = pg_fetch_all($result);
        foreach ($arr as $row_num => $row_result) {
            if (stripos($row_result['transcript'], $search_word) !== false) {
                return $row_result['id'];
            }
        }
        return -1*$row_result['id'];
    }
    
    function displayComic(int $comic_num) {
        //Open the relevant XKCD URL in browser. Auto 302 status created.
        header("Location: http://www.xkcd.com/{$comic_num}/");
        exit("\n\nThe comic number is {$comic_num} \n\n");
    }
    
    //Search the persisted comics first. It's a cache. Make an new class for this.
    $cache_num = checkCache($search_word, $conn);
    if ($cache_num > 0) {
        displayComic($cache_num);
    }
    
    $comic_nums = range((-1 * $cache_num) + 1, MAX_COMIC_NUM);
    foreach($comic_nums as $comic_num) {
        $comic = getComicRest($comic_num);
        //Persist the comic objects as they are retrieved.
        $result = pg_insert($conn, 'xkcd', ['id' => $comic->num, 'transcript' => $comic->transcript]);
        if (stripos($comic->transcript, $search_word) !== false) {
            displayComic($comic->num);
        }
    }
    http_response_code(404);
    exit("\n\nNo relevant XKCD comic found for search word: {$search_word}.\n\n");

