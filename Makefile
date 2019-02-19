# Makefile for Arnold

CC = gcc
BIND = $(CC)
#   CFLAGS    flags for C compile
#   LFLAGS1   flags after output file spec, before obj file list
#   LFLAGS2   flags after obj file list (libraries, etc)

# Comment to following two lines to disable SDL
SDLINC = -D_REENTRANT
SDLLIB = -L/usr/lib -lSDL -lpthread

# Comment to following two lines to disable ALSA
ALSAINC = 
ALSALIB =  -lasound -lm -ldl -lpthread

#-Wall for max warnings!
CFLAGS_NEEDED =  $(SDLINC) $(ALSAINC) -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_SDL=1 -DHAVE_LIBASOUND=1 -DHAVE_ALSA=1 -DHAVE_SYS_SOUNDCARD_H=1 -I. -DUNIX -DCPC_LSB_FIRST
CFLAGS_WARNING = -Wall -Wno-unused
CFLAGS_OPT = -Ofast -s
CFLAGS = $(CFLAGS_NEEDED) $(CFLAGS_WARNING) $(CFLAGS_OPT)
LFLAGS1 = 
LFLAGS2 = -lasound -lm -ldl -lpthread $(SDLLIB) $(ALSALIB)

CPC_O=	cpc/arnold.o cpc/asic.o cpc/audioevent.o cpc/bmp.o cpc/cpc.o \
	cpc/crtc.o cpc/dumpym.o cpc/fdc.o cpc/fdd.o cpc/fdi.o \
	cpc/garray.o cpc/multface.o cpc/printer.o cpc/psgplay.o \
	cpc/psg.o cpc/render.o cpc/render5.o \
	cpc/snapshot.o cpc/sampload.o cpc/spo256.o cpc/pal.o \
	cpc/voc.o cpc/tzxold.o cpc/wav.o cpc/westpha.o cpc/yiq.o \
	cpc/z8536.o cpc/csw.o cpc/cassette.o cpc/amsdos.o \
	cpc/diskimage/diskimg.o cpc/ramrom.o \
	cpc/diskimage/dsk.o cpc/diskimage/extdsk.o \
	cpc/diskimage/iextdsk.o \
	cpc/z80/z80.o \
	cpc/riff.o cpc/snapv3.o \
	cpc/messages.o

UNIX_O= unix/main.o unix/host.o unix/global.o unix/display.o \
	unix/display_sdl.o unix/sdlsound.o unix/configfile.o \
	unix/roms.o unix/ifacegen.o unix/alsasound.o unix/alsasound-mmap.o \
	unix/alsasound-common.o unix/osssound.o unix/sound.o \
	unix/pulseaudiosound.o

ROMS_BIN=	roms/amsdose/amsdos.rom,roms/cpc464e/os.rom,roms/cpc464e/basic.rom,roms/cpc664e/os.rom,roms/cpc664e/basic.rom,roms/cpc6128e/os.rom,roms/cpc6128e/basic.rom,roms/cpc6128s/os.rom,roms/cpc6128s/basic.rom,roms/cpcplus/system.cpr,roms/kcc/kccos.rom,roms/kcc/kccbas.rom

ELF_FMT := $(shell $(CC) -Wl,--print-output-format 2>/dev/null || true | head -n 1)

arnold:  conditionals roms $(CPC_O) $(UNIX_O)
	$(BIND) -Wl,-b,binary,$(ROMS_BIN),-b,$(ELF_FMT) -o arnold $(LFLAGS1) $(CPC_O) \
	$(UNIX_O) $(LFLAGS2)

conditionals:
roms:
	ln -s ../roms .

ctags:
	ctags -R
clean:
	rm -rf cpc/*.o
	rm -rf ifacegen/*.o
	rm -rf unix/*.o
	rm -rf cpc/debugger/*.o
	rm -rf cpc/diskimage/*.o
	rm -rf cpc/z80/*.o
	rm -rf tags
distclean: clean
	rm -rf *~ */*~
	rm -f Makefile
	rm -f config.cache
	rm -f config.log
	rm -f config.status
realclean: distclean
	rm -f aclocal.m4
	rm -f configure
archive:
	$(clean)
	cp makefile unix/makefile.unx
	zip -r cpccore.zip cpc
	zip -r ifacegen.zip ifacegen
	zip -r unix.zip unix
	zip -r roms.zip roms

