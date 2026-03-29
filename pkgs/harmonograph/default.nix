{
  lib,
  fetchurl,
  perlPackages,
}:

let
  # nixpkgs ships 1.71; need >= 1.9 but < 2.0 (2.0 removed rgb_hash and other methods)
  graphicsToolkitColor = perlPackages.buildPerlPackage {
    pname = "Graphics-Toolkit-Color";
    version = "1.972";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LI/LICHTKIND/Graphics-Toolkit-Color-1.972.tar.gz";
      hash = "sha256-MqUAEelVrG87eeDOU1bk3Z0EMKsV5WMMc2xv5Y7+JwM=";
    };
    meta = with lib; {
      description = "Calculate color sets, IO in many spaces and formats";
      license = licenses.artistic1;
    };
  };

  harmonograph = perlPackages.buildPerlPackage {
    pname = "App-GUI-Harmonograph";
    version = "1.1";
    src = fetchurl {
      url = "mirror://cpan/authors/id/L/LI/LICHTKIND/App-GUI-Harmonograph-1.1.tar.gz";
      hash = "sha256-4FR8aeesrTXVN8+YMlhAwQiGeZ/UKvdEkgGYeaASDiI=";
    };
    propagatedBuildInputs = with perlPackages; [
      Wx
      graphicsToolkitColor
      FileHomeDir
    ];
    # Tests require a live X11 display (GUI application)
    doCheck = false;
    meta = with lib; {
      description = "Drawing with 4 lateral and 2 rotary pendula";
      license = licenses.gpl3Only;
      mainProgram = "harmonograph";
    };
  };
in
harmonograph
