# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking = {

    hostName = "nixps"; # Define your hostname.
    networkmanager.enable = true;
    wireless.enable = false;
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    rxvt_unicode
    git
    which
    rofi
    chromium
    feh
    imagemagick
    tdesktop
    vscode
    jetbrains.idea-ultimate
    neofetch
    slack
    openjdk
    google-chrome
    nodejs
    yarn
  ];

  nixpkgs.config.allowUnfree = true;

  fonts = {
    fontconfig.enable = true;
    fonts = with pkgs; [
      fira-code
      inconsolata
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.fish.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable mysql
  services.mysql = {
    enable = true;
    dataDir = "/var/db/mysql";
    package = pkgs.mysql;
    ensureDatabases = [ "platform" ];
    ensureUsers = [ { ensurePermissions = { "*.*" = "ALL PRIVILEGES"; }; name = "jonas"; } ];
    extraOptions = ''
			max_allowed_packet=16M
			character_set_server=utf8mb3
			collation_server=utf8mb3_general_ci
			default_storage_engine=innodb
    '';
  };

  # Enable tomcat
  services.tomcat = {
    enable = true;
    baseDir = "/home/jonas/Signavio/tomcat";
    javaOpts = "-Dfile.encoding=UTF-8";
    user = "jonas";
    group = "users";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;
      greeters.gtk = {
	enable = true;
      };
    };

    desktopManager.xterm.enable = false;
    desktopManager.default = "none";
    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      default = "i3";
    };
    layout = "de";

    libinput.enable = true;
   };

  services.compton = {
    enable = true;
    fade = true;
    inactiveOpacity = "0.7";
    shadow = true;
    fadeDelta = 4;
  };

  services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.jonas = {
    isNormalUser = true;
    isSystemUser = false;

    shell = pkgs.fish;

    createHome = true;
    home = "/home/jonas";
    description = "Jonas Beyer";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  security.sudo.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
