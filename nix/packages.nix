{
  pkgs,
  pano-scrobbler,
  openrevolution,
  ...
}:

{
  environment = {
    systemPackages =
      with pkgs;
      with kdePackages;
      [
        # gui/desktop
        libreoffice
        strawberry
        pano-scrobbler.packages.${pkgs.stdenv.hostPlatform.system}.default
        openrevolution.packages.${pkgs.stdenv.hostPlatform.system}.default
        alacritty
        gimp
        pinta
        nicotine-plus
        easytag
        thunderbird-latest
        mpv
        obs-studio
        prismlauncher
        filezilla
        losslesscut
        stremio-service
        upscayl

        #kde packages
        oxygen
        oxygen-icons
        oxygen-sounds
        ark
        okular
        ffmpegthumbs
        partitionmanager
        kalk
        kamoso
        kdenlive

        # formatters
        stylua
        nixfmt
        shfmt
        prettierd
        clang-tools

        # lsp's
        clang-tools
        bash-language-server
        vscode-langservers-extracted
        nil
        lua-language-server

        # cli/utils
        ponysay
        fastfetch
        gcc
        htop
        wl-color-picker
        cmatrix
        jq
        stow
        bat
        tree
        ttyper
        sshfs
        tmux
        wget
        neovim
        git
        gh
        ffmpeg
        zip
        unzip
        keyd
        yt-dlp
        deno
        rar
        unrar
        pipewire
        wireplumber
        pulseaudio
        power-profiles-daemon
        posy-cursors
        materia-kde-theme
        wayland-utils
        lswt
        exfatprogs
        ntfsprogs
        gptfdisk
        smartmontools
        libmtp
        playerctl
        wine
        winetricks
        (pkgs.python3.withPackages (ps: [
          ps.pyside6
        ]))
      ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      kontact
      akonadi
      elisa
      khelpcenter
      kinfocenter
      kmail
      konsole
      ktnef
      kwallet
      merkuro
    ];
  };
}
