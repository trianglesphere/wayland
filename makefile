# Copyright 2019 Joshua Gutow
# 
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
CC  = gcc

NOERR  = 
NERRS  = $(addprefix -Wno-error=, $(NOERR))
FAST   = -Ofast -march=native -funroll-loops -D NDEBUG
DEBUG  = -Og

WARNS  = -Wall -Wextra #-Werror $(NERRS)
FLAGS  = -ggdb  $(WARNS)
CFLAGS = $(FLAGS) $(DEBUG)

TARGETS = registry
MAIN    = registry
SRCS    = 
OBJS    = $(SRCS:.c=.o)
LDLIBS  = -l wayland-client

all : $(TARGETS)

$(TARGETS) : $(OBJS)

run: $(MAIN)
	./$(MAIN)
val: $(MAIN)
	valgrind ./$(MAIN)

TAGS_HEADERS = /usr/include/wayland-client-core.h /usr/include/wayland-client-protocol.h xdg-shell-client-protocol.h
tags:
	ctags --c++-kinds=+p main.c $(SRCS) $(TAGS_HEADERS)
clean :
	rm -rf $(OBJS) $(LIB) $(TARGETS)

# Build the protocol headers
# Don't seem to need to do for client-core...
# pkg-config isn't working in the makefile...
WAYLAND_PROTOCOLS_DIR = $(shell pkg-config wayland-protocols --variable=pkgdatadir)
WAYLAND_SCANNER       = $(shell pkg-config wayland-scanner   --variable=wayland-scanner)
# Manually run pkg-config and clean up. These are consistent for me.
WAYLAND_PROTOCOLS_DIR = /usr/share/wayland-protocols
WAYLAND_SCANNER       = /usr/bin/wayland-scanner
XDG_SHELL_PROTOCOL    = $(WAYLAND_PROTOCOLS_DIR)/stable/xdg-shell/xdg-shell.xml
xdg-shell-client-protocol.h:
	$(WAYLAND_SCANNER) client-header $(XDG_SHELL_PROTOCOL) $@

.PHONY: clean all tags run val
