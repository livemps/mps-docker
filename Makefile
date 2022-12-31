# +++++ Configuration +++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
# --- Makefile Setup ---#
default: install
.PHONY: default help install uninstall status distrotest
# +++++ Distro test +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
DISTRO_DEFAULT  :=debian
DISTRO  ?=$(DISTRO_DEFAULT)
DISTROTEST_DEBIAN := $(shell lsb_release -is)
MDIN=$(shell $*)
MKAUTOEXT:=0
# --- Check Commandline
ifeq ($(DISTRO),arch)
	MKEXT :=arch
else ifeq ($(DISTRO),debian)
	MKEXT :=debian
else
# --- Auto detect
ifeq ($(DISTROTEST_DEBIAN),Debian)
	MKAUTOEXT :=1
	MKEXT :=debian
else
	MKEXT :=none
endif
endif
# --- Abort if invalid
distrotest:
ifeq ($(MKEXT),none)
	$(error DISTRO not found and auto detection failed!)
else ifeq ($(MKAUTOEXT),1)
	@echo "Given DISTRO found by auto detection"
	@echo "Detected '$(MKEXT)' instead of '$(DISTRO)'"
endif
# +++++ Help ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
help:
	@echo ""
	@echo "Usage: "
	@echo ""
	@echo "  make [DISTRO=DISTRO] TARGET"
	@echo "      DISTRO:"
	@echo "         arch      : Arch Linux"
	@echo "         debian    : Debian Linux"
	@echo ""
	@echo "      TARGETS:"
	@echo "         help      : Help menu"
	@echo "         install   : Install components"
	@echo "         uninstall : Uninstall components"
	@echo "         status    : Current status"
	@echo ""
	@echo "  Example: make DISTRO=debian install "
	@echo ""
# # +++++ Targets +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
install: distrotest
	@make --no-print-directory -f Makefile.$(MKEXT) install
uninstall: distrotest
	@make --no-print-directory -f Makefile.$(MKEXT) uninstall
status: distrotest
	@make --no-print-directory -f Makefile.$(MKEXT) status
