<?
    require_once(dirname(__FILE__) . "/config-2.php");

    // output XML
    header("Content-Type: text/xml; charset=UTF-8");
    
    // output UTF-8
    echo "<?xml version='1.0' encoding='UTF-8'?>\n";

    // infer pubDate
    $pubDate = "2011-02-11-01T00:00:00-05:00"; // default
    $path = parse_url($CDN, PHP_URL_PATH);
    if (preg_match("{/(\d+)/(.+)/}", $path, $matches)) {
        if ($matches[2] == "fall")
            $pubDate = "{$matches[1]}-09-01T00:00:00+00:00";
        else if ($matches[2] == "spring")
            $pubDate = "{$matches[1]}-02-01T00:00:00+00:00";
    }

?>

<feed>
    <resultLength>4</resultLength>
    <endIndex>4</endIndex>

    <?
        // incrementer for the content id
        $content_id = 1;

        // incrementer for seminar descriptions
        $seminar_incrementer = 0;

        foreach ($TABS["l"] as $label => $id) {
            // exclude some content from RSS
            if (!preg_match("/^(?:lectures|psets|quizzes|sections|seminars)$/", $id))
                continue;

            // load XML
            if (file_exists("./{$id}.xml")) {
                // get all bookmarks (because SimpleXML doesn't support XPath 2.0's ends-with function)
                $dom = simplexml_load_file("./{$id}.xml");
                $bookmarks =& $dom->xpath("//bookmark");

                // global array for subtitles and mp4 links
                $subtitles = array(); 
                $keepers = array();
                
                foreach ($bookmarks as &$b) {
                    // if files are links with extension .mp4 or .srt, sort to arrays
                    if (preg_match("{^$CDN}", $b["href"]) && preg_match("/\.mp4$/", $b["href"]))
                        $keepers[] =& $b;
                    if (preg_match("{^$CDN2}", $b["href"]) && preg_match("/\.srt$/", $b["href"]))
                        // store the subtitle links themselves
                        $subtitles[] =& $b["href"];
                }

                // output keepers
                foreach ($keepers as &$k) {
                    // gets descriptions
                    $desc = ($dom->desc) ? array($dom->desc) : array(ucwords($id));
                    // every instance of <desc>, we get the info
                    foreach ($k->xpath("ancestor::folder") as $m)
                        $desc[] = $m->desc;
                    $desc[] = $k->desc;

                    // for readability 
                    $video_description = $desc[1];
                    
                    // store description for lecture title modification
                    if ($id == "lectures") {
                        // store the description text in array
                        $description[$content_id] = $video_description;
                    }       
                    $first_lecture = true;
                    
                    // begin outputting stuff here
                    
                    // get the name of the video with explode()
                    $link_pieces = explode("/", $k["href"]); 
                    // get the last piece, and remove the mp4 extension
                    $image_url = substr($link_pieces[7], 0, -4);
                    echo "<item sdImg=\"http://cloud.cs50.net/~jessechen21/roku50/artwork/{$image_url}.png\" hdImg=\"http://cloud.cs50.net/~jessechen21/roku50/artwork/{$image_url}.png\">";
                    // echo "<item sdImg='' hdImg = ''>";
                    echo "<title>";
                    // gets titles
                    $steps = ($dom->title) ? array($dom->title) : array(ucwords($id));
                    foreach ($k->xpath("ancestor::folder") as $f)
                        $steps[] = $f->title;
                    $steps[] = $k->title;

                    // this is where actual title text is stored in the array
                    $title = $steps[1]; 
                                        
                    // accounting for the two lectures per week
                    if ($content_id > 1 && $id == "lectures") {
                        // if descriptions match, then must be second lecture
                        if ($description[$content_id] == $description[$content_id - 1]) {
                            $first_lecture = false;
                        }
                    }
                    
                    // if is not first lecture, put as continued
                    if ($first_lecture == false) {
                        echo $title.", continued";
                    }
                    else{
                        echo $title;
                    }                    
                    echo "</title>";
                    
                    // unique id for each video
                    $this_content_id = $content_id + 10000;
                    echo "<contentId>{$this_content_id}</contentId>";
                    
                    // subtitles corresponding with weeks 
                    echo "<subtitleUrl>";
                    if ($id == "lectures") {
                        // could not find a good way to determine whether something has subtitles or not
                        if ($content_id < 21)
                            echo $subtitles[$content_id - 1];
                        else if ($content_id  > 23)
                            echo $subtitles[$content_id - 4];
                    }
                    echo "</subtitleUrl>";
                    
                    // filler stuff that we don't use/care about
                    echo "<contentType>Talk</contentType>";
                    echo "<contentQuality>SD</contentQuality>";
                    echo "<media>";
                    echo "<streamFormat>mp4</streamFormat>";
                    echo "<streamQuality>HD</streamQuality>";
                    echo "<streamBitrate>2000</streamBitrate>";

                    // get the end of current urls due to lack of cdn working atm
                    echo "<streamUrl>http://harvard.vo.llnwd.net/o18/cs50/" . htmlspecialchars(substr($k["href"], 15)) . "</streamUrl>";
                    echo "</media>";
                    echo "<synopsis>";

                    // give credits
                    $credits = $k->xpath("ancestor::folder/info/metadata");
                    // seminars have credits already in the description
                    if ($id != "seminars") {
                        // apparently chr(10) is the newline character in BrightScript
                        echo $credits[0]."chr(10)";
                    }
                    // check if this video has a description
                    if ($video_description != "") {
                        // seminars have extra html tags
                        if ($id == "seminars") {
                            echo htmlspecialchars(strip_tags($video_description));
                        }
                        else if ($id == "lectures" || $id == "quizzes") {
                            echo htmlspecialchars($video_description);
                        }
                    }          
                    
                    // store description for lecture title
                    if ($id == "lectures") {
                        $description[$content_id] = $video_description;
                    }          
                    echo "</synopsis>";
                    echo "<genres>" . $title . "</genres>";
                    echo "<runtime>00:00</runtime>";
                    echo "</item>";

                    // increment identifier
                    $content_id++;
                }
            }
        }
    ?>
</feed>
