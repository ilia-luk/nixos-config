{ pkgs, ... }: {
  home.packages = with pkgs; [ hypridle playerctl ];

  services.hypridle.enable = true;

  services.hypridle.settings = {
    general = {
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      lock_cmd = "pidof hyprlock || hyprlock";
    };
    listener = [
      {
        timeout = 500;
        on-timeout = "notify-send 'You are idle!'";
        on-resume = "notify-send 'Welcome back!'";
      }
      {
        timeout = 1500;
        on-timeout =
          "if ! playerctl -a status | grep -q Playing; then loginctl lock-session; fi";
      }
      {
        timeout = 3000;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 6000;
        on-timeout = "systemctl suspend";
      }
    ];
  };
}
