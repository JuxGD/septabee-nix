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
, makeBinaryWrapper # thanks Ap6661
, waylandSupport
, offline
}:

let 
  name = "septabee";
  version = "B_T27";
  package =
    if ( offline == true ) then "${version}_offline"
    else version;
  src = fetchurl {
    url = "https://downloads.septabee.com/SEPTABEE_DOWNLOADS/septabee_linux_${package}.7z";
    hash =
      if ( offline == true ) then "sha256-j+VLy+gmt4P7JHXCtdT4pEdrkIPkukVyMVcVrrcd0YM="
      else "sha256-KwqUx170b4LhkS1hDbwwqt/oeveDxFZDqJ1M04oCu84=";
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

  dontStrip = true; # thanks Ap6661

  runtimeDependencies = [
    jack2 # this one i added myself. septabee version B_T9 added support for this. https://septabee.miraheze.org/wiki/Changelog#Version_B_T9_[3]
    pipewire
    vulkan-loader
  ] ++ (lib.optionals waylandSupport [
    wayland
    libxkbcommon
  ]);

  nativeBuildInputs = [
    p7zip
    autoPatchelfHook
    makeBinaryWrapper
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
    runHook postInstall
  '';

  # thanks Ap6661
  postFixup = ''
    wrapProgram "$out/bin/septabee" \
      --set SEPTABEE_LINK_THINGY \
        "$(cat "$NIX_CC/nix-support/dynamic-linker")" \
      --set SEPTABEE_LIBRARBY \
        "${lib.makeLibraryPath ([ 
          stdenv.cc.cc.lib
          libx11
          pipewire
          vulkan-loader
        ] ++ (lib.optionals waylandSupport [
          wayland
          libxkbcommon
        ]))}"
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
