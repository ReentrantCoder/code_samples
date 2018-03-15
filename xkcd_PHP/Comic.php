<?php
/**
 * Created by PhpStorm.
 * User: tylerbehm
 * Date: 3/15/18
 * Time: 1:20 PM
 */

/**
 * Class Comic
 * Encapsulation of XKCD web comic response data
 */
class Comic
{
    private $_number;
    private $_transcript;

    /**
     * Comic constructor.
     *
     * @param int $number
     * @param null|string $transcript
     */
    public function __construct(int $number, ?string $transcript)
    {
        $this->_number = $number;
        $this->_transcript = $transcript ?? $this->_fetchTranscriptRest();
    }

    /**
     * GET RESTful web request.
     *
     * @return string
     */
    private function _fetchTranscriptRest(): string
    {
        $url = "https://xkcd.com/{$this->_number}/info.0.json";
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $jsonResponse = curl_exec($ch);

        $comic = json_decode($jsonResponse);
        //TODO: THROW AN EXCEPTION INSTEAD
        return $comic->transcript ?? "";
    }


    /**
     * Redirect to XKCD web comic.
     */
    public function displayComicAndExit(): void
    {
        //Open the relevant XKCD URL in browser. Auto 302 status created.
        header("Location: http://www.xkcd.com/{$this->_number}/");
        exit("\n\nThe comic number is {$this->_number} \n\n");
    }

    /**
     * Getter.
     *
     * @return int
     */
    public function getNumber(): int
    {
        return $this->_number;
    }

    /**
     * Getter.
     *
     * @return string
     */
    public function getTranscript(): string
    {
        return $this->_transcript;
    }
}