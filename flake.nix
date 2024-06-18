{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    firefox-addons = { url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"; inputs.nixpkgs.follows = "nixpkgs"; };
    musnix = { url = "github:musnix/musnix"; };
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    specialArgs = {inherit inputs outputs;};
    shared-modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
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
        };
        # > Our main nixos configuration file <
        modules = shared-modules ++ [
          disko.nixosModules.disko
          ./hosts/nixos-pve.nix
        ];
      };
      nixostest = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        # > Our main nixos configuration file <
        modules = shared-modules ++ [
          ./hosts/nixostest.nix
          disko.nixosModules.disko
          inputs.musnix.nixosModules.musnix
        ];
      };
    };
  };
}
