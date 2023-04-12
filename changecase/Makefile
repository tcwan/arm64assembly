# Makefile for cross assembling ARM Assembly programs for RPi
# adapted from other sources by TC Wan <tcwan@usm.my>

# -- Cross tools and flags
XPREFIX=aarch64-linux-gnu-
AS=$(XPREFIX)as
ASFLAGS=-g
LD=$(XPREFIX)ld
LDFLAGS=
CC=$(XPREFIX)gcc
CFLAGS=-g 
# -- Specify additional libraries to link with executable 
LIBS=

# -- Select Linker
# use $(CC) for mixed Assembly and C projects. The entry point must be 'main'
# use $(LD) for pure Assembly projects. The entry point must be '_start'
#
LINKER=$(CC)
#LINKER=$(LD)

# -- source and include directories
DIR_C=.
DIR_ASM=$(DIR_C)
DIR_HDR=$(DIR_C)

# -- source code suffix
EXT_H=.h
EXT_C=.c
EXT_ASM=.S

# ---------------------------------
#   files lists
# ---------------------------------
HEADERS=$(wildcard $(addsuffix /*$(EXT_H), $(DIR_HDR)))
CSOURCE=$(wildcard $(addsuffix /*$(EXT_C), $(DIR_C)))
ASOURCE=$(wildcard $(addsuffix /*$(EXT_ASM), $(DIR_ASM)))


# ---------------------------------
#   object and output lists
# ---------------------------------
AOBJS=$(ASOURCE:%.S=%.o)
ALSTS=$(ASOURCE:%.S=%.lst)
COBJS=$(CSOURCE:%.c=%.o)
CLSTS=$(CSOURCE:%.c=%.lst)
TARGET=$(notdir $(shell pwd))
EXEC=$(TARGET).elf

# ---------------------------------
#   Build logic
# ---------------------------------
$(CSOURCE) $(ASOURCE): $(HEADERS)

%.o: %.S
	$(AS) $(ASFLAGS) -a=$(@:%.o=%.lst) -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c $<

$(EXEC): $(AOBJS) $(COBJS)
	$(LINKER) $(LDFLAGS) -o $(EXEC) $(AOBJS) $(COBJS) $(LIBS)

all: $(EXEC)

.PHONY: clean

clean:
	rm -f $(EXEC) $(AOBJS) $(ALSTS) $(COBJS) $(CLSTS)
