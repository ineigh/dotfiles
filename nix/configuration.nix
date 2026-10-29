{
  pkgs,
  cachyos-kernel,
  plasma-manager,
  pano-scrobbler,
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
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
    consoleLogLevel = 3;
    loader.limine = {
      enable = true;
      maxGenerations = 5;
      style = {
        wallpapers = [ assets/limine.png ];
        wallpaperStyle = "centered";
      };
      extraConfig = ''
        	  mouse: no
        	  '';
      extraEntries = ''
        	  /Windows 10
        		protocol: efi
        		path: uuid(155449ac-e62e-4bbb-992c-13bdf918107b):/EFI/Microsoft/Boot/bootmgfw.efi
        		'';
    };
    plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [ pkgs.nixos-bgrt-plymouth ];
    };
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
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    syncthing = {
      enable = true;
      user = "z";
      dataDir = "/home/z";
      configDir = "/home/z/.config/syncthing";
      openDefaultPorts = true;
      guiAddress = "127.0.0.1:8384";
      settings = {
        options = {
          localAnnounceEnabled = true;
          globalAnnounceEnabled = false;
          relaysEnabled = false;
          natEnabled = false;
          urAccepted = -1;
        };
      };
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
        hhkb = {
          ids = [ "0853:0100" ];
          settings = {
            main = {
              "rightmeta" = "rightalt";
              "rightalt" = "rightmeta";
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
    fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a;
    fprintd.enable = true;
    fprintd.tod.enable = true;
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
    graphics.enable = true;
  };

  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
    rtkit.enable = true;
    pam.services = {
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
        strawberry
        pano-scrobbler.packages.${pkgs.stdenv.hostPlatform.system}.default
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

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    jetbrains-mono
    iosevka
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}
