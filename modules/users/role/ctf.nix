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
        apktool
        ascii
        avalonia-ilspy
        bettercap
        binwalk
        bkcrack
        burpsuite
        bytecode-viewer
        capstone
        checksec
        (cutter.withPlugins (
          p: with p; [
            jsdec
            rz-ghidra
            sigdb
          ]
        ))
        detect-it-easy
        dex2jar
        dnscrypt-proxy
        ettercap
        exiftool
        exploitdb
        file
        freerdp
        frida-tools
        fuzzdb
        gdb
        ghex
        ghidra
        hashcat
        hashcat-utils
        honggfuzz
        hopper
        iaito
        ida-free
        imhex
        insomnia
        jadx
        lldb
        loadlibrary
        ltrace
        minimodem
        mitmproxy
        nasm
        nmap
        ngrok
        packer
        payloadsallthethings
        proxychains-ng
        python3Packages.ropper
        radare2
        retdec
        rizin
        ropgadget
        scanmem
        seclists
        shadowsocks-rust
        shadowsocks-v2ray-plugin
        snowman
        socat
        strace
        tcpdump
        traceroute
        uefitool
        udp2raw
        udptunnel
        upx
        v2ray
        valgrind
        vbindiff
        vim.xxd
        vivisect
        volatility2-bin
        volatility3
        wget
        winetricks
        wineWowPackages.staging
        wireguard-tools
        wireshark
        wstunnel
      ];

      home.extraDependencies = with pkgs; [
        cloudflare-warp
        remmina
      ];
    };
  };
}
