{
  raidpool,
  devNode,
  hostId,
}:
{
  pkgs,
  lib,
  config,
  ...
}:
let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  boot.kernelPackages = latestKernelPackage;
  boot.loader.grub.zfsSupport = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = devNode;
  boot.zfs.extraPools = [ raidpool ];
  services.zfs.autoScrub.enable = true;
  networking.hostId = hostId;
}
