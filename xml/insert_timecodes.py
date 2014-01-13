import xml.etree.ElementTree as ET
import os

dirs = ['lectures', 'shorts', 'psets', 'walkthroughs', 'seminars', 'quizzes', 'sections']
years = ['2012']
INDEX = 'index.xml'

# for each year in the years list, go through all category dirs and insert subtitle URLs
for year in years:
	for _dir in dirs:
		# 2012 did not have a walkthroughs directory
		if year == '2012' and _dir == 'walkthroughs':
			continue

		tree = ET.parse(os.path.join(year, 'fall', _dir, INDEX))
		root = tree.getroot()

		feed = root

		# for each item in the feed, if it is an item
		for item in feed:
			if item.tag != 'item':
				continue

			# grab path to video to generate subtitle URL
			video_path = os.path.dirname(item[1].text)

			# grab video name to append to dirs down below for srt path
			video_name = os.path.basename(item[1].text).split('-')[0]

			subtitle_tag = ET.Element('subtitleURL')

			if int(year) <= 2012:
				english_dir = 'eng'
			else:
				english_dir = 'en'

			subtitle_tag.text = os.path.join(video_path, 'lang', english_dir, video_name + '.srt')
			item.insert(2, subtitle_tag)

		filepath = os.path.join(year, 'fall', _dir, 'new_' + INDEX)
		tree.write(filepath)