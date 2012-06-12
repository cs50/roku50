<?
    ini_set("display_errors", FALSE);
    date_default_timezone_set("America/New_York");

    // load global functions
    require_once(dirname(__FILE__) . "/functions.php");

    // load local functions, if any
    if (file_exists("./functions.php"))
        require_once("./functions.php");

    // autoload classes
    function __autoload($class_name)
    {
        switch ($class_name)
        {
            case "getID3":
                require_once(dirname(__FILE__) . "/../../lib/getid3/getid3/getid3.php");
                break;
        }
    }

    // Google Analytics
    $ANALYTICS = "";

    // authors
    $AUTHORS = array(array());

    // URL of CDN for current semester
    $CDN = "";

    // initial copyright year
    $COPYRIGHT = "";

    // favicon
    $FAVICON = "";

    // name of Google Group
    $GROUP = "";

    // languages
    $LANGUAGES = array(
     "af" => "Afrikaans",
     "sq" => "Albanian",
     "ar" => "Arabic",
     "hy" => "Armenian ALPHA",
     "az" => "Azerbaijani ALPHA",
     "eu" => "Basque ALPHA",
     "be" => "Belarusian",
     "bg" => "Bulgarian",
     "ca" => "Catalan",
     "zh-CN" => "Chinese (Simplified)",
     "zh-TW" => "Chinese (Traditional)",
     "hr" => "Croatian",
     "cs" => "Czech",
     "da" => "Danish",
     "nl" => "Dutch",
     "en" => "English",
     "et" => "Estonian",
     "tl" => "Filipino",
     "fi" => "Finnish",
     "fr" => "French",
     "gl" => "Galician",
     "ka" => "Georgian ALPHA",
     "de" => "German",
     "el" => "Greek",
     "ht" => "Haitian Creole ALPHA",
     "iw" => "Hebrew",
     "hi" => "Hindi",
     "hu" => "Hungarian",
     "is" => "Icelandic",
     "id" => "Indonesian",
     "ga" => "Irish",
     "it" => "Italian",
     "ja" => "Japanese",
     "ko" => "Korean",
     "lv" => "Latvian",
     "lt" => "Lithuanian",
     "mk" => "Macedonian",
     "ms" => "Malay",
     "mt" => "Maltese",
     "no" => "Norwegian",
     "fa" => "Persian",
     "pl" => "Polish",
     "pt" => "Portuguese",
     "ro" => "Romanian",
     "ru" => "Russian",
     "sr" => "Serbian",
     "sk" => "Slovak",
     "sl" => "Slovenian",
     "es" => "Spanish",
     "sw" => "Swahili",
     "sv" => "Swedish",
     "th" => "Thai",
     "tr" => "Turkish",
     "uk" => "Ukrainian",
     "ur" => "Urdu ALPHA",
     "vi" => "Vietnamese",
     "cy" => "Welsh",
     "yi" => "Yiddish"
    );

    // links
    $LINKS = array();

    // registration particuluars
    $REGISTRATION = array();

    // default states
    $STATES = array();
    
    // tabs
    $TABS = array(
     "l" => array(),
     "r" => array()
    );

    // title of site
    $TITLE = "";

    // URL of TV channel
    $TV = "";

    // load local configuration, if any
    if (file_exists("../config.php"))
        require_once("../config.php");
    if (file_exists("../../config.php"))
        require_once("../../config.php");
    if (file_exists("./config.php"))
        require_once("./config.php");

?>
