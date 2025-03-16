# Pull & apply latest dotfiles from repo
[group('Dotfiles')]
update-dotfiles:
  chezmoi update
