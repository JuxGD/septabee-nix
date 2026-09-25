{
  lib
, stdenv
, fetchurl
, jack2
, pipewire
, vulkan-loader
, wayland
, libxkbcommon
, p7zip
, autoPatchelfHook
, libpng
, freetype
, libx11
, lilv
, zstd
, ncurses
, makeDesktopItem
, waylandSupport ? true
, offline ? true
}:

let 
  name = "septabee";
  version = "B_T15";
  package =
    if ( offline == true ) then "${version}_offline"
    else version;
  src = fetchurl {
    url = "https://septabee.nekoweb.org/important_stuff/SEPTABEE_DOWNLOADS/version_B/septabee_linux_${package}.7z";
    hash =
      if ( offline == true ) then "sha256-A+/zGQutL22Ed+GIaDkCsyJ3M1028/Azk7U/VRWhtOQ="
      else "sha256-+LE0Ukl2Mz2KIbe/ykM8GXTSlDFpyrB35hN3lIKcbnM=";
  };
in

if (offline && !lib.versionAtLeast version "B_T5")
then throw "Septabee ${version} does not offer offline builds. Please use version B_T5 or greater or disable offline mode."
else

stdenv.mkDerivation rec {
  inherit name;
  inherit version;
  inherit src;

  # from here on out. thanks Ap6661/septabee-flake contributors

  icon = fetchurl {
    url = "https://septabee.nekoweb.org/important_stuff/icon.png";
    sha256 = "sha256-snq/nOYU2gPzC4VR558VjeQ8oXmQE82IolNDDixvtTU=";
  };
  runtimeDependencies = [
    jack2 # this one i added myself. septabee version B_T9 added support for this. https://septabee.miraheze.org/wiki/Changelog#Version_B_T9_[3]
    pipewire
    vulkan-loader
  ]
  ++ (lib.optionals waylandSupport [
    wayland
    libxkbcommon
  ]);

  nativeBuildInputs = [
    p7zip
    autoPatchelfHook
  ];

  buildInputs = [
    libpng
    vulkan-loader
    freetype
    pipewire
    libx11
    stdenv.cc.cc.lib
    lilv
    zstd
    ncurses
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Septabee";
      exec = "septabee";
      icon = icon;
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
        "Midi"
      ];
      desktopName = "S e p t a b e e";
      genericName = "Septabee Digital Audio Workstation";
    })
  ];

  unpackPhase = ''
    7z x "$src"
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp -r ./linux/* "$out/bin"
    cp -r "$desktopItems/share" "$out"
  '';

  meta = {
    changelog = "https://septabee.miraheze.org/wiki/Changelog";
    description = "Septabee, a revolutionary free DAW";
    downloadPage = "https://septabee.nekoweb.org";
    homepage = "https://septabee.nekoweb.org";
    license = lib.licenses.unfree;
    mainProgram = "septabee";
    maintainers = [
      {
        name = "JuxGD";
        email = "jak@e.email";
        github = "JuxGD";
        githubId = 117054307;
      }
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}