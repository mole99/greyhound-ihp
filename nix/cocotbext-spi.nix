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
  pname = "cocotbext-spi";
  version = "2.0.0";
  format = "pyproject";

  # pypi source doesn't include tests
  src = fetchFromGitHub {
    owner = "schang412";
    repo = "cocotbext-spi";
    #tag = "v${version}";
    rev = "be5761be54796a64607c4b115e2e7cfe8ac6bc83";
    hash = "sha256-IOmeta+Gc4t+KV237xlTEV+f0z364mq8k3Z3ViiLeJM=";
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

  pythonImportsCheck = [ "cocotbext.spi" ];

  meta = {
    description = "SPI Interface for Cocotb";
    homepage = "https://github.com/schang412/cocotbext-spi";
    license = lib.licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [
    ];
  };
}
