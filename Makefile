default: links /etc/nixos/configuration.nix

/etc/nixos/configuration.nix: configuration.nix
	sudo nixos-rebuild switch

links: links/home
links/%:
	@cd $*; for dotfile in $$(find . -type f); do \
	  echo "ln $(abspath $(PWD)/$*/$$dotfile) -> $(abspath $(HOME)/$$dotfile"); \
	  ln -sf $(abspath $(PWD)/$*/"$$dotfile") $(abspath $(HOME)/"$$dotfile"); \
	done
