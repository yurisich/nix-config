{ pkgs, ... }:

{
  users.users.yurisich = {
    isNormalUser = true;
    description = "Andrew Yurisich";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
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
      watchexec
    ];
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };
}