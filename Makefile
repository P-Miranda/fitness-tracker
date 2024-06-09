### Virtual Environment variables
VENV:=.venv
VENV_PYTHON:=$(VENV)/bin/python3

# Supported devices: 
# - [FR35]: Garmin Forerunner 35
# - [FR255]: Garmin Forerunner 255
DEVICE ?= FR255

### Python Scripts
RENAME_SCRIPT := rename_fit.py

### Input Files
SRC_PATH ?= ./unprocessed
DST_PATH ?= ./Season_$(shell date +%Y)
ifeq ($(DEVICE), FR35)
FIT_PATH = /media/$(USER)/GARMIN/GARMIN/ACTIVITY
FIT_IN = $(patsubst $(FIT_PATH)/%.FIT, $(SRC_PATH)/%.FIT, $(wildcard $(FIT_PATH)/*.FIT))
NAS_PATH = /media/NAS_Home/Activities/Sport/GarminFR35/ACTIVITY/Season_$(shell date +%Y)
else ifeq ($(DEVICE), FR255)
MOUNT_PATH = $(HOME)/GARMIN-FR255
FIT_PATH = $(MOUNT_PATH)/Internal\ Storage/GARMIN/Activity
FIT_IN = mount-mtp
FIT_IN += copy-fit-files
NAS_PATH = /media/NAS_Home/Activities/Sport/GarminFR255/Activity/Season_$(shell date +%Y)
endif

run: $(DST_PATH) $(VENV) $(FIT_IN)
	$(VENV_PYTHON) $(RENAME_SCRIPT) $(SRC_PATH) $(DST_PATH)
	cp -u $(DST_PATH)/*.FIT $(NAS_PATH)

$(NAS_PATH) $(SRC_PATH) $(DST_PATH):
	@echo PATH = $(@) does not exist. Creating $(@): 
	mkdir -p $@

$(VENV): requirements.txt
	python3 -m venv $(VENV)
	$(VENV_PYTHON) -m pip install --upgrade pip
	$(VENV_PYTHON) -m pip install -r requirements.txt

mount-mtp: $(MOUNT_PATH)
	jmtpfs $(MOUNT_PATH)

$(MOUT_PATH):
	mkdir -p $(MOUNT_PATH)

%.FIT: $(SRC_PATH) $(FIT_PATH)/$(@F)
	cp $(FIT_PATH)/$(@F) $@

copy-fit-files:
	cp $(FIT_PATH)/*.fit $(SRC_PATH)

clean:
	@rm -rf $(DST_PATH)/*.FIT $(SRC_PATH)/*.FIT
	@rm -rf $(DST_PATH)/*.fit $(SRC_PATH)/*.fit
