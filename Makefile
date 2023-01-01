# +++++ Configuration +++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
# --- Makefile Setup ---#
default: install
.PHONY: default help install uninstall status usertest distrotest \
		docker-clean docker-build docker-create docker-stop docker-start \
		docker-commit docker-tag docker-push
# +++++ Environment checks ++++++++++++++++++++++++++++++++++++++++++++++++++++ 
# --- Early Shells 
DISTROTEST_DEBIAN := $(shell lsb_release -is)
DISTROTEST_ARCH := $(shell lsb_release -is)
DISTRO 		  	?=none
# --- Check Distro (Auto)
ifeq ($(DISTRO),Arch)
	MKEXT :=arch
else ifeq ($(DISTRO),Debian)
	MKEXT :=debian
else
	ifeq ($(DISTROTEST_ARCH),Arch)
		MKEXT :=arch
	else ifeq ($(DISTROTEST_DEBIAN),Debian)
		MKEXT :=debian
	else
		MKEXT :=none
	endif
endif
# --- Test distro
distrotest:
	@echo "MKEXT: $(MKEXT)"
ifeq ($(MKEXT),none)
	$(error DISTRO not found and auto detection failed!)
endif
# +++++ Help ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
help:
	@echo ""
	@echo "Usage (As root): "
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
install: usertest distrotest
	@make --no-print-directory -f Makefile.$(MKEXT) install
uninstall: usertest distrotest
	@make --no-print-directory -f Makefile.$(MKEXT) uninstall
status: usertest distrotest
	@make --no-print-directory -f Makefile.$(MKEXT) status
# +++++ Docker targets +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
docker-clean: distrotest
	-docker rmi mps-min-$(MKEXT)
	-docker container rm mps-min-$(MKEXT)
docker-build: distrotest docker-clean
	docker build -t mps-min-$(MKEXT) . -f Dockerfile.$(MKEXT)
	docker create --name mps-min-$(MKEXT) mps-min-$(MKEXT)
docker-stop: distrotest
	-docker container stop mps-min-$(MKEXT)
docker-start: distrotest docker-stop docker-build
	-docker container rm mps-min-$(MKEXT)
	docker run -it --name mps-min-$(MKEXT) mps-min-$(MKEXT)	
docker-commit: distrotest
	docker commit mps-min-$(MKEXT) livemps/mps-min-$(MKEXT):latest
docker-tag: distrotest
	docker tag mps-min-$(MKEXT) livemps/mps-min-$(MKEXT):latest
docker-push: distrotest
	docker push livemps/mps-min-$(MKEXT):latest
docker-persist: distrotest docker-build docker-commit docker-tag docker-push
