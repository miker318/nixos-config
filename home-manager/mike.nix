{ pkgs, pkgs-unstable, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mike = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvirtd" "vboxusers"]; # Enable ‘sudo’ for the user.
    packages = (with pkgs; [
      #firefox
      tree
      ardour
      audacity
      qjackctl
      libreoffice-fresh
      transmission_4-gtk
      virt-manager
      solaar
      calibre
      thunderbird
      bitwarden-desktop
      bitwarden-cli
      fastfetch
      localsend
      obsidian
    ])
    
    ++
   
    (with pkgs-unstable; [
      joplin-desktop
      firefoxpwa
    ]);

    openssh = {
      authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVkdxQkXWx+KLHR0qbcsopazZXw3RpXmdCn45mRqztyo6uYjtxR1CrFXcl30HPQDC0NLm7spXKO0yzWqBqmOdT7jA1MFO+VMErGRsUC/q5pmOkeL43iTwR3xWIFZYe0JKYDxWesh1T4H3BIAiVCF2XbkCtzsJyW/Am9QFDIgOOHnLXTzqhrubgff500dkyP9O4f18yXxP/gCS/2QGtSaZxo8FWNyuQdnq/+pgg0H2i2tbNLkzaABsyXvRYPLbnnXU/5zW1f1lQEWLcpHPTV1Eypjf1qyMEPEfUiV2wxYcECQJ5zfbt5b9324LrM76onEFBeo3iNzH9Z56OqZAQCiJh2OfDwOhyiVko74vUQ9/Rd62RXYGTkfMuadWZxYgNm/7R2pyEMVl6hKpoIW6+oEtpmWMLVVwEGm1Mr02L7hLaDhHfscg+wCeUNl+bCE1ycoI0aKRixdGGNu0W1WfoAw41zb4S15xctZRY3792OlGQLxVVYg8XUNraaS46DDBTmw9PLyQstmQI7YNFVHfsY2PfcFA1/vI6p+5R1T5B2aFvIY+jOtyD/zHdMi7XJ09W9qo8p47oKDVXqfJoFKoGNzjcW4E+OzsnHsJaqDI5YvrHRRp1i/7K2ULkTfDhhk+Fbw0SkLFUlpvsxtCesn38GL8S3dBOF9bpgHffq+bhY8oJ3Q== mike@ubuntu-nuc"
      ];
    };
    shell = pkgs.fish;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs-unstable.firefoxpwa ];
  };
  programs.steam.enable = true;
  virtualisation.virtualbox.host = {
    enable = true;
    #enableExtensionPack = true;
  };

  home-manager = {
    users.mike = {
      imports = [ ./home.nix ];
      programs.git = {
        enable = true;
        userName = "Michael Rose";
        userEmail = "mike@erose.org";
      };
      programs.fish = {
        enable = true;
      };
      programs.atuin = {
        enable = true;
        settings = {
        # Uncomment this to use your instance
        # sync_address = "https://majiy00-shell.fly.dev";
        };
      };

      # Setup VM Hypervisor connection
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };

      home.stateVersion = "24.05";
    };
  };

}
