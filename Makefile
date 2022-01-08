.PHONY: audio clean

audio:
	@echo "Downloading audio files...\n"
	@./download.sh

clean: 
	@rm -f *.mp3
	@rm -f *.webm
	@rm -f *.part
	@rm -f *.m4a
	
# youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 -q --restrict-filenames -o "%(title)s-%(id)s.%(ext)s"
# sox $1 -c 1 -C 64 -r 44.1k $outputname highpass 80 lowpass 8000 compand 0.01,1 -80,-80,-55,-20,-20,-15,0,0 0 -40 0.1 norm -0.5


