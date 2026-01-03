{
  config,
  pkgs,
  lib,
  ...
}:

{
  # This option is enabled on laptops.
  options.features.battery-notifier = {
    enable = lib.mkEnableOption "battery notifier";
  };

  config = lib.mkIf config.features.battery-notifier.enable (
    let
      battery-check-script = pkgs.writeShellScriptBin "check-battery" (
        builtins.readFile ./../scripts/check-battery.sh
      );
    in
    {
      environment.systemPackages = [ pkgs.libnotify ];
      # The script to run.
      systemd.services.battery-check = {
        description = "Check battery level";
        serviceConfig = {
          Type = "oneshot";
          User = "abentley";
          Environment = "DISPLAY=:0";
        };
        path = [
          pkgs.libnotify
          battery-check-script
        ];
        script = "check-battery";
      };

      # Run the service every 5 minutes.
      systemd.timers.battery-check = {
        description = "Run battery check every 5 minutes";
        timerConfig = {
          OnBootSec = "1m";
          OnUnitActiveSec = "5m";
        };
        wantedBy = [ "timers.target" ];
      };
    }
  );
}
