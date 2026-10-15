{
  pkgs,
  cachyos-kernel,
  plasma-manager,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";
    users.z = import ./home.nix;
    extraSpecialArgs = {
      inherit plasma-manager;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    kernelPackages =
      cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages-cachyos-latest;
    kernelParams = [
      "quiet"
      "splash"
    ];
    loader.limine = {
      enable = true;
      maxGenerations = 10;
      style = {
        wallpapers = [ assets/limine.jpg ];
        wallpaperStyle = "centered";
      };
    };
    plymouth = {
      enable = true;
      theme = "spinner";
    };
  };

  security = {
    polkit.enable = true;
  };

  services = {
    desktopManager = {
      plasma6.enable = true;
    };
    displayManager = {
      plasma-login-manager.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    keyd = {
      enable = true;
      keyboards = {
        laptop = {
          ids = [ "0001:0001" ];
          settings = {
            main = {
              "capslock" = "leftcontrol";
              "leftcontrol" = "capslock";
            };
          };
        };
      };
    };
    libinput.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    power-profiles-daemon.enable = true;
    envfs.enable = true;
    fprintd.enable = true;
    fprintd.tod.enable = true;
    fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a;
    printing.enable = true;
  };

  systemd.services = {
    disable-mic-led = {
      description = "Disable microphone mute LED";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "disable-mic-led" ''
          echo off > /sys/class/sound/ctl-led/mic/mode
        ''}";
      };
    };
  };

  networking = {
    hostName = "e14g5";
    networkmanager.enable = true;
  };

  hardware = {
    graphics.enable = true;
  };

  time.timeZone = "America/Costa_Rica";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          Experimental = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
    pam.services = {
      z.kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
      };
      login.fprintAuth = true;
      sudo.fprintAuth = true;
      polkit-1.fprintAuth = true;
    };
  };

  users.users.z = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  programs = {
    firefox.enable = true;
    kdeconnect.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamemode.enable = true;
  };

  environment = {
    systemPackages =
      with pkgs;
      with kdePackages;
      [
        # gui/desktop
        cmus
        cmusfm
        alacritty
        gimp
        pinta
        nicotine-plus
        easytag
        thunderbird-latest
        vlc
        obs-studio
        prismlauncher
        filezilla
        losslesscut

        #kde packages
        oxygen
        oxygen-icons
        oxygen-sounds
        ark
        okular
        ffmpegthumbs
        partitionmanager
        kalk

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
        pfetch
        cmatrix
        jq
        stow
        bat
        tree
        ttyper
        tmux
        wget
        neovim
        git
        gh
        ffmpeg
        zip
        unzip
        yt-dlp
        deno
        rar
        unrar
        pipewire
        wireplumber
        pulseaudio
        power-profiles-daemon
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
      kwin-x11
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

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
