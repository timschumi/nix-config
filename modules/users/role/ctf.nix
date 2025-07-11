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
  imports = [
    (inputs.self + "/fragments/overlay-binaryninja-personal.nix")
    (inputs.self + "/fragments/overlay-ghidra-firmware-utils.nix")
    (inputs.self + "/fragments/overlay-hopper.nix")
    (inputs.self + "/fragments/overlay-nampa.nix")
  ];

  config = mkIf (elem role config.extra.user."${user}".roles) {
    age.secrets = {
      binaryninja-license = {
        rekeyFile = inputs.self + "/secrets/original/binaryninja-license.age";
        owner = user;
      };
    };

    home-manager.users."${user}" = {
      home.packages = with pkgs; [
        aflplusplus
        apktool
        ascii
        avalonia-ilspy
        bettercap
        binaryninja-personal
        binwalk
        biodiff
        bkcrack
        burpsuite
        bytecode-viewer
        capstone
        checksec
        chromium
        coreboot-utils
        (cutter.withPlugins (
          p: with p; [
            jsdec
            rz-ghidra
            sigdb
          ]
        ))
        delsum
        detect-it-easy
        dex2jar
        dig
        dnscrypt-proxy
        drawio
        elfutils
        ettercap
        exiftool
        exploitdb
        ffmpeg-full
        file
        flashrom
        freerdp
        frida-tools
        fuzzdb
        gdb
        ghex
        (ghidra.withExtensions (
          p: with p; [
            findcrypt
            ghidra-delinker-extension
            ghidra-firmware-utils
            ghidra-golanganalyzerextension
            ghidraninja-ghidra-scripts
            kaiju
            ret-sync
            wasm
          ]
        ))
        hashcat
        hashcat-utils
        honggfuzz
        hopper
        httptunnel
        iaito
        ida-free
        imagemagick
        imhex
        insomnia
        jadx
        jq
        lldb
        loadlibrary
        ltrace
        minimodem
        mitmproxy
        nasm
        nmap
        ngrok
        packer
        pahole
        payloadsallthethings
        proxychains-ng
        (python3.withPackages (
          p: with p; [
            angr
            ropper
            standard-telnetlib
          ]
        ))
        radare2
        retdec
        rizin
        ropgadget
        scanmem
        seclists
        shadowsocks-rust
        shadowsocks-v2ray-plugin
        sleuthkit
        snowman
        socat
        strace
        tcpdump
        traceroute
        uefitool
        udp2raw
        udptunnel
        unrar
        upx
        usbtop
        v2ray
        valgrind
        vbindiff
        vim.xxd
        vivisect
        volatility2-bin
        volatility3
        wget
        whois
        winetricks
        wineWowPackages.staging
        wireguard-tools
        wireshark
        wstunnel
        xournalpp
        yt-dlp
      ];

      home.extraDependencies = with pkgs; [
        binaryninja-free
        cloudflare-warp
        remmina
      ];
    };
  };
}
