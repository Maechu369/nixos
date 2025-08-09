#!/usr/bin/env sh

nix build .#nixosConfigurations.exampleIso.config.system.build.isoImage
