export PDK 		?= ihp-sg13g2
export FABRIC 		?= classic_fabric_greyhound
export TILE_LIBRARY 	?= classic

$(info $(PDK))
$(info $(FABRIC))
$(info $(TILE_LIBRARY))

# Get the design names
DESIGNS :=  $(patsubst designs/${TILE_LIBRARY}/%/,%,$(wildcard designs/${TILE_LIBRARY}/*/)) 

DESIGNS_CLEAN := $(addsuffix -clean,$(DESIGNS))
DESIGNS_SYNTH := $(addsuffix -synth,$(DESIGNS))
DESIGNS_PNR := $(addsuffix -pnr,$(DESIGNS))
DESIGNS_BIT := $(addsuffix -bit,$(DESIGNS))
DESIGNS_HEX := $(addsuffix -hex,$(DESIGNS))

all: $(DESIGNS)
.PHONY: all

clean: $(DESIGNS_CLEAN)
.PHONY: clean

$(DESIGNS):
	cd designs/${TILE_LIBRARY}/$@; make
.PHONY: $(DESIGNS)

$(DESIGNS_CLEAN):
	cd designs/${TILE_LIBRARY}/$(subst -clean,,$@); make clean
.PHONY: $(DESIGNS_CLEAN)

$(DESIGNS_SYNTH):
	cd designs/${TILE_LIBRARY}/$(subst -synth,,$@); make synth
.PHONY: $(DESIGNS_SYNTH)

$(DESIGNS_PNR):
	cd designs/${TILE_LIBRARY}/$(subst -synth,,$@); make pnr
.PHONY: $(DESIGNS_PNR)

$(DESIGNS_BIT):
	cd designs/${TILE_LIBRARY}/$(subst -synth,,$@); make bitstream
.PHONY: $(DESIGNS_BIT)

$(DESIGNS_HEX):
	cd designs/${TILE_LIBRARY}/$(subst -synth,,$@); make hex
.PHONY: $(DESIGNS_HEX)
