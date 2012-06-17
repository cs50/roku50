<?
    require_once(dirname(__FILE__) . "/config.php");

    // ensure leaf was specified
    if (!isset($_GET["leaf"]))
        exit;

    // ensure leaf exists
    if (!in_array($_GET["leaf"], array("lectures", "sections", "supersections", "psets", "quizzes", "seminars")))
        exit;

    // ensure XML exists
    if (!file_exists("{$_GET["leaf"]}.xml"))
        exit;

    // output XML
    header("Content-Type: text/xml; charset=UTF-8");
    
    // output UTF-8
    echo "<?xml version='1.0' encoding='UTF-8'?>\n";

?>

<feed>
    <?
        // get all bookmarks (because SimpleXML doesn't support XPath 2.0's ends-with function)
        $dom = simplexml_load_file("./{$_GET["leaf"]}.xml");
        $bookmarks = $dom->xpath("//bookmark");

        // global array for subtitles and MP4 links
        $subtitles = array(); 
        $keepers = array();
     
        // get MP4s' URLs           
        foreach ($bookmarks as $b)
        {
            // if files are links with extension .{mov,mp4}
            if (preg_match("{^(?:$CDN|$TV)}", $b["href"]) && preg_match("/\.(?:mov|mp4)$/", $b["href"]) && !preg_match("{lectures/11/cs}", $b["href"]))
                $keepers[] = $b;
        }

        echo "<resultLength>" . count($keepers) . "</resultLength>";
        echo "<endIndex>" . count($keepers) . "</endIndex>";

        // output keepers
        foreach ($keepers as $k)
        {
            // parse URL
            $components = parse_url($k["href"]);
            $pathinfo = pathinfo($components["path"]);

            // protect against ..
            if (preg_match("/\.\./", $components["path"]))
            	exit;

            // infer cdn
            $cdn = cdn($_SERVER["HTTP_HOST"]);

            // determine video's local path
            $htdocs = dirname(__FILE__) . "/../../vhosts/$cdn/htdocs";

            // item
            if (file_exists($htdocs . "/" . preg_replace("/\.mp4$/", ".png", $components["path"])))
                $img = "http://{$cdn}" . preg_replace("/\.mp4$/", ".png", $components["path"]);
            else
                $img = "http://cs50.tv/property.png"; // hard-coded for CS50 for now
            echo "<item sdImg='{$img}' hdImg='{$img}'>";
            echo "<title>";
            $title = array_shift($k->xpath("../../../title | ../../title | ../title"));
            if (isset($priorTitle) && $priorTitle == $title)
                echo htmlspecialchars("{$title}, continued");
            else
                echo htmlspecialchars($title);
            echo "</title>";
            $priorTitle = $title;
             
            // contentID
            echo "<contentId>{$k["href"]}</contentId>";
                    
            // subtitleUrl
            if (file_exists($htdocs . "/" . preg_replace("/\.mp4$/", ".srt", $components["path"])))
            {
                echo "<subtitleUrl>";
                echo "http://{$cdn}" . preg_replace("/\.mp4$/", ".srt", $components["path"]);
                echo "</subtitleUrl>";
            }

            // content*
            echo "<contentType>Talk</contentType>";
            echo "<contentQuality>SD</contentQuality>";

            // media
            echo "<media>";
            echo "<streamFormat>mp4</streamFormat>";
            echo "<streamQuality>SD</streamQuality>";
            echo "<streamBitrate>640</streamBitrate>";
            echo "<streamUrl>http://harvard.vo.llnwd.net/o18/cs50" . $components["path"] . "</streamUrl>";
            echo "</media>";

            // synopsis
            echo "<synopsis>";
            echo htmlspecialchars(array_shift($k->xpath("../../../desc | ../../desc | ../desc")));
            echo "</synopsis>";

            // analyze video
            $getID3 = new getID3();
            $analysis = $getID3->analyze("{$htdocs}/{$components["path"]}");
                    
            // runtime
            if (preg_match("/^(\d+):(\d{2})$/", $analysis["playtime_string"], $matches))
                echo "<runtime>" . ($matches[1] * 60 + $matches[2]) . "</runtime>";

            // genres
            //echo "<genres>" . htmlspecialchars(array_shift($k->xpath("../../title"))) . "</genres>";

            echo "</item>";
        }
    ?>
</feed>
