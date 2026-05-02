{
  lib,
  python3Packages,
  fetchurl,
  makeWrapper,
}:

let
  inherit (python3Packages)
    buildPythonPackage
    rdflib
    html5lib
    packaging
    prettytable
    ply
    ;

  owlrl = buildPythonPackage rec {
    pname = "owlrl";
    version = "6.0.2";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/9d/56/11fe63c2c317347f69be17e9ece1991e0ec6c2cdb8225c0baa5b96e283ed/owlrl-6.0.2-py3-none-any.whl";
      hash = "sha256-V+ygayIe27xoI3bI1C4t3/yZ9h6CwNoC4mc1WS8Iusw=";
    };
    propagatedBuildInputs = [ rdflib ];
    meta = with lib; {
      description = "OWL2 RL and RDFS inference for RDFLib";
      homepage = "https://github.com/RDFLib/OWL-RL";
      license = licenses.asl20;
    };
  };

  jsonpath-ng-pinned = buildPythonPackage rec {
    pname = "jsonpath-ng";
    version = "1.6.1";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/16/0a/3b1ee3721b4bd684b0e29c724ab82ed3b2c0e42285beb8bf9e18de8c903f/jsonpath_ng-1.6.1-py3-none-any.whl";
      hash = "sha256-jyLNgnPXdy7qmqqE2SLghBqjb9uKLGt/bDeRoWqbwL4=";
    };
    propagatedBuildInputs = [ ply ];
    meta = with lib; {
      description = "JSONPath implementation for Python";
      homepage = "https://github.com/h2non/jsonpath-ng";
      license = licenses.asl20;
    };
  };

  pyshacl = buildPythonPackage rec {
    pname = "pyshacl";
    version = "0.26.0";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/7f/72/c63543a6d4a9c012c9d23dd684db5d30a7aa2ea01ff58e8518169d4f8a13/pyshacl-0.26.0-py3-none-any.whl";
      hash = "sha256-pL70KW1WMFow4Kl1CeVB6+TyzC1dpzU20FQSM+KPLSI=";
    };
    propagatedBuildInputs = [
      rdflib
      owlrl
      html5lib
      packaging
      prettytable
    ];
    meta = with lib; {
      description = "Python SHACL validator";
      homepage = "https://github.com/RDFLib/pySHACL";
      license = licenses.asl20;
    };
  };

  jsonschema-runtime-deps = [
    jsonpath-ng-pinned
    owlrl
    pyshacl
    rdflib
  ];

in
python3Packages.buildPythonApplication rec {
  pname = "jsonschema2shacl";
  version = "0.2";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/37/2b/7603a88dbd3ffefad3a8d9b3fd99aeefc7bee7954820f4bb46751f1034bd/jsonschema2shacl-0.2-py3-none-any.whl";
    hash = "sha256-BA/YcwhLznbtzHoKIke38/Lrp8Bc2Jj+tJtyO8Ncmno=";
  };

  propagatedBuildInputs = jsonschema-runtime-deps;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper ${python3Packages.python}/bin/python3 $out/bin/jsonschema2shacl \
      --prefix PYTHONPATH : "${python3Packages.makePythonPath jsonschema-runtime-deps}:$out/${python3Packages.python.sitePackages}" \
      --add-flags "-m jsonschema2shacl"
  '';

  pythonImportsCheck = [ "jsonschema2shacl" ];

  meta = with lib; {
    description = "Translate JSON Schema into SHACL shapes (RDFlib-based CLI)";
    homepage = "https://github.com/citiususc/jsonschema2shacl";
    license = licenses.asl20;
    mainProgram = "jsonschema2shacl";
    platforms = platforms.linux;
  };
}
