/**
 * registry.c
 *
 * Simple program for exploring the wayland registry.
 * I have not been able to find documentation on what interfaces will
 * consistently be in the registry, and if they have consistent names (ids).
 *
 * Copyright 2019 by Joshua Gutow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#include <stddef.h>
#include <stdio.h>
#include <wayland-client-core.h>
#include <wayland-client-protocol.h>

static void registry_handle_global(void *data, struct wl_registry *registry,
                                   uint32_t name, const char *interface,
                                   uint32_t version)
{
	if(data != NULL)
		puts("DATA IS NOT NULL");
	printf("interface: %s\nname: %d\nversion: %d\n\n",
               interface, name, version);
}

static void registry_handle_global_remove(void *data,
                                          struct wl_registry *registry,
                                          uint32_t name)
{
	if(data != NULL)
		puts("DATA IS NOT NULL");
	printf("%d has been removed\n", name);
}

/**
 * Wrapper around registry add and remove function pointers.
 */
static const struct wl_registry_listener registry_listener = {
	.global = &registry_handle_global,
	.global_remove = &registry_handle_global_remove,
};

int main()
{
	// Grab the default display
	struct wl_display *display = wl_display_connect(NULL);
	// Get the global registry for that display
	struct wl_registry *registry = wl_display_get_registry(display);
	// Add our listeners
	wl_registry_add_listener(registry, &registry_listener, NULL);
	// Starts processing incoming events on the listeners
	wl_display_dispatch(display);
	// Disconnect and clean up
	wl_display_disconnect(display);
	return 0;
}
