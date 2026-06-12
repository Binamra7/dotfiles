-- Launch ruby-lsp through mise so it runs under the project's Ruby version
-- (resolved from .ruby-version / mise config relative to nvim's cwd).
-- Without this, ruby-lsp runs under mise's `latest` and bundler aborts with
-- RubyVersionMismatch in projects that pin an older Ruby in their Gemfile.
-- Requires: `gem install ruby-lsp` in EACH mise Ruby a project uses.
return {
	cmd = { "mise", "x", "--", "ruby-lsp" },
}
