# RX 9070 XT tuning log

Gigabyte RX 9070 XT Gaming OC, tuned through LACT (`services.lact` in
`hosts/desktop/gaming.nix`). The current values live there; this is how they
were found.

Tuning log (2026-10-29, Gigabyte RX 9070 XT Gaming OC). Driver
limits: voltage offset -200..0 mV, clock offset -500..+1000 MHz,
memory <= 1500 MHz. Stress tests with `gpu-oc tune` (pkgs/gpu-oc,
FurMark + vkmark + memtest_vulkan, applied live through LACT):
- voltage, memory 1300: -50 to -150 mV passed (FurMark score 7841
  -> 8238, +5%), -160 and -170 mV hung the GPU (ring gfx timeout).
- memory, at -140 mV: 1300 -> 1450 MHz passed (bandwidth 579 ->
  635 GB/s, flat above 1425), 1475 hung the GPU.
- clock offset +50 MHz, at -140 mV / 1425: hard freeze (grey screen,
  reboot). Unclear: -140 mV alone failed the soak afterwards.
- soak (FurMark 4 min + memtest 2 min + vkmark), -140 mV / 1425:
  vkmark device lost (light, high-clock loads break undervolts).
In Cyberpunk 2077 (stress tests missed both failures):
- -130 mV / 1425: GPU hang after ~10 min.
- -110 mV / 1425, then -110 mV / 1300: rainbow-noise textures on
  HUD icons. Mostly gone at -50 mV / 1300, but a few remained:
  memory back to stock (1259) to rule out the memory OC.
- -50 mV / 1259 / 374 W / manual 3D_FULL_SCREEN: a few artifacts.
  Full stock: none. Then settings re-added one by one: -50 mV +
  374 W with performance level auto looked clean, then manual
  3D_FULL_SCREEN put back (values below, memory at stock).
Next (validate in game, after a full restart of it): if artifacts
come back, try performance level auto (the only change since the
clean setup), then drop the undervolt; if not, try -80 mV, then 1300+
MHz memory. GPU hangs reset the card and crash niri (the session).
- 2026-11-07: CRACK (native Vulkan) hit GPU page faults + ring gfx
  timeouts at -50 mV; stable on stock, undervolt reduced to -30 mV.
  Crashed again at -30 mV with manual 3D_FULL_SCREEN (full GPU
  reset): power profile forced back to BOOTUP_DEFAULT.
- 2026-11-11: Portal 2 artifacts at -30 mV: undervolt removed (`voltage_offset`
  omitted; "vo 0" is rejected by the kernel with EINVAL).
