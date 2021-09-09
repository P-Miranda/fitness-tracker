SHELL := /bin/bash # run command on bash instead of shell [source: https://stackoverflow.com/a/589300]

### Virtual Environment variables
VENV_PATH := .
VENV_NAME := fit_venv
VENV_LIBS := fitdecode

### Python Scripts
RENAME_SCRIPT := rename_fit.py

### Input Files
SRC_PATH ?= ./unprocessed
DST_PATH ?= ./Season_2021

run: $(DST_PATH)
	@(\
	source $(VENV_PATH)/$(VENV_NAME)/bin/activate;\
	python $(RENAME_SCRIPT) $(SRC_PATH) $(DST_PATH);\
	deactivate;\
	)

$(DST_PATH):
	@echo DST_PATH = $(DST_PATH) does not exist. Creating $(DST_PATH): 
	mkdir -p $@

setup:
	$(eval PYTHON_PATH = $(shell which python3))
	@echo Found Python3 path at $(PYTHON_PATH)
	@echo Creating virtual environment in $(VENV_PATH)/$(VENV_NAME)
	@(python3 -m venv $(VENV_PATH)/$(VENV_NAME))
	@echo Installing required libraries: $(VENV_LIBS)
	@(source $(VENV_PATH)/$(VENV_NAME)/bin/activate; pip install $(VENV_LIBS);deactivate;)
	@echo Setup complete.

clean:
	@rm -rf $(DST_PATH)/*.FIT $(SRC_PATH)/*.FIT
