### Virtual Environment variables
VENV:=.venv
VENV_PYTHON:=$(VENV)/bin/python3

### Python Scripts
RENAME_SCRIPT := rename_fit.py

### Input Files
SRC_PATH ?= ./unprocessed
DST_PATH ?= ./Season_$(shell date +%Y)
FIT_PATH = /media/$(USER)/GARMIN/GARMIN/ACTIVITY
FIT_IN = $(patsubst $(FIT_PATH)/%.FIT, $(SRC_PATH)/%.FIT, $(wildcard $(FIT_PATH)/*.FIT))
NAS_PATH = /media/NAS_Home/Activities/Sport/GarminFR35/ACTIVITY/Season_$(shell date +%Y)

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

%.FIT: $(SRC_PATH) $(FIT_PATH)/$(@F)
	cp $(FIT_PATH)/$(@F) $@

clean:
	@rm -rf $(DST_PATH)/*.FIT $(SRC_PATH)/*.FIT
