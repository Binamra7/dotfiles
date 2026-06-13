# Ghostty 👻

My primary terminal. The configuration is managed **in this dotfiles repo** and
symlinked into place by `stow .` — there is nothing to clone separately.

- `config` — the live Ghostty config (edit this file; Ghostty reloads on save).
- `themes/` — bundled color themes referenced by `config`.

Verify the effective settings with:

```sh
ghostty +show-config
```

The theme/font baseline was originally adapted from
[ThorstenRhau/ghostty](https://github.com/ThorstenRhau/ghostty).
