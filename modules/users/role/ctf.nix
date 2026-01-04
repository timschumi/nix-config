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
  inherit (inputs.nixpkgs.lib.lists) optionals;
in
{
  config = mkIf (elem role config.extra.user."${user}".roles) {
    age.secrets = {
      binaryninja-license = {
        rekeyFile = inputs.self + "/secrets/original/binaryninja-license.age";
        owner = user;
      };
    };

    home-manager.users."${user}" = {
      home.packages =
        with pkgs;
        [
          aflplusplus
          angr-management
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
          coreboot-utils
          (cutter.withPlugins (
            p: with p; [
              jsdec
              rz-ghidra
              sigdb
            ]
          ))
          delsum
          dex2jar
          diffoscope
          dig
          dnscrypt-proxy
          elfutils
          ettercap
          exiftool
          exploitdb
          ffmpeg-full
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
          # FIXME: libffi is broken
          #hopper
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
          # CMake 3.5 failure
          #retdec
          rizin
          ropgadget
          scanmem
          seclists
          shadowsocks-rust
          shadowsocks-v2ray-plugin
          sleuthkit
          socat
          strace
          tcpdump
          traceroute
          uefitool
          udp2raw
          udptunnel
          udp-over-tcp
          unrar
          upx
          usbtop
          v2ray
          valgrind
          vbindiff
          vim.xxd
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
        ]
        ++ optionals (!config.nixpkgs.config.contentAddressedByDefault) (
          with pkgs;
          [
            # Something, something, "heat death of the universe".
            chromium
            # Something, something, "heat death of the universe" (via electron).
            drawio
            # Conflicts with itself for whatever reason.
            file
          ]
        );

      home.extraDependencies = with pkgs; [
        binaryninja-free
        cloudflare-warp
        detect-it-easy
        remmina
      ];
    };
  };
}
