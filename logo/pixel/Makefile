make_image:
	# TopMetal2.drawing 134:0
	python3 make_gds.py img/greyhound_drawing.png gds/greyhound_logo_drawing.gds --cellname greyhound_logo --scale 1.0 --pixel-size 2 --threshold 128 --merge --layer 134 --datatype 0 --invert #--invert-alpha
	
	# TopMetal2.nofill 134:23
	python3 make_gds.py img/greyhound_nofill.png gds/greyhound_logo_nofill.gds --cellname greyhound_logo --scale 1.0 --pixel-size 2 --threshold 128 --merge --layer 134 --datatype 23 --invert #--invert-alpha
	
	python3 combine_gds.py gds/greyhound_logo_drawing.gds gds/greyhound_logo_nofill.gds gds/greyhound_logo.gds
	
.PHONY: make_image
