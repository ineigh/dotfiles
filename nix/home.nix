{ pkgs, plasma-manager, ... }:
let
  oblivion = pkgs.vimUtils.buildVimPlugin {
    pname = "oblivion.nvim";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "cloudUser98";
      repo = "oblivion.nvim";
      rev = "b1d94744425aefe0b49e01e0ed9a8bded258d47e";
      hash = "sha256-HtGlEBdEAlG1Z5hVZvvTRj1/0MgwNZZQF0fV9bBHXy0=";
    };
    dependencies = [
      pkgs.vimPlugins.lush-nvim
    ];
  };

  lastfmkey = builtins.readFile ./api/lastfm;
in

{
  home = {
    username = "z";
    homeDirectory = "/home/z";
    stateVersion = "26.05";
  };

  imports = [
    plasma-manager.homeModules.plasma-manager
    ./plasma.nix
  ];

  xdg.configFile."nvim".source = ./nvim;

  programs = {
    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        oblivion
        nvim-lspconfig
        lush-nvim
        conform-nvim
        blink-cmp
        friendly-snippets
        nvim-treesitter
        telescope-nvim
      ];
    };
    equibop = {
      enable = true;
      equicord = {
        settings = {
          autoUpdate = true;
          autoUpdateNotification = true;
          customTitleBar = true;
          disableSmoothScroll = true;
          minimizeToTray = false;
          discordBranch = "stable";
          enabledThemes = [
            "Discord Mica"
          ];
          enabledThemeLinks = [
            # EmojiReplace
            "https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/3b33c83ee23bd5b8eb384c99fb15a6f6d20873d6/Themes/EmojiReplace/EmojiReplace.theme.css"
            # SkeuoCord
            # "https://raw.githubusercontent.com/Marda33/SkeuoCord/9abd7c0d4966c656dfa29df53f71c492ef2640ac/SkeuoCord.theme.css"
          ];
          enableOnlineThemes = true;
          plugins = {
            MusicRichPresence = {
              enabled = true;
              scrobblerBackend = "lastfm";
              shareUsername = true;
              clickableLinks = true;
              hideWithSpotify = false;
              hideWithActivity = false;
              statusName = "";
              statusDisplayType = "artist";
              nameFormat = "artist-first";
              useListeningStatus = true;
              missingArt = "logo";
              showLogo = false;
              showAlbumCover = true;
              apiKey = lastfmkey;
              username = "neighsay";
            };
          };
        };
      };
    };
  };
}
