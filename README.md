# Wayland Client Hacking

This is for messing around with building simple wayland clients. There's not
much documentation out there for how to actually use wayland as a client, so
I'm messing around with it and trying to understand it.

## Registry

The goal of the registry program is to understand how to interact with
`wl_registry` which is a global store of interfaces associated with a
`wl_display`.


* Get a display (default with `NULL` id)
* Get the registry for the display (simple function)
* Create a listener and attach it
* Start listening with `wl_dispatch_display`

If you want to grab interfaces like `wl_compositor` or `xdg_wm_base` you need
to do so in the listener.
