IN ?= metroid4
OUT := m4rs

OBJ_DIR := ./obj
BIN_DIR := ./bin

ifeq ($(OS),Windows_NT)
	FLIPS := ./tools/flips.exe
	AS := ./tools/armips-a8d71f0.exe
else
	# Assume unix just has it in PATH
	FLIPS := flips
	AS := armips
endif

OPTIONALS := bombless_pbs
OPTIONALS += missiles_without_mains
OPTIONALS += anti_softlock
OPTIONALS += unhidden_map
OPTIONALS += unhidden_map_doors

OBJS := $(OPTIONALS:%=$(OBJ_DIR)/%.gba)
PATCHES := $(OPTIONALS:%=$(BIN_DIR)/%.ips)

# Command Line flags
BUILD_TYPE := debug
ifeq ($(BUILD_TYPE), debug)
    BUILD_SYMBOL := -definelabel DEBUG 1
	SYMBOL_DATA_ARMIPS_OPTION := -sym $(BIN_DIR)/$(OUT)-symbols.sym
else
    BUILD_SYMBOL = -definelabel DEBUG 0
    SYMBOL_DATA_ARMIPS_OPTION :=
endif

OPTIMIZE := true
ifeq ($(OPTIMIZE), true)
    OPTIMIZE_SYMBOL := -definelabel OPTIMIZE 1
else
    OPTIMIZE_SYMBOL = -definelabel OPTIMIZE 0
endif

QOL := true
ifeq ($(QOL), true)
    QOL_SYMBOL := -definelabel QOL 1
else
    QOL_SYMBOL = -definelabel QOL 0
endif

PHYSICS_CHANGES := false
ifeq ($(PHYSICS_CHANGES), true)
    PHYSICS_SYMBOL := -definelabel PHYSICS 1
else
    PHYSICS_SYMBOL = -definelabel PHYSICS 0
endif

MODIFICATION_MODE := randomizer
ifeq ($(MODIFICATION_MODE), randomizer)
    RANDOMIZER_SYMBOL := -definelabel RANDOMIZER 1
    NONLINEAR_SYMBOL := -definelabel NONLINEAR 1
else ifeq ($(MODIFICATION_MODE), nonlinear)
    RANDOMIZER_SYMBOL := -definelabel RANDOMIZER 0
    NONLINEAR_SYMBOL := -definelabel NONLINEAR 1
else
    RANDOMIZER_SYMBOL := -definelabel RANDOMIZER 0
    NONLINEAR_SYMBOL := -definelabel NONLINEAR 0
endif


ALL_SYMBOLS = $(BUILD_SYMBOL) $(OPTIMIZE_SYMBOL) $(QOL_SYMBOL) $(PHYSICS_SYMBOL) $(RANDOMIZER_SYMBOL) $(NONLINEAR_SYMBOL)

all: $(BIN_DIR)/m4rs.gba

$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

$(BIN_DIR)/$(OUT).gba: check | $(OBJ_DIR) $(BIN_DIR)
	$(AS) $(SYMBOL_DATA_ARMIPS_OPTION) $(ALL_SYMBOLS) src/main.s
	cp $(OBJ_DIR)/$(OUT).gba $@

$(OBJ_DIR)/base.gba: $(BIN_DIR)/$(OUT).gba | $(OBJ_DIR)
	cp $< $@

$(OBJ_DIR)/%.gba: check | $(OBJ_DIR)
	$(AS) $(SYMBOL_DATA_ARMIPS_OPTION) $(ALL_SYMBOLS) -definelabel $* 1 src/main.s
	mv $(OBJ_DIR)/$(OUT).gba $@

$(BIN_DIR)/%.ips: $(OBJ_DIR)/%.gba $(OBJ_DIR)/base.gba
	$(FLIPS) -c $(OBJ_DIR)/base.gba $< $@

$(BIN_DIR)/$(OUT).bps: $(OBJ_DIR)/base.gba
	$(FLIPS) -c $(IN).gba $< $@

check: $(IN).gba
	md5sum -c $(IN).md5

dist: $(PATCHES) $(BIN_DIR)/$(OUT).bps

clean:
	$(RM) $(OBJ_DIR)/*
	$(RM) $(BIN_DIR)/*

help:
	@echo "Makefile for building the project"
	@echo ""
	@echo "Targets:"
	@echo "  all		- Build the project."
	@echo "  dist		- Builds the project and creates BPS/IPS patches for all optional configurations."
	@echo "  clean		- Remove all compiled binaries and patches."
	@echo "  help		- Displays this help message."
	@echo ""
	@echo "Build Options:"
	@echo "  BUILD_TYPE		- Sets the build type. Possible values are debug and release. Defaults to debug."
	@echo "  OPTIMIZE		- Sets whether to optimize certain routines. Only change is higher performance. Possible values are true and false. Defaults to true."
	@echo "  QOL			- Sets whether to apply non-essential but convenient features. Possible values are true and false. Defaults to true."
	@echo "  PHYSICS_CHANGES 	- Sets whether to apply Physics changes which alter Samus movement drastically. Possible values are true and false. Defaults to false."
	@echo "  MODIFICATION_MODE	- Sets what kind of modifications should be applied. Possible values are randomizer, nonlinear and vanilla. Defaults to randomizer."
	@echo ""

.PHONY: all check clean dist
.INTERMEDIATE: $(OBJS)
