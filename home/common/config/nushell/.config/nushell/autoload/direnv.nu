use std/config *
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []
$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) { return }
  direnv export json | from json | default {} | load-env
  $env.PATH = do (env-conversions).path.from_string $env.PATH
}]

# Walk up from PWD to find the nearest .envrc or .env (mirroring direnv's behavior)
def find-direnv-root [] {
  mut dir = $env.PWD
  loop {
    for f in [".envrc", ".env"] {
      let candidate = ($dir | path join $f)
      if ($candidate | path exists) { return $candidate }
    }
    let parent = ($dir | path dirname)
    if $parent == $dir { return null }  # reached filesystem root
    $dir = $parent
  }
}

$env.config.hooks.pre_prompt = $env.config.hooks.pre_prompt? | default []
$env.config.hooks.pre_prompt ++= [{||
  if (which direnv | is-empty) { return }

  let found = find-direnv-root
  if $found == null { return }

  let mtime = (ls -l $found | get modified.0 | into string)
  let last = $env.DIRENV_LAST_MTIME? | default ""

  if $mtime != $last {
    $env.DIRENV_LAST_MTIME = $mtime
    direnv export json | from json | default {} | load-env
    $env.PATH = do (env-conversions).path.from_string $env.PATH
  }
}]
