{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "ghostbox";

  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedTCPPorts = [ 22 ]; # SSH only

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  users.users.colton = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      # REPLACE THIS with your real SSH public key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcFZTU0LkipTSL2cl5DOV43mesFGIRc+6w9WLzqeLqn colton@coltonpoplawski.com"
    ];
  };

  environment.systemPackages = with pkgs; [
    tailscale
    git
    vim
  ];

  services.tailscale.enable = true;

  # Optional security hardening
  security.sudo.wheelNeedsPassword = false;
  services.openssh.settings.PermitRootLogin = "no";

  system.stateVersion = "24.05";
}
