$env.XDG_CONFIG_HOME = $env.HOME | path join ".config/"
$env.EDITOR = "nvim"
$env.config = {
  buffer_editor: "nvim"
  show_banner: false
  edit_mode: "vi"
  cursor_shape: {
    vi_insert: underscore
    vi_normal: block
    emacs: line
  }
}
