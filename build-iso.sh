#!/usr/bin/env sh

nix build .#nixosConfigurations.iso.config.system.build.isoImage
