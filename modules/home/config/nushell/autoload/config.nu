$env.XDG_CONFIG_HOME = $env.HOME | path join ".config/"
$env.EDITOR = "nvim"
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.cursor_shape = {
  vi_insert: underscore
  vi_normal: block
  emacs: line
}
$env.config.history.file_format = "sqlite"
