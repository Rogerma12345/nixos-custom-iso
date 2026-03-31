set dotenv-load

# list targets
help:
  @just --list

flake-show:
    nix flake show

flake-check:
    nix flake check --show-trace --all-systems

build-installer-iso:
    nix build -L .#installer-iso
