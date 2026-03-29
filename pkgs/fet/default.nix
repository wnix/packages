{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fet";
  version = "7.8.3";

  src = fetchurl {
    url = "https://lalescu.ro/liviu/fet/download/fet-${finalAttrs.version}.tar.xz";
    hash = "sha256-iOQEbPtA5JJT9eprDIpoPRenhmym+5t/6y+15CAotP8=";
  };

  sourceRoot = "fet-${finalAttrs.version}";

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  # Remove the Qt deploy-script install step: Nix uses wrapQtAppsHook
  # instead of bundling Qt libs alongside the binary.
  postPatch = ''
    substituteInPlace src/interface/CMakeLists.txt \
      --replace-fail 'install(SCRIPT ''${deploy_script})' ""
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = {
    description = "Automatically schedule school, high-school or university timetables using a fast timetabling algorithm";
    homepage = "https://lalescu.ro/liviu/fet/";
    license = lib.licenses.agpl3Only;
    mainProgram = "fet";
    platforms = lib.platforms.linux;
  };
})
