<?php
require 'DbCache.php';
require 'Comic.php' ;
use PHPUnit\Framework\TestCase;

/**
 * Class Test
 */
final class Test extends TestCase
{
    /**
     * Test if the search word 'red' is found on comic number 5
     *
     * @return void
     */
    public function testSearchBlue(): void
    {
        $searchWord = 'red';
        $MAX_COMIC_NUMBER = 1952;
        $cache = new DbCache();

        //Search the persisted comics first.
        $comic = $cache->fetchComicIfExists($searchWord);
        if ($comic != null) {
            $this->assertEquals(5, $comic->getNumber());
            return;
        }

        //Search the REST response comics second.
        $comicNumbers = range($cache->getMaxNumber() + 1, $MAX_COMIC_NUMBER);
        foreach ($comicNumbers as $comicNumber) {
            $comic = new Comic($comicNumber, null);
            if (stripos($comic->getTranscript(), $searchWord) !== false) {
                $this->assertEquals(5, $comic->getNumber());
                return;
            }
        }
    }

    /**
     * Test if all the comic numbers before the max cached comic number are cached
     *
     * @return void
     */
    public function testAllCachedBeforeMax(): void
    {
        $cache = new DbCache();
        $comicNumbers = range(1, $cache->getMaxNumber());

        $conn = pg_pconnect("dbname=comics");
        $query = pg_query($conn, "SELECT id FROM xkcd ORDER BY id;");
        $results = pg_fetch_all($query);
        $cachedNumbers = [];
        foreach ($results as $result) {
            $cachedNumbers[] = $result['id'];
        }

        $this->assertEquals($cachedNumbers, $comicNumbers);
        return;
    }
}