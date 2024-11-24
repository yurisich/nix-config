# nix-config

This is a minimal example of using nixOS at arguably its least capability. It does simplify a lot of things in my previous iterations of maintaining dotfiles, so if you're looking for a way to manage the bare minimum to start spinning up flakes this should be enough to get started.

![The end result of the terminal installed.](https://github.com/user-attachments/assets/816af49c-91fb-4644-84b6-d5116f03bef6)

## pre-requisites

- A yubikey acting as a gpg smart card, with a gpg key on it.
- An existing github account with your user profile's .gpg endpoint correctly configured.
 - E.g., https://github.com/yurisich.gpg
- *Optional*: an existing .password-store directory that you use via your yubikey.

## installing

Install NixOS (the operating system, not the package manager) using the graphical installer option on https://nixos.org/download/ and boot from a USB drive.

Choose Cinnamon as the desktop.

## bootstrapping

### gpg

Open a terminal and run:

```sh
nix-shell -p git gnumake gnupg pass openssh
```

Make sure you're not someplace other than home.

```sh
cd ~
```

Once there, ensure your yubikey is entered into the computer.

```sh
gpg --edit-card
```

Once your yubikey smartcard data is showing, type in the command

```sh
fetch
```

Then, exit with `ctrl + d`.

Next, trust your own key

```sh
gpg --edit-key "$(gpg -k | head -n 4 | tail -n 1)"
```

Once your gpg key and subkeys are displayed type in the command

```sh
trust
```

Then enter `5` for "I trust ultimately". Confirm when it asks if you're sure by typing `y`.

Then, exit with `ctrl + d`.

### ssh

Set this one time to get everything cloned.

```sh
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
```

Test that you can login with your yubikey.

```
ssh -T git@github.com
Hi yurisich! You've successfully authenticated, but GitHub does not provide shell access.
```

```sh
git clone git@github.com:yurisich/nix-config.git
```

### make

After cloning the nix-config repository, enter it and run the default make target.

```sh
cd nix-config/
make
```

### password store

This would also be a good time to clone your password store.

```sh
git clone git@github.com:yurisich/.password-store.git
```

You could log into github now using firefox, which should be already available.

```
pass -c github.com/yurisich
Copied github.com/yurisich to clipboard. Will clear in 45 seconds.
```

### hook up the user-level nix configuration

Open a terminal:

```sh
$: sudo nano /etc/nixos/configuration.nix
```

Find line 10 and update it to refer to the new user-level configurations in this repo.

```nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/yurisich/nix-config/configuration.nix
    ];
```

Obviously, use your own username instead of my own.

```sh
sudo nix-rebuild switch
```

You will still need to change a couple of things to get things working exactly.

### gnome terminal

I would like to put this into my nix configuration someday...

Open a terminal with `ctrl + alt + t`, click "Edit" -> "Preferences".

After selecting the "Unnamed" profile on the left side of the menu, go to the "Text" tab and change the initial terminal size to 180 columns, 40 rows.

Go to the "Command" tab, and do these steps:

- check "Run command as a login shell"
- check "Run a custom command instead of my shell"
- in "Custom command", enter `/home/yurisich/.tmux.setup`
 - (use your name, not mine)
- for "When command exits", select "Hold the terminal open".
