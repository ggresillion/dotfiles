{ ... }:

{
  ####################################################
  # 1️⃣ Boot & kernel parameters
  ####################################################
  boot.kernelParams = [
    # Use TSC for faster clock_gettime (Coffee Lake is reliable)
    "tsc=reliable"
    "clocksource=tsc"
    # Enable zswap (just in case, optional)
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=20"
  ];

  ####################################################
  # 2️⃣ Sysctl tuning (persistent)
  ####################################################
  boot.kernel.sysctl = {
    # Game compatibility
    "vm.max_map_count" = 2147483642;

    # Memory / latency consistency
    "vm.compaction_proactiveness" = 0;
    "vm.watermark_boost_factor" = 1;
    "vm.min_free_kbytes" = 1048576; # 1 GB reserved
    "vm.watermark_scale_factor" = 500;
    "vm.swappiness" = 10;
    "vm.zone_reclaim_mode" = 0;
    "vm.page_lock_unfairness" = 1;

    # Scheduler
    "kernel.sched_autogroup_enabled" = 1;
    "kernel.sched_child_runs_first" = 0;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;

    # Transparent HugePages (THP)
    "vm.transparent_hugepage.enabled" = "madvise";
    "vm.transparent_hugepage.shmem_enabled" = "advise";
    "vm.transparent_hugepage.defrag" = "never";

    # MGLRU (reduces lock contention)
    "vm.lru_gen.enabled" = 5;

    # Network bufferbloat
    "net.core.default_qdisc" = "fq_codel";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  ####################################################
  # 3️⃣ zram swap (RAM-based, no disk swap)
  ####################################################
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25; # uses ~8GB on 32GB RAM
  };

  ####################################################
  # 4️⃣ I/O scheduler for SSDs / NVMe
  ####################################################
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]|nvme[0-9]n[0-9]", ATTR{queue/scheduler}="bfq"
  '';

  ####################################################
  # 5️⃣ NVIDIA driver
  ####################################################
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
  };

  ####################################################
  # 6️⃣ Game utilities
  ####################################################
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  ####################################################
  # 7️⃣ Optional: LD_BIND_NOW for lower first-call latency
  ####################################################
  environment.variables = {
    # Forces shared libraries to be loaded at program start (reduces stutter)
    LD_BIND_NOW = "1";
  };
}
