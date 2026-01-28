{
  nixConfig = {
    extra-substituters = [
      "https://nix-cache.fossi-foundation.org"
    ];
    extra-trusted-public-keys = [
      "nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs="
    ];
  };

  inputs = {
    librelane.url = github:librelane/librelane/dev;
  };

  outputs = {
    self,
    librelane,
    ...
  }: let
    nix-eda = librelane.inputs.nix-eda;
    devshell = librelane.inputs.devshell;
    nixpkgs = nix-eda.inputs.nixpkgs;
    lib = nixpkgs.lib;
  in {
    # Outputs
    legacyPackages = nix-eda.forAllSystems (
      system:
        import nixpkgs {
          inherit system;
          overlays = [
            nix-eda.overlays.default
            devshell.overlays.default
            librelane.overlays.default
            (nix-eda.composePythonOverlay (
            pkgs': pkgs: pypkgs': pypkgs:
            let
              callPythonPackage = lib.callPackageWith (pkgs' // pypkgs');
            in
            {
              cocotbext-spi = callPythonPackage ./nix/cocotbext-spi.nix { };
            }
          ))
          ];
        }
    );
    
    packages = nix-eda.forAllSystems (system: {
      inherit (self.legacyPackages.${system}.python3.pkgs);
    });
    
    devShells = nix-eda.forAllSystems (system: let
      pkgs = (self.legacyPackages.${system});
      callPackage = lib.callPackageWith pkgs;
    in {
      default = callPackage (pkgs.createLibreLaneShell {
        extra-packages = with pkgs; [
          # Simulation
          iverilog
          verilator
          
          # Waveform viewing
          gtkwave
          
          # FPGA
          nextpnr
          
          # Debug
          openocd
          gdb
          
          # Image scaling
          imagemagick
        ];
        
        extra-python-packages = with pkgs.python3.pkgs; [
          # Verification
          cocotb
          cocotbext-spi
        ];
      }) {};
    });
  };
}
