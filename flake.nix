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
    #librelane.url = "github:librelane/librelane/dev";
    librelane_plugin_fabulous = {
      url = "github:mole99/librelane_plugin_fabulous/1.14.1";
      #inputs.librelane.follows = "librelane";
    };
  };

  outputs =
    {
      self,
      librelane_plugin_fabulous,
      ...
    }:
    let
      librelane = librelane_plugin_fabulous.inputs.librelane;
      nix-eda = librelane.inputs.nix-eda;
      devshell = librelane.inputs.devshell;
      nixpkgs = nix-eda.inputs.nixpkgs;
      lib = nixpkgs.lib;
    in
    {
      # Outputs
      legacyPackages = nix-eda.forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            nix-eda.overlays.default
            devshell.overlays.default
            librelane.overlays.default
            librelane_plugin_fabulous.overlays.default
            (nix-eda.composePythonOverlay (
            pkgs': pkgs: pypkgs': pypkgs:
            let
              callPythonPackage = lib.callPackageWith (pkgs' // pypkgs');
            in
            {
              cocotbext-spi = callPythonPackage ./nix/cocotbext-spi.nix { };
              librelane-plugin-greyhound = callPythonPackage ./default.nix { };
            }
          ))
          ];
        }
      );

      packages = nix-eda.forAllSystems (system: {
        inherit (self.legacyPackages.${system}.python3.pkgs) ;
      });

      devShells = nix-eda.forAllSystems (
        system:
        let
          pkgs = (self.legacyPackages.${system});
          callPackage = lib.callPackageWith pkgs;
        in
        {
          default = pkgs.librelane-shell.override ({
            librelane-plugins = ps: with ps; [
              librelane-plugin-fabulous
              librelane-plugin-greyhound
            ];
            extra-packages = with pkgs; [
              # Utilities
              gnumake
              gnugrep
              gawk

              # Simulation
              iverilog
              verilator

              # Waveform viewing
              gtkwave
              surfer
              
              # Debug
              openocd
              gdb
              
              # Image scaling
              imagemagick
            ];
            extra-python-packages = ps: with ps; [
              # Verification
              cocotb
              cocotbext-spi
              pytest
              
              # For logo generation
              pillow
            ];
          });
        }
      );
    };
}
