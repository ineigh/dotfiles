{
  pkgs,
  cachyos-kernel,
  plasma-manager,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
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
      "kvm-amd"
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
      overrideDevices = false;
      overrideFolders = false;
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
    fprintd = {
      enable = true;
      tod = {
        driver = pkgs.libfprint-2-tod1-goodix-550a;
        enable = true;
      };
    };
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
      login = {
        fprintAuth = true;
        kwallet = {
          enable = true;
        };
      };
      sudo.fprintAuth = true;
      polkit-1.fprintAuth = true;
      kde-fingerprint.fprintAuth = true;
      kscreenlocker.fprintAuth = true;
    };
  };

  users.users.z = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
    ];
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
    virt-manager.enable = true;
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

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-42.11.18"
      ];
    };
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
