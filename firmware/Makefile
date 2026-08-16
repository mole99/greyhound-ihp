SUBDIRS := $(patsubst %/.,%,$(wildcard */.))
SUBDIRS_ALL := $(addsuffix -all,$(SUBDIRS))
SUBDIRS_CLEAN := $(addsuffix -clean,$(SUBDIRS))

$(info $(SUBDIRS))
#$(info $(SUBDIRS_ALL))
#$(info $(SUBDIRS_CLEAN))

all: $(SUBDIRS_ALL)
clean: $(SUBDIRS_CLEAN)
.PHONY: all clean

$(SUBDIRS_ALL): bsp-all
	$(MAKE) -C $(subst -all,,$@) all
.PHONY: $(SUBDIRS_ALL)

$(SUBDIRS_CLEAN):
	$(MAKE) -C $(subst -clean,,$@) clean
.PHONY: $(SUBDIRS_CLEAN)
