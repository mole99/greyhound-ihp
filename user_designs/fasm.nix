{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  textx,
  version ? "v0.0.2",
  rev ? null,
  sha256 ? "sha256-AMG4+qMk2+40GllhE8UShagN/jxSVN+RNtJCW3vFLBU=",
}:
let

  self = buildPythonPackage {
    pname = "fasm";
    format = "pyproject";
    inherit version;

    src = fetchFromGitHub {
      owner = "chipsalliance";
      repo = "fasm";
      rev = if rev == null then version else rev;
      inherit sha256;
    };

    build-system = [
      setuptools
    ];

    dependencies = [
      textx
    ];

  };
in
self
