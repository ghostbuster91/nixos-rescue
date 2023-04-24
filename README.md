```
sudo nixos-rebuild switch --flake .
```

```
nixos-install --flake https://github.com/ghostbuster91/nixos-rescue#somehost
```

```
nix run github:nix-community/disko --extra-experimental-features flakes --extra-experimental-features nix-command -- --mode zap_create_mount /tmp/disko-config.nix --arg disks '[ "/dev/sda" "/dev/sdb" ]'
```

```
nixos-generate-config --no-filesystems --root /mnt
```
