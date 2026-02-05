{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  python,
  cocotb,
  stdenv,
}:

buildPythonPackage rec {
  pname = "cocotbext-uart";
  version = "0.1.4";
  format = "pyproject";

  # pypi source doesn't include tests
  src = fetchFromGitHub {
    owner = "alexforencich";
    repo = "cocotbext-uart";
    #tag = "v${version}";
    rev = "ec49c1b74cfa0955df155c28c9d36fd20b9ff004";
    hash = "sha256-mrFqvczUWCjueIs8wXmyMFf2oeW3+oKQOjtG0Jii2R0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ cocotb ];

  postPatch = ''
  '';

  disabledTests = [
  ];

  nativeCheckInputs = [
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "cocotbext.uart" ];

  meta = {
    description = "UART simulation models for cocotb";
    homepage = "https://github.com/alexforencich/cocotbext-uart";
    license = lib.licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [
    ];
  };
}
