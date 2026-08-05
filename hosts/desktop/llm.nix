{ pkgs, ... }:
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
                					--model /home/guillaume/.cache/huggingface/hub/models--unsloth--Qwen3-Coder-30B-A3B-Instruct-GGUF/snapshots/b17cb02dd882d5b6ab62fc777ad2995f19668350/Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf \
                          --ctx-size 32768 \
                          --n-gpu-layers 999 \
                          --n-cpu-moe 20 \
                          --flash-attn on \
                          --port 8080 \
        									--jinja \
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
