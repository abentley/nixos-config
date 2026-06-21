# NVIDIA and Dual-GPU/PRIME configuration for gamey.
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    # GTX 1070 not supported on the lastest & greatest.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # PCI bus IDs. Check with `lspci | grep -E 'VGA|3D'`
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.sessionVariables = {
    # Force Hyprland (using Aquamarine/wlroots) to render the Wayland desktop on the iGPU.
    # Check available paths with `ls -l /dev/dri/by-path/`
    AQ_DRM_DEVICES = "/dev/dri/by-path/pci-0000:00:02.0-card:/dev/dri/by-path/pci-0000:01:00.0-card";
    WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:00:02.0-card:/dev/dri/by-path/pci-0000:01:00.0-card";
  };

  # Force GNOME / Mutter to run on the Intel integrated GPU (needed for dual-GPU setup)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="drm", KERNELS=="0000:00:02.0", TAG+="mutter-device-preferred-primary"
  '';
}
