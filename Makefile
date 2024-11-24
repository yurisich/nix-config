default: links /etc/nixos/configuration.nix home/.bash_profile.source

/etc/nixos/configuration.nix: configuration.nix
	sudo nixos-rebuild switch

links: links/home
links/%:
	@cd $*; for dotfile in $$(find . -type f); do \
	  echo "ln $(abspath $(PWD)/$*/$$dotfile) -> $(abspath $(HOME)/$$dotfile"); \
	  ln -sf $(abspath $(PWD)/$*/"$$dotfile") $(abspath $(HOME)/"$$dotfile"); \
	done

home/.bash_profile.source:
	source home/.bash_profile

~/.emacs.d/tree-sitter/%:
	nix-shell -p gcc --run "./home/.emacs.d/tree-sitter-install.sh $*"
