{
  description = "RISC-V cross-compiler for Greyhound";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      flake-compat,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgsCross = import nixpkgs {
          localSystem = system;
          crossSystem = {
            config = "riscv32-none-elf";
            arch = "rv32imac_zicntr_zicsr_zifencei_zihpm_zca_zcb_zcmp_zcmt_zba_zbb_zbc_zbs";
            libc = "newlib";
            gcc = {
              arch = "rv32imac_zicntr_zicsr_zifencei_zihpm_zca_zcb_zcmp_zcmt_zba_zbb_zbc_zbs";
              abi = "ilp32";
            };
          };
          crossOverlays = [
            (final: prev: {
              newlib = prev.newlib.overrideAttrs {
                # Disable all hardening
                hardeningDisable = [ "all" ];

                # We don't need frame pointers (no hardware support for debugging)
                NIX_CFLAGS_COMPILE = (prev.newlib.NIX_CFLAGS_COMPILE or "") 
                  + "-fomit-frame-pointer -momit-leaf-frame-pointer";
              };
            })
          ];
        };
      in
      {
        devShells.default = pkgsCross.mkShell {
          nativeBuildInputs = with pkgsCross; [
            buildPackages.binutils
          ];

          # Disable all hardening
          hardeningDisable = [ "all" ];

          # We don't need frame pointers (no hardware support for debugging)
          NIX_CFLAGS_COMPILE = "-fomit-frame-pointer -momit-leaf-frame-pointer";
        };
        
        packages.newlib = pkgsCross.newlib;
      }
    );
}
