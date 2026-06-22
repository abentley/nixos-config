# NVIDIA and Dual-GPU/PRIME configuration for gamey.
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
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
    # We use custom symlinks created via udev rules to avoid colon-splitting errors.
    AQ_DRM_DEVICES = "/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu";
    WLR_DRM_DEVICES = "/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu";
  };

  # Force GNOME / Mutter to run on the Intel integrated GPU (needed for dual-GPU setup)
  # and create persistent symlinks without colons for DRM devices.
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:00:02.0", SYMLINK+="dri/intel-igpu", TAG+="mutter-device-preferred-primary"
    SUBSYSTEM=="drm", KERNEL=="card*", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-dgpu"
  '';
}
