- Assuming
- - your system is x86_64-linux
- - your harddrive device is /dev/vda

FLAKE="github:miker318/nixos-config/master#nixostest"
DISK_DEVICE=/dev/vda
sudo nix \
    --extra-experimental-features 'flakes nix-command' \
    run github:nix-community/disko#disko-install -- \
    --flake "$FLAKE" \
    --write-efi-boot-entries \
    --disk main "$DISK_DEVICE"

sudo nix \
    --extra-experimental-features 'flakes nix-command' \
    run github:nix-community/disko#disko -- \
    --mode disko --flake "$FLAKE"

nixos-install --flake "$FLAKE"

# using nixos-anywhere

Boot installer  
set passwd for nixos  
ssh into installer or run in console  
sudo nix --extra-experimental-features 'flakes nix-command' run github:nix-community/nixos-anywhere -- --flake "github:miker318/nixos-config/master#nixostest" --build-on-remote nixos@localhost
