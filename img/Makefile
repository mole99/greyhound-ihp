PRIMITIVES_ODG := $(wildcard odg/*.odg)

PRIMITIVES_SVG = $(patsubst odg/%.odg,svg/%.svg,$(PRIMITIVES_ODG))
PRIMITIVES_PNG = $(patsubst odg/%.odg,png/%.png,$(PRIMITIVES_ODG))
PRIMITIVES_PDF = $(patsubst odg/%.odg,pdf/%.pdf,$(PRIMITIVES_ODG))

all: $(PRIMITIVES_SVG) $(PRIMITIVES_PNG) $(PRIMITIVES_PDF)

svg/%.svg: odg/%.odg
	soffice --convert-to svg --outdir svg/ $<

png/%.png: odg/%.odg
	soffice --convert-to png --outdir png/ $<

pdf/%.pdf: odg/%.odg
	soffice --convert-to pdf --outdir pdf/ $<

clean:
	rm png/*
	rm svg/*
	rm pdf/*
