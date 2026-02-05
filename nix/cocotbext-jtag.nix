{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  python,
  cocotb,
  cocotb-bus,
  stdenv,
}:

buildPythonPackage rec {
  pname = "cocotbext-jtag";
  version = "0.3.2";
  format = "pyproject";

  # pypi source doesn't include tests
  src = fetchFromGitHub {
    owner = "daxzio";
    repo = "cocotbext-jtag";
    #tag = "v${version}";
    rev = "87a2d51c409bdbd799c4a692bd41e95c71ba7c7d";
    hash = "sha256-OG8b1eT4t46juPcn16ap4Jzq7t7Cb+PRJyIiw0kzHow=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ cocotb cocotb-bus ];

  postPatch = ''
  '';

  disabledTests = [
  ];

  nativeCheckInputs = [
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  #pythonImportsCheck = [ "cocotbext.jtag" ];

  meta = {
    description = "JTAG simulation models for cocotb";
    homepage = "https://github.com/daxzio/cocotbext-jtag";
    license = lib.licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [
    ];
  };
}
