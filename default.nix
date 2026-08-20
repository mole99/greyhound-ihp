{
  buildPythonPackage,
  librelane,
  nix-gitignore,
  poetry-core,
  setuptools,
}:
let
  self = buildPythonPackage {
    name = "librelane_plugin_greyhound";

    version = (builtins.fromTOML (builtins.readFile ./pyproject.toml)).tool.poetry.version;

    src = nix-gitignore.gitignoreSourcePure ./.gitignore ./.;

    doCheck = false;

    format = "pyproject";

    nativeBuildInputs = [
      poetry-core
      setuptools
    ];

    includedTools = [
    ];

    propagatedBuildInputs = self.includedTools ++ [
      librelane
    ];
  };
in
self
