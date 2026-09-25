{
  pkgs
, waylandSupport ? true
}:

pkgs.stdenv.mkDerivation rec {
  name = "septabee";
  version = "B_T15";
  src = pkgs.fetchurl {
    url = "https://septabee.nekoweb.org/important_stuff/SEPTABEE_DOWNLOADS/version_B/septabee_linux_${version}.7z";
    hash = "sha256-+LE0Ukl2Mz2KIbe/ykM8GXTSlDFpyrB35hN3lIKcbnM=";
  };

  # from here on out. thanks Ap6661/septabee-flake contributors

  icon = pkgs.fetchurl {
    url = "https://septabee.nekoweb.org/important_stuff/icon.png";
    sha256 = "sha256-snq/nOYU2gPzC4VR558VjeQ8oXmQE82IolNDDixvtTU=";
  };
  runtimeDependencies = with pkgs; [
    jack2 # this one i added myself. septabee version B_T9 added support for this. https://septabee.miraheze.org/wiki/Changelog#Version_B_T9_[3]
    pipewire
    vulkan-loader
  ]
  ++ (lib.optionals waylandSupport [
    wayland
    libxkbcommon
  ]);

  nativeBuildInputs = with pkgs; [
    p7zip
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
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
    (pkgs.makeDesktopItem {
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
    license = pkgs.lib.licenses.unfree;
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
    sourceProvenance = [ pkgs.lib.sourceTypes.binaryBytecode ];
  };
}