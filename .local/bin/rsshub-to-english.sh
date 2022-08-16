#!/bin/bash

### PIXIV ONLY!!


FILE="${HOME}/Downloads/rss-twitter/rss-pixiv-rsshub-SasaJ"
echo "$FILE"


function CHANGE-DESC()
{
	FULL_DESC=$(grep -m1 -E "画" $FILE | grep "<description>")
	echo "The full desc: $FULL_DESC"
	if [[ $FULL_DESC != *[!\ ]* ]]; then
		printf "finished"
		exit 0
	fi

	IMG_SRC=$(echo "$FULL_DESC" | sed 's/.*<img src/<img src/' | sed 's/>.*/>/')

	ARTIST=$(grep -m1 "author" $FILE | sed 's/.*CDATA\[//g' | sed 's/\]\].*//g')
	echo "$ARTIST"

	STATS=$(echo "$FULL_DESC" | sed "s/.*$ARTIST - //" | sed 's|</p>.*||')

	VIEWS=$(echo "$STATS" | sed 's/-.*$//' | sed 's/[^0-9]*//g')
	echo "$VIEWS"

	BOOKMARKS=$(echo "$STATS" | sed 's/^.*-//' | sed 's/[^0-9]*//g')
	echo "$BOOKMARKS"

	# manipulate description into its right form, then replace all of original description with the new.

	NEW_DESC="            <description><![CDATA[<p>Artist：$ARTIST - Views：$VIEWS - Bookmarks：$BOOKMARKS</p><p>$IMG_SRC</p>]]></description>"
	echo "$NEW_DESC"

	sed -i "s|.*$IMG_SRC.*|$NEW_DESC|" "$FILE"

}


# Fix the main artist title and subheading and language.
ARTIST_TTL=$(grep -m1 -E "<title>" $FILE | sed 's/.*\[CDATA\[//' | sed 's/\]\].*//')
echo "this is the artist ttl: $ARTIST_TTL"
MAIN_ARTIST=$(echo "$ARTIST_TTL" | sed 's/\s\S\s.*//')
echo "This is the main artist: $MAIN_ARTIST"
NEW_TTL="$MAIN_ARTIST / Pixiv"
NEW_TTL_FIELD="<title><![CDATA[$NEW_TTL]]></title>"
sed -i "s|<title>.*CDATA\[$MAIN_ARTIST\s\S\spixiv.*\]\]></title>|$NEW_TTL_FIELD|" "$FILE"

NEW_DESC_FIELD="<description><![CDATA[$MAIN_ARTIST / Pixiv feed - Made with love by RSSHub(https://github.com/DIYgod/RSSHub)]]></description>"
sed -i "s|<description>.*CDATA\[$MAIN_ARTIST\s\S\spixiv.*</description>|$NEW_DESC_FIELD|" "$FILE"

sed -i "s|<language>zh-cn</language>|<language>en</language>|" "$FILE"



while : ; do
	CHANGE-DESC
done


