<?php
/**
 * Created by PhpStorm.
 * User: tylerbehm
 * Date: 3/15/18
 * Time: 1:20 PM
 */

/**
 * Class DbCache
 * Local cache that is faster that making a web request.
 */
class DbCache
{
    private $_conn;

    /**
     * DbCache constructor.
     */
    public function __construct()
    {
        $this->_conn = pg_pconnect("dbname=comics");
        $tableQuery = pg_query(
            $this->_conn,
            "SELECT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'xkcd');"
        );
        $tableExists = (pg_fetch_all($tableQuery)[0]['exists'] == "t");
        if (!$tableExists) {
            pg_query(
                $this->_conn,
                "CREATE TABLE xkcd (id INT PRIMARY KEY, transcript VARCHAR);"
            );
        }
    }

    /**
     * Fetch the first persisted comic relevant to the search word.
     *
     * @param string $searchWord
     * @return Comic|null
     */
    public function fetchComicIfExists(string $searchWord): ?Comic
    {
        $query = pg_query($this->_conn, "SELECT * FROM xkcd;");
        $results = pg_fetch_all($query);
        foreach ($results as $rowNumber => $rowResult) {
            if (stripos($rowResult['transcript'], $searchWord) !== false) {
                return new Comic($rowResult['id'], $rowResult['transcript']);
            }
        }
        return null;
    }

    /**
     * Persist the comic
     *
     * @param Comic $comic
     */
    public function persistComic(Comic $comic): void
    {
        pg_insert(
            $this->_conn,
            'xkcd',
            ['id' => $comic->getNumber(), 'transcript' => $comic->getTranscript()]
        );
    }

    /**
     * Getter for the maximum comic number persisted.
     * All lower comic numbers should already be persisted.
     *
     * @return int
     */
    public function getMaxNumber(): int
    {
        $query = pg_query($this->_conn, "SELECT MAX(id) FROM xkcd;");
        $result = pg_fetch_all($query)[0]['max'];
        return $result;
    }
}