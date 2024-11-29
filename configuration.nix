{ pkgs, ... }:

{
  imports =
    [
      /home/yurisich/nix-config/configuration-extras.nix
    ];

  users.users.yurisich = {
    isNormalUser = true;
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
}
