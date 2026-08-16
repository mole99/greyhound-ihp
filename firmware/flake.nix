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
            sdkArch = "rv32imac_zicntr_zicsr_zifencei_zihpm_zca_zcb_zcmp_zcmt_zba_zbb_zbc_zbs";
            gcc = {
              arch = "rv32imac_zicntr_zicsr_zifencei_zihpm_zca_zcb_zcmp_zcmt_zba_zbb_zbc_zbs";
              abi = "ilp32";
            };
          };
        };
      in
      {
        devShells.default = pkgsCross.mkShell {
          nativeBuildInputs = [
            pkgsCross.buildPackages.stdenv.cc
            pkgsCross.buildPackages.binutils
          ];
        };
      }
    );
}
