{
  role,
  user,
  ...
}@presets:
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (builtins) elem;
  inherit (inputs.nixpkgs.lib) mkIf;
in
{
  config = mkIf (elem role config.extra.user."${user}".roles) {
    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        aflplusplus
        ascii
        avalonia-ilspy
        binwalk
        checksec
        detect-it-easy
        file
        fuzzdb
        gdb
        ghex
        ghidra
        honggfuzz
        ida-free
        imhex
        lldb
        ltrace
        minimodem
        radare2
        remmina
        ropgadget
        scanmem
        socat
        strace
        tcpdump
        uefitool
        valgrind
        vbindiff
        vim.xxd
        wget
        wireguard-tools
        wireshark
      ];
    };
  };
}
