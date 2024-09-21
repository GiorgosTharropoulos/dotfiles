if [ ! -d "$ZSH/completions" ]; then
  mkdir -p "$ZSH/completions"
fi

pnpm completion zsh >"$ZSH/completions/_pnpm"
