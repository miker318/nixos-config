# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ];

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable VM copy/paste
  services.spice-vdagentd.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  #Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mike = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
    ];
    openssh = {
      authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVkdxQkXWx+KLHR0qbcsopazZXw3RpXmdCn45mRqztyo6uYjtxR1CrFXcl30HPQDC0NLm7spXKO0yzWqBqmOdT7jA1MFO+VMErGRsUC/q5pmOkeL43iTwR3xWIFZYe0JKYDxWesh1T4H3BIAiVCF2XbkCtzsJyW/Am9QFDIgOOHnLXTzqhrubgff500dkyP9O4f18yXxP/gCS/2QGtSaZxo8FWNyuQdnq/+pgg0H2i2tbNLkzaABsyXvRYPLbnnXU/5zW1f1lQEWLcpHPTV1Eypjf1qyMEPEfUiV2wxYcECQJ5zfbt5b9324LrM76onEFBeo3iNzH9Z56OqZAQCiJh2OfDwOhyiVko74vUQ9/Rd62RXYGTkfMuadWZxYgNm/7R2pyEMVl6hKpoIW6+oEtpmWMLVVwEGm1Mr02L7hLaDhHfscg+wCeUNl+bCE1ycoI0aKRixdGGNu0W1WfoAw41zb4S15xctZRY3792OlGQLxVVYg8XUNraaS46DDBTmw9PLyQstmQI7YNFVHfsY2PfcFA1/vI6p+5R1T5B2aFvIY+jOtyD/zHdMi7XJ09W9qo8p47oKDVXqfJoFKoGNzjcW4E+OzsnHsJaqDI5YvrHRRp1i/7K2ULkTfDhhk+Fbw0SkLFUlpvsxtCesn38GL8S3dBOF9bpgHffq+bhY8oJ3Q== mike@ubuntu-nuc"
      ];
    };

  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

