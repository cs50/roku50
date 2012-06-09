<?
    require_once(dirname(__FILE__) . "/config-2.php");

    // output XML
    header("Content-Type: text/xml; charset=UTF-8");
    
    // output UTF-8
    echo "<?xml version='1.0' encoding='UTF-8'?>\n";

    // infer pubDate
    $pubDate = "2011-02-11-01T00:00:00-05:00"; // default
    $path = parse_url($CDN, PHP_URL_PATH);
    if (preg_match("{/(\d+)/(.+)/}", $path, $matches))
    {
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
        $i = 10001;
        
        foreach ($TABS["l"] as $label => $id) 
        {
            // exclude some content from RSS
            if (!preg_match("/^(?:exams|lectures|projects|psets|quizzes|sections|votw|2011)$/", $id))
                continue;

            // load XML
            if (file_exists("./{$id}.xml"))
            {
                // get all bookmarks (because SimpleXML doesn't support XPath 2.0's ends-with function)
                $dom = simplexml_load_file("./{$id}.xml");
                $bookmarks =& $dom->xpath("//bookmark");
                
                // get all descriptions for future usage
                $descriptions =& $dom->xpath("//desc");

                // include only local MOVs, MP3s, and PDFs in RSS
                $keepers = array();
                foreach ($bookmarks as &$b)
                {
                    if (preg_match("{^$CDN}", $b["href"]) && preg_match("/\.(?:mov|mp3|mp4|pdf)$/", $b["href"]))
                        $keepers[] =& $b;
                }

                // output keepers
                foreach ($keepers as &$k)
                {
                    /*if ($_GET["output"] == "torrent")
                    {
                        $components = parse_url($k["href"]);
                        if (!file_exists("/srv/www/vhosts/{$components["host"]}/htdocs/{$components["path"]}.torrent"))
                            continue;
                    }*/
                    // begin outputting stuff here
                    
                    
                    echo "<item sdImg='' hdImg=''>";
                    echo "<title>";
                    $steps = ($dom->title) ? array($dom->title) : array(ucwords($id));
                    if ($steps[0] == "Votw") $steps[0] = "Videos of the Week"; // special case
                    foreach ($k->xpath("ancestor::folder") as $f)
                        $steps[] = $f->title;
                    /*
                    if (!preg_match("/^(?:MP3|PDF|QuickTime)$/", $k->title))
                        $steps[] = $k->title;
                    */
                    $steps[] = $k->title; // include "PDF" or such for items with multiple formats
                    // changes for roku50 
                    $rokutitle = array();
                    $rokutitle[0] = $steps[2];
                    $rokutitle[1] = $steps[4];
                    echo htmlspecialchars(join(", ", $rokutitle));
                    echo "</title>";
                    
                    echo "<contentId>";
                    echo $i;
                    echo "</contentId>";
                    $i++;
                    echo "<contentType>Talk</contentType>";
                    echo "<contentQuality>SD</contentQuality>";
                    echo "<media>";
                    echo "<streamFormat>";
                    preg_match("/\.([^\.]+)$/", $k["href"], $matches);
                    switch ($matches[1])
                    {
                        case "mov": echo "mov"; break;
                        case "mp3": echo "mp3"; break;
                        case "mp4": echo "mp4"; break;
                        case "pdf": echo "pdf"; break;
                    }
                    echo "</streamFormat>";
                    echo "<streamQuality>SD</streamQuality>";
                    echo "<streamBitrate>2000</streamBitrate>";
                    echo "<streamUrl>http://harvard.vo.llnwd.net/o18/cs50/2011/fall/".substr(htmlspecialchars($k["href"]), 25)."</streamUrl>";
                    echo "</media>";
                    echo "<synopsis>";
                    $week = $steps[2];
                    $description_incrementer = substr($week, 5);
                    echo htmlspecialchars($descriptions[$description_incrementer]);
                    echo "</synopsis>";
                    echo "<genres>";
                    echo htmlspecialchars(join(", ", $rokutitle));
                    echo "</genres>";                   
                    echo "<runtime></runtime>";
                    echo "</item>";
                }
            }
        }
    ?>
</feed>
