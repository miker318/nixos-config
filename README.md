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
