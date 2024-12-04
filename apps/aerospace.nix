{ pkgs, ... }:

{
  services.aerospace = {
    enable = true;
    settings = {
      # You can use it to add commands that run after login to macOS user session.
      # 'start-at-login' needs to be 'true' for 'after-login-command' to work
      # Available commands: https://nikitabobko.github.io/AeroSpace/commands
      after-login-command = [];
      
      # You can use it to add commands that run after AeroSpace startup.
      # 'after-startup-command' is run after 'after-login-command'
      # Available commands : https://nikitabobko.github.io/AeroSpace/commands
      after-startup-command = [];
      
      # Start AeroSpace at login
      # start-at-login = true;
      
      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      
      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      # The 'accordion-padding' specifies the size of accordion padding
      # You can set 0 to disable the padding feature
      accordion-padding = 30;
      
      # Possible values: tiles|accordion
      default-root-container-layout = "tiles";
      
      # Possible values: horizontal|vertical|auto
      # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
      #               tall monitor (anything higher than wide) gets vertical orientation
      default-root-container-orientation = "auto";
      
      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      # Fallback value (if you omit the key): on-focused-monitor-changed = []
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      
      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
      # Also see: https://nikitabobko.github.io/AeroSpace/goodness#disable-hide-app
      automatically-unhide-macos-hidden-apps = false;
      
      # Possible values: (qwerty|dvorak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      key-mapping.preset = "qwerty";
  
      
      # Gaps between windows (inner-*) and between monitor edges (outer-*).
      # Possible values:
      # - Constant:     gaps.outer.top = 8
      # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
      #                 In this example, 24 is a default value when there is no match.
      #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
      #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
      gaps = {
        inner.horizontal = 12;
        inner.vertical =   12;
        outer.left =       6;
        outer.bottom =     6;
        outer.top =        6;
        outer.right =      6;
      };
      
      # 'main' binding mode declaration
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # 'main' binding mode must be always presented
      # Fallback value (if you omit the key): mode.main.binding = {}
      mode.main.binding = {
        cmd-ctrl-k = "mode kommand";
      };
  
      mode.kommand.binding = {
        esc     = "mode main";
        s       = "mode service";
        shift-m = "mode merge";
  
        h = [ "focus left" "mode main" ];
        j = [ "focus down" "mode main" ];
        k = [ "focus up" "mode main" ];
        l = [ "focus right" "mode main" ];
  
        shift-h = [ "move left" "mode main" ];
        shift-j = [ "move down" "mode main" ];
        shift-k = [ "move up" "mode main" ];
        shift-l = [ "move right" "mode main" ];
  
        shift-minus = [ "resize smart -50" "mode main" ];
        shift-equal = [ "resize smart +50" "mode main" ];
  
        "1" = [ "workspace 1" "mode main" ];
        "2" = [ "workspace 2" "mode main" ];
        "3" = [ "workspace 3" "mode main" ];
        "4" = [ "workspace 4" "mode main" ];
  
        shift-1 = [ "move-node-to-workspace 1" "mode main" ];
        shift-2 = [ "move-node-to-workspace 2" "mode main" ];
        shift-3 = [ "move-node-to-workspace 3" "mode main" ];
        shift-4 = [ "move-node-to-workspace 4" "mode main" ];
  
        slash = [ "layout tiles horizontal vertical" "mode main" ];
        comma = [ "layout accordion horizontal vertical" "mode main" ];

	c = [ ''exec-and-forget aerospace focus --window-id $(aerospace list-windows --monitor all --app-bundle-id net.kovidgoyal.kitty --format %{window-id} | head -n 1)'' "mode main" ];
	b = [ ''exec-and-forget aerospace focus --window-id $(aerospace list-windows --monitor all --app-bundle-id company.thebrowser.Browser --format %{window-id} | head -n 1)'' "mode main" ];
      };
      
      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"]; # reset layout
        f = ["layout floating tiling" "mode main"]; # Toggle between floating and tiling layout
        w = ["close-all-windows-but-current" "mode main"];
      };
  
      mode.merge.binding = {
        h = ["join-with left" "mode main"];
        j = ["join-with down" "mode main"];
        k = ["join-with up" "mode main"];
        l = ["join-with right" "mode main"];
      };
  
      # All possible keys:
      # - Letters.        a, b, c, ..., z
      # - Numbers.        0, 1, 2, ..., 9
      # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
      # - F-keys.         f1, f2, ..., f20
      # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
      #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
      # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
      #                   keypadMinus, keypadMultiply, keypadPlus
      # - Arrows.         left, down, up, right
      
      # All possible modifiers: cmd, alt, ctrl, shift
      
      # All possible commands: https://nikitabobko.github.io/AeroSpace/commands
      
      # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
      # You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
      # alt-enter = '''exec-and-forget osascript -e '
      # tell application "Terminal"
      #     do script
      #     activate
      # end tell'
      # '''
    };
  };
}
