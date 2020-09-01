I have been eyeing operating systems with functional package
managers for a while now, aka, NixOS or Guix. Reproducible
builds, declarative and rollback-able system configuration,
system consistency, all sound pretty cool. I have been using
NixOS for about a month now.

### Installation

I went with their minimal installation ISO. The installation
was pretty smooth from start to end, no hitches there. The
entire [manual](https://nixos.org/manual/nixos/stable/) is
available offline, and is accessible during the
installation. Very handy.

### Setup

The entire system is configured via
`/etc/nixos/configuration.nix`. Wifi, `libinput` gestures,
audio, locale settings, there are options for literally
everything.  You can declaratively write down the packages
you want installed too. With fresh installs of most distros,
I usually fumble with getting things like screen backlight
and media keys to work. If I do manage to fix it, I can't
carry it forward to future installations trivially. Getting
all my hardware to work on NixOS is as easy as:

```
{
    server.xserver.libinput.enable = true;  # touchpad
    programs.light.enable = true;           # backlight
    hardware.pulseaudio.enable = true;      # audio
    networking.wireless.enable = true;      # wifi
}
```

### Developing with Nix

Nix makes it easy to enter environments that aren't affected
by your system configuration using `nix-shell`.

Builds may be generated by specifying a `default.nix` file,
and running `nix-build`. Conventional package managers
require you to specify a dependency list, but there is no
guarantee that this list is complete. The package will build
on your machine even if you forget a dependency. However,
with Nix, packages are installed to `/nix/store`, and not
global paths such as `/usr/bin/...`, if your project builds,
it means you have included every last one.

Issues on most my projects have been "unable to build
because `libxcb` is missing", or "this version of `openssl`
is too old". Tools like `cargo` and `pip` are poor package
managers. While they *can* guarantee that Rust or Python
dependencies are met, they make assumptions about the
target system.

For example, [this
website](https://github.com/nerdypepper/site) is now built
using Nix, anyone using Nix may simply, clone the repository
and run `./generate.sh`, and it would *just work*, while
keeping your global namespace clean™:

```bash
#! /usr/bin/env nix-shell
#! nix-shell -i bash -p eva pandoc esh

# some bash magic ;)
```

Dependencies are included with the `-p` flag, the shell
script is executed with an interpreter, specified with the
`-i` flag.

### Impressions

NixOS is by no means, simple. As a newcomer, using Nix was
not easy, heck, I had to learn a purely functional, lazy
language to just build programs. There is a lot to be
desired on the tooling front as well. A well fleshed out LSP
plugin would be nice ([rnix-lsp looks
promising](https://github.com/nix-community/rnix-lsp)).

Being able to rollback changes at a system level is cool.
Package broke something? Just `nixos-rebuild switch
--rollback`!  Deleted `nix` by mistake? Find the binary in
`/nix/store` and rollback! You aren't punished for not
thinking twice.

I don't see myself switching to anything else in the near
future, NixOS does a lot of things right. If I ever need to
reinstall NixOS, I can generate an [image of my current
system](https://github.com/nix-community/nixos-generators).

[![](https://u.peppe.rs/6m.png)](https://u.peppe.rs/6m.png)