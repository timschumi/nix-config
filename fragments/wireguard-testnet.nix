settings:
{
  config,
  inputs,
  lib,
  ...
}:
{
  age.secrets.wireguard-testnet-privkey.rekeyFile =
    inputs.self + "/secrets/original/wireguard-testnet-${config.networking.hostName}-privkey.age";

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard.interfaces.testnet =
    import ../helpers/wireguard-prepare.nix lib
      (
        {
          endpointPeerExtra = {
            dynamicEndpointRefreshSeconds = 300;
            dynamicEndpointRefreshRestartSeconds = 5;
          };
        }
        // settings
      )
      {
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wireguard-testnet-privkey.path;
        peers = [
          {
            # m600
            endpoint = "m600:51820";
            publicKey = "cEUBC0PuTn7mlgkpH5cZ73zBKZi/5Kbf8Gh2qv/ut3g=";
            allowedIPs = [ "10.130.21.1/32" ];
          }
          {
            # m720q
            endpoint = "m720q:51820";
            publicKey = "/eWyFfKzmoFPM+tR0x7nWPaMBrU+P1GujcXF4+YG1Wk=";
            allowedIPs = [ "10.130.21.2/32" ];
          }
        ];
      };
}
