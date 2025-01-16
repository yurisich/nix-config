{ pkgs, ... }:

{
  imports =
    [
      /home/yurisich/nix-config/configuration-extras.nix
    ];

  users.users.yurisich = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILllCpYUy69guv79nNO/4QcXXkgVKb3B4bDY3HEkq937 cardno:19_274_194"
    ];
    description = "Andrew Yurisich";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      direnv
      emacs
      git
      gnumake
      gnupg
      htop
      nix-search-cli
      pass
      python3
      silver-searcher
      starship
      tmux
      tree
      watchexec
      xsel
    ];
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="wheel", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="d13e", ATTRS{idProduct}=="cc10", GROUP="wheel", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="2c97", MODE="0666"
  '';
}
