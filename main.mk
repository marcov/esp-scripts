ifeq (,$(ENV))
  $(error ENV needs to be defined)
endif

ifeq (,$(TOPLEVEL_SOURCE_DIRS))
  $(error TOPLEVEL_SOURCE_DIRS needs to be defined)
endif

OTA_CMD   := ./esp-scripts/sh/otaupdate.sh
FIRMWARE  := .pio/build/$(ENV)/firmware.bin
PIO_OPTS :=
VERBOSE :=
SERIAL_PORT :=

ifneq (,$(SERIAL_PORT))

    UPLOAD_OPTS := \
      --upload-port $(SERIAL_PORT) \

endif

ifneq (,$(VERBOSE))

  PIO_OPTS += \
    -v \

endif

C_CXX_SOURCES_EXT := \
  c \
  cc \
  cpp  \
  h  \
  hpp

VPATH := $(shell find $(TOPLEVEL_SOURCE_DIRS) -type d)
#$(info $(VPATH))

C_CXX_SRCS   := $(foreach dir,$(VPATH),$(foreach ext,$(C_CXX_SOURCES_EXT),$(wildcard $(dir)/*.$(ext))))
#$(info $(C_CXX_SRCS))

################################################################################

.PHONY: all
all: $(FIRMWARE)

$(FIRMWARE): $(C_CXX_SRCS)
	pio run $(PIO_OPTS) -e $(ENV)

.PHONY: flash-esptool
flash-esptool: $(FIRMWARE)
	esptool.py --baud 230400 write_flash 0x0 $(FIRMWARE)

.PHONY: flash-pio
flash-pio: $(FIRMWARE)
	pio run $(PIO_OPTS) --target upload --environment $(ENV) $(UPLOAD_OPTS)

.PHONY: clean
clean:
	pio run $(PIO_OPTS) --target clean --environment $(ENV)

.PHONY: logs
logs: # Print serial logs
	pio device monitor --environment $(ENV) --port $(SERIAL_PORT)

.PHONY: ota
ota: $(FIRMWARE)
	$(OTA_CMD) $(OTA_HOSTNAME) $<
