{ pkgs, ... }:
let
  # The chat template shipped in the Qwen3-Coder GGUF is Unsloth's, which renders
  # non-string tool-call arguments with the Jinja `string` filter. minja emits
  # Python repr for that (single quotes), so every turn re-renders the model's own
  # prior tool call as
  #     [{"content": "..."}]   ->   [{'content': '...'}]
  # while the adjacent <tool_response> stays real JSON. The prompt contradicts
  # itself, so the model re-emits the same tool call instead of stopping.
  # Using tojson keeps the round-trip in the format the model actually emits.
  chatTemplate = pkgs.writeText "qwen3-coder-chat-template.jinja" (
    builtins.readFile ./qwen3-coder.jinja
  );
in
{
  nixpkgs.config.rocmSupport = true;
  environment.systemPackages = [ pkgs.llama-cpp-rocm ];

  systemd.services.llama-server = {
    description = "llama.cpp server";

    after = [ "network.target" ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.llama-cpp-rocm}/bin/llama-server \
        	--model /home/guillaume/models/Qwen3-Coder-30B-A3B-Instruct-Q3_K_M.gguf \
        	--ctx-size 32768 \
        	--n-gpu-layers 999 \
        	--n-cpu-moe 24 \
        	--flash-attn on \
        	--threads 8 \
        	--port 8080 \
        	--jinja \
        	--chat-template-file ${chatTemplate} \
        	--temp 0.6 \
        	--top-p 0.95 \
        	--top-k 20 \
        	--min-p 0.0 \
        	--repeat-penalty 1.05 \
        	--sleep-idle-seconds 30
      '';

      Restart = "always";
      RestartSec = 5;
      TimeoutStartSec = "0";

      # optional: keep it from getting killed by OOM
      OOMScoreAdjust = -500;

      User = "guillaume";
      WorkingDirectory = "/home/guillaume";

      Environment = [
        "HOME=/home/guillaume"
      ];
    };
  };
}
