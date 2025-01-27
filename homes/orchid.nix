{ config, pkgs, ... }:

let
  userApply = pkgs.writeScriptBin "user-apply" ''
    #!${pkgs.stdenv.shell}
    pushd /persist/source-of-truth/

    home-manager switch --flake '.#irene-orchid'

    popd
  '';

  systemApply = (pkgs.callPackage ../scripts/system-apply.nix {
    configPath = "/persist/source-of-truth";
  }).systemApply;

in
{
  imports = [
    ../desktop/emacs
    # ../rices/hypr

    ../scripts/system-clean.nix
    ../misc/fish.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = { };

  # programs.nushell.enable = true;
  services.vscode-server.enable = true;
  services.vscode-server.enableFHS = true;

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  home.packages = with pkgs; [
    # System utils
    hyfetch
    pfetch
    htop
    dstat
    sshfs
    pciutils
    file
    eza
    git
    bat
    jq
    unzip
    ripgrep
    usbutils
    openssl
    curl
    wget
    traceroute
    zip
    nixos-shell
    coreutils
    fd
    git-crypt
    gnupg
    fzf
    ipcalc
    iperf3
    zellij
    tmux
    screen
    grc

    # Nix
    nixpkgs-fmt
    # rnix-lsp
    gnumake
    nixfmt-classic

    # Project management
    devenv
    direnv

    fontconfig
    cmake
    pkg-config
    quickemu

    # Rust
    # rust-analyzer
    # clang

    # Python
    # pipenv

    # pandoc
    # texliveFull

    # Docker
    docker-compose
    # mkcert

    # Desktop
    # firefox
    # keepassxc
    # chromium
    # alacritty

    # trunk.geekbench
    # prismlauncher

    # Custom
    userApply
    systemApply
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
