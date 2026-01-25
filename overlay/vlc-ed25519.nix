[
  (final: prev: {
    vlc = prev.vlc.overrideAttrs (
      finalAttrs: previousAttrs: {
        patches = previousAttrs.patches ++ [
          # access: sftp: add public key auth options
          (final.fetchpatch2 {
            url = "https://github.com/videolan/vlc/commit/3b506f55e0038644a24ab2b015cfe09ed0a65ad0.patch?full_index=1";
            hash = "sha256-oZAen8AiTkVse1/SAfp3UUiKwOdC36zeaOJ/foqJw3w=";
          })
          # access: sftp: add ED25519 hostkey support
          (final.fetchpatch2 {
            url = "https://github.com/videolan/vlc/commit/6368db7b66414ce73db066c373021f1706113dee.patch?full_index=1";
            hash = "sha256-eEsoHRWNtjt/KqajMU+Ld9cRLJlxFpqAHWjanB3ohdU=";
          })
          # access: sftp: store creds on successful pubkey auth
          (final.fetchpatch2 {
            url = "https://github.com/videolan/vlc/commit/dcc36360256dfa11bf57880c063ca02d8bdf4d90.patch?full_index=1";
            hash = "sha256-g7nTwYsoejfYusElsxod5d485Q2q94ON7HKMmGw9/Go=";
          })
        ];
      }
    );
  })
]
