#!/bin/bash

episodes=$(sed -n -e '/^|/p' README.md | tail -n +3 | tail -r)
number=$(tail -r _data/episodes.yml | grep -m 1 "^- number: .*" | cut -d" " -f3 | xargs)
[[ -z $number ]] && number=1
while IFS= read -r ep; do
	date=$(cut -d '|' -f 2 <<< $ep | xargs)
	title=$(cut -d '|' -f 3 <<< $ep | cut -d "[" -f2 | cut -d "]" -f1)
	link=$(cut -d '|' -f 3 <<< $ep |  cut -d "(" -f2 | cut -d ")" -f1)
	notes=$(cut -d '|' -f 4 <<< $ep | cut -d "(" -f2 | cut -d ")" -f1)
    outputname=${title// /_}
    outputname=${outputname//\//\\}
    printf "Date : $date\nTitle : $title\nNotes : $notes\nLink : $link\n"

	if [ -f "audio/$outputname.mp3" ]; then 
		echo "File ($title) already exists"
	else
		echo "Downloading $title"
        # youtube-dl --extract-audio --audio-format mp3 --audio-quality 64K --postprocessor-args "-ar 44100 -ac 1" --restrict-filenames -o "$outputname.%(ext)s" "https://www.youtube.com/watch?v=sO65YihyZac"
		youtube-dl --extract-audio --audio-format mp3 --audio-quality 64K --postprocessor-args "-ar 44100 -ac 1" --restrict-filenames -o "$outputname.%(ext)s" "$link"
		echo "Compressing $title"
		sox "$outputname".mp3 audio/"$outputname".mp3 highpass 80 lowpass 8000 compand 0.01,1 -80,-80,-55,-20,-20,-15,0,0 0 -40 0.1 norm -0.5
		rm "$outputname".mp3
        description="$title"
        content=$(head -n30 "$notes" | sed 's/$/\\n/g' | tr -d '\n')
        content="${content//\"/\\\"}"
        enclosure="audio/${outputname}"
        length=$(stat -f "%z" "audio/${outputname}.mp3") 
        permalink="$link"
        tags=""
        topic=""
        { echo "- number: $number"; \
        echo "  title: \"$title\""; \
        echo "  date: $date"; \
        echo "  description: \"$description\""; \
        echo "  content: \"$content\""; \
        echo "  enclosure: $enclosure"; \
        echo "  length: $length"; \
        echo "  permalink: $permalink"; \
        echo "  tags: $tags"; \
        echo "  topic: $topic"; \
        echo ""; } >> _data/episodes.yml
        number=$((number+1))
        printf "\n\n"
	fi
done <<< "$episodes"