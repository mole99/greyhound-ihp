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
    nix-eda.url = "github:fossi-foundation/nix-eda/6.0.2";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs =
    {
      self,
      nix-eda,
      flake-utils,
      flake-compat,
    }:
    let
      nixpkgs = nix-eda.inputs.nixpkgs;
      lib = nixpkgs.lib;
    in
    {
      # Common
      overlays = {
        default = lib.composeManyExtensions [
          (nix-eda.composePythonOverlay (
            pkgs': pkgs: pypkgs': pypkgs:
            let
              callPythonPackage = lib.callPackageWith (pkgs' // pkgs'.python3.pkgs);
            in
            {
              fasm = callPythonPackage ./fasm.nix { };
            }
          ))
          (final: prev: {
            nextpnr = prev.nextpnr.overrideAttrs {
              version = "ca74f47c";
              src = prev.fetchFromGitHub {
                owner = "YosysHQ";
                repo = "nextpnr";
                rev = "ca74f47c3f0f0d3f22b7a7e9920dafa589cc2f3e";
                hash = "sha256-ybZiFL/c4W6OtXnAQhRbNtOQAHUJ+u3xcZYBmYYeWjA=";
                fetchSubmodules = true;
              };
              cmakeFlags = [
                "-DCURRENT_GIT_VERSION=nextpnr-0e66c0ce"
                "-DARCH=generic"
                "-DBUILD_TESTS=ON"
                "-DUSE_OPENMP=ON"
                # `Compatibility with CMake < 3.5 has been removed from CMake.`
                "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
              ];
            };
          })
          (final: prev: {
            yosys = prev.yosys.overrideAttrs {
              version = "2231c860";
              src = prev.fetchGitHubSnapshot {
                owner = "mole99";
                repo = "yosys";
                rev = "2231c860ec7afd8eef9ba97231c3a10950469e95";
                hash = "sha256-OwLoMsdEmTvlrD7q7yU/rkLzX6h4GGB98OKzfRFFW/0=";
                add-gitcommit = true;
              };
            };
          })
        ];
      };

      # Packages
      legacyPackages = nix-eda.forAllSystems (
        system:
        import nix-eda.inputs.nixpkgs {
          inherit system;
          overlays = [
            nix-eda.overlays.default
            self.overlays.default
          ];
        }
      );

      # Development Shells
      devShells = nix-eda.forAllSystems (
        system:
        let
          pkgs = self.legacyPackages."${system}";
          callPackage = lib.callPackageWith pkgs;
          python-env = (pkgs.python3.withPackages (ps: with ps; [ pkgs.python3.pkgs.fasm ]));
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.nextpnr
              pkgs.yosys
              python-env
            ];
          };
        }
      );
    };
}
