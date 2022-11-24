### Virtual Environment variables
VENV:=.venv
VENV_PYTHON:=$(VENV)/bin/python3

### Python Scripts
RENAME_SCRIPT := rename_fit.py

### Input Files
SRC_PATH ?= ./unprocessed
DST_PATH ?= ./Season_$(shell date +%Y)

run: $(DST_PATH) $(VENV)
	$(VENV_PYTHON) $(RENAME_SCRIPT) $(SRC_PATH) $(DST_PATH)

$(DST_PATH):
	@echo DST_PATH = $(DST_PATH) does not exist. Creating $(DST_PATH): 
	mkdir -p $@

$(VENV): requirements.txt
	python3 -m venv $(VENV)
	$(VENV_PYTHON) -m pip install --upgrade pip
	$(VENV_PYTHON) -m pip install -r requirements.txt

clean:
	@rm -rf $(DST_PATH)/*.FIT $(SRC_PATH)/*.FIT
