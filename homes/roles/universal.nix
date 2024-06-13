{pkgs, lib, ...}: 
let 
  modKey = "CTRL_SHIFT";
in { 
  programs.kitty.enable = true;

  xdg.mimeApps.enable = true; # Enable support for default apps. 
  
  kalyx = {
    neofetch.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableVteIntegration = true;
    completionInit = "autoload -U compinit && compinit";
    history.expireDuplicatesFirst = true;
    history.extended = true;
    oh-my-zsh = {
      enable = true;
      custom = "${pkgs.spaceship-prompt}/share/zsh";
      theme = "spaceship";
      extraConfig = ''
        SPACESHIP_JOBS_AMOUNT_THRESHOLD=0
        SPACESHIP_ASYNC_SHOW=false
        SPACESHIP_USER_SHOW=true
      '';
    };
  };
}
