{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Unstable Nixpkgs
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    firefox-addons = { url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"; inputs.nixpkgs.follows = "nixpkgs"; };
    musnix = { url = "github:musnix/musnix"; };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    disko,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    shared-modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
            inherit outputs;
            inherit pkgs-unstable;
          };
          backupFileExtension = "backup";
        };
      }
    ];
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos-pve = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
        # > Our main nixos configuration file <
        modules = shared-modules ++ [
          ./hosts/nixos-pve.nix
          disko.nixosModules.disko
        ];
      };
      nixostest = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
        # > Our main nixos configuration file <
        modules = shared-modules ++ [
          ./hosts/nixostest.nix
          disko.nixosModules.disko
          inputs.musnix.nixosModules.musnix
        ];
      };
      fw-nix = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
        # > Our main nixos configuration file <
        modules = shared-modules ++ [
          ./hosts/fw-nix.nix
          disko.nixosModules.disko
          inputs.musnix.nixosModules.musnix
          inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
        ];
      };
    };
  };
}
