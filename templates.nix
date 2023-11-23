{
  alacritty = { config = builtins.fromJSON ''{"default":{"extension":".yml","output":"colors"},"default-256":{"extension":"-256.yml","output":"colors"}}''; rootPath = ./data/templates/alacritty; };
  amfora = { config = builtins.fromJSON ''{"default":{"extension":".toml","output":"colors"}}''; rootPath = ./data/templates/amfora; };
  binary-ninja = { config = builtins.fromJSON ''{"default":{"extension":".theme","output":"colors"}}''; rootPath = ./data/templates/binary-ninja; };
  c_header = { config = builtins.fromJSON ''{"default":{"extension":".h","output":"headers"}}''; rootPath = ./data/templates/c_header; };
  concfg = { config = builtins.fromJSON ''{"default":{"extension":".json","output":"presets"}}''; rootPath = ./data/templates/concfg; };
  conemu = { config = builtins.fromJSON ''{"default":{"extension":".xml","output":"themes"}}''; rootPath = ./data/templates/conemu; };
  console2 = { config = builtins.fromJSON ''{"default":{"extension":".xml","output":"colors"}}''; rootPath = ./data/templates/console2; };
  consolez = { config = builtins.fromJSON ''{"default":{"extension":".xml","output":"colors"}}''; rootPath = ./data/templates/consolez; };
  crosh = { config = builtins.fromJSON ''{"default":{"extension":".js","output":"colors"},"default-16":{"extension":".16.js","output":"colors"}}''; rootPath = ./data/templates/crosh; };
  doom = { config = builtins.fromJSON ''{"default":{"extension":".el","output":"themes"}}''; rootPath = ./data/templates/doom; };
  dunst = { config = builtins.fromJSON ''{"default":{"extension":".dunstrc","output":"themes"},"inverted-backgrounds":{}}''; rootPath = ./data/templates/dunst; };
  dwm = { config = builtins.fromJSON ''{"default":{"extension":".diff","output":"diffs"}}''; rootPath = ./data/templates/dwm; };
  emacs = { config = builtins.fromJSON ''{"default":{"extension":"-theme.el","output":"build"}}''; rootPath = ./data/templates/emacs; };
  everything = { config = builtins.fromJSON ''{"default":{"extension":".ini","output":"colors"}}''; rootPath = ./data/templates/everything; };
  foot = { config = builtins.fromJSON ''{"default":{"extension":".ini","output":"colors"}}''; rootPath = ./data/templates/foot; };
  frescobaldi = { config = builtins.fromJSON ''{"default":{"extension":".xml","output":"themes"}}''; rootPath = ./data/templates/frescobaldi; };
  fzf = { config = builtins.fromJSON ''{"default":{"extension":".config","output":"bash"},"fish":{"extension":".fish","output":"fish"}}''; rootPath = ./data/templates/fzf; };
  gnome-terminal = { config = builtins.fromJSON ''{"default":{"extension":".sh","output":"color-scripts"},"default-256":{"extension":"-256.sh","output":"color-scripts"}}''; rootPath = ./data/templates/gnome-terminal; };
  godot = { config = builtins.fromJSON ''{"default":{"extension":".tet","output":"text_editor_themes"}}''; rootPath = ./data/templates/godot; };
  gtk-flatcolor = { config = builtins.fromJSON ''{"gtk-2":{"extension":"-gtkrc","output":"gtk-2"},"gtk-3":{"extension":"-gtk.css","output":"gtk-3"}}''; rootPath = ./data/templates/gtk-flatcolor; };
  gtk2 = { config = builtins.fromJSON ''{"schemes":{"extension":".gtkrc","output":"schemes"}}''; rootPath = ./data/templates/gtk2; };
  helix = { config = builtins.fromJSON ''{"default":{"extension":".toml","output":"themes"}}''; rootPath = ./data/templates/helix; };
  hexchat = { config = builtins.fromJSON ''{"default":{"extension":".conf","output":"colors"}}''; rootPath = ./data/templates/hexchat; };
  highlight = { config = builtins.fromJSON ''{"default":{"extension":".theme","output":"highlight-themes"}}''; rootPath = ./data/templates/highlight; };
  highlightjs = { config = builtins.fromJSON ''{"default":{"extension":".css","output":"themes","prefix":""}}''; rootPath = ./data/templates/highlightjs; };
  html-preview = { config = builtins.fromJSON ''{"css":{"extension":".css","output":"css"},"preview":{"extension":".html","output":"previews"}}''; rootPath = ./data/templates/html-preview; };
  hugo = { config = builtins.fromJSON ''{"default":{"extension":".css","output":"hugo-base16-css"}}''; rootPath = ./data/templates/hugo; };
  i3 = { config = builtins.fromJSON ''{"bar-colors":{"extension":".config","output":"bar-colors"},"client-properties":{"extension":".config","output":"client-properties"},"colors":{"extension":".config","output":"colors"},"default":{"extension":".config","output":"themes"}}''; rootPath = ./data/templates/i3; };
  i3status = { config = builtins.fromJSON ''{"default":{"extension":".config","output":"colors"}}''; rootPath = ./data/templates/i3status; };
  i3status-rust = { config = builtins.fromJSON ''{"default":{"extension":".toml","output":"colors"}}''; rootPath = ./data/templates/i3status-rust; };
  iterm2 = { config = builtins.fromJSON ''{"default":{"extension":".itermcolors","output":"itermcolors"},"default-256":{"extension":"-256.itermcolors","output":"itermcolors"}}''; rootPath = ./data/templates/iterm2; };
  jetbrains = { config = builtins.fromJSON ''{"accent":{"extension":".accent.xml","output":"options"},"default":{"extension":".icls","output":"colors"},"scheme":{"extension":".scheme.xml","output":"options"},"theme":{"extension":".theme.xml","output":"options"}}''; rootPath = ./data/templates/jetbrains; };
  joe = { config = builtins.fromJSON ''{"default":{"extension":".jcf","output":"colors"}}''; rootPath = ./data/templates/joe; };
  k9s = { config = builtins.fromJSON ''{"default":{"extension":".yml","output":"themes"}}''; rootPath = ./data/templates/k9s; };
  kakoune = { config = builtins.fromJSON ''{"default":{"extension":".kak","output":"colors"}}''; rootPath = ./data/templates/kakoune; };
  kitty = { config = builtins.fromJSON ''{"default":{"extension":".conf","output":"colors"},"default-256":{"extension":"-256.conf","output":"colors"}}''; rootPath = ./data/templates/kitty; };
  konsole = { config = builtins.fromJSON ''{"default":{"extension":".colorscheme","output":"colorscheme"},"vim":{"extension":".colorscheme","output":"colorscheme-vim"}}''; rootPath = ./data/templates/konsole; };
  luakit = { config = builtins.fromJSON ''{"colors":{"extension":".lua","output":"colors"},"default":{"extension":".lua","output":"themes"}}''; rootPath = ./data/templates/luakit; };
  mako = { config = builtins.fromJSON ''{"default":{"extension":".config","output":"colors"}}''; rootPath = ./data/templates/mako; };
  mate-terminal = { config = builtins.fromJSON ''{"default":{"extension":".sh","output":"color-scripts"},"default-256":{"extension":"-256.sh","output":"color-scripts"}}''; rootPath = ./data/templates/mate-terminal; };
  mintty = { config = builtins.fromJSON ''{"default":{"extension":".minttyrc","output":"mintty"},"default-256":{"extension":"-256.minttyrc","output":"mintty"}}''; rootPath = ./data/templates/mintty; };
  monodevelop = { config = builtins.fromJSON ''{"default":{"extension":".json","output":"themes"}}''; rootPath = ./data/templates/monodevelop; };
  neovim = { config = builtins.fromJSON ''{"default":{"extension":".lua","output":"colors"}}''; rootPath = ./data/templates/neovim; };
  nvim = { config = builtins.fromJSON ''{"default":{"extension":".lua","output":"colors"}}''; rootPath = ./data/templates/nvim; };
  polybar = { config = builtins.fromJSON ''{"default":{"extension":".ini","output":"colors"}}''; rootPath = ./data/templates/polybar; };
  prism = { config = builtins.fromJSON ''{"dark":{},"default":{"extension":".css","output":"themes"},"light":{}}''; rootPath = ./data/templates/prism; };
  prompt-toolkit = { config = builtins.fromJSON ''{"default":{"extension":".py","output":"base16"}}''; rootPath = ./data/templates/prompt-toolkit; };
  putty = { config = builtins.fromJSON ''{"default":{"extension":".reg","output":"putty"}}''; rootPath = ./data/templates/putty; };
  pygments = { config = builtins.fromJSON ''{"default":{"extension":".py","output":"pygments_base16"}}''; rootPath = ./data/templates/pygments; };
  pywal = { config = builtins.fromJSON ''{"default":{"extension":".json","output":"build_schemes"}}''; rootPath = ./data/templates/pywal; };
  qownnotes = { config = builtins.fromJSON ''{"default":{"extension":".ini","output":"theme"}}''; rootPath = ./data/templates/qownnotes; };
  qtcreator = { config = builtins.fromJSON ''{"default":{"extension":".xml","output":"styles"}}''; rootPath = ./data/templates/qtcreator; };
  qutebrowser = { config = builtins.fromJSON ''{"default":{"extension":".config.py","output":"themes/default"},"minimal":{"extension":".config.py","output":"themes/minimal"}}''; rootPath = ./data/templates/qutebrowser; };
  rofi = { config = builtins.fromJSON ''{"colors":{"extension":".rasi","output":"colors"},"default":{"extension":".rasi","output":"themes"},"old":{"extension":".config","output":"themes"}}''; rootPath = ./data/templates/rofi; };
  scide = { config = builtins.fromJSON ''{"default":{"extension":".yaml","output":"themes"}}''; rootPath = ./data/templates/scide; };
  shell = { config = builtins.fromJSON ''{"default":{"extension":".sh","output":"scripts"}}''; rootPath = ./data/templates/shell; };
  spotify = { config = builtins.fromJSON ''{"default":{"extension":".ini","output":"colors"}}''; rootPath = ./data/templates/spotify; };
  st = { config = builtins.fromJSON ''{"default":{"extension":".diff","output":"diffs"}}''; rootPath = ./data/templates/st; };
  stumpwm = { config = builtins.fromJSON ''{"default":{"extension":".lisp","output":"build"}}''; rootPath = ./data/templates/stumpwm; };
  styles = { config = builtins.fromJSON ''{"css":{"extension":".css","output":"css"},"css-variables":{"extension":".css","output":"css-variables"},"less":{"extension":".less","output":"less"},"sass":{"extension":".sass","output":"sass"},"scss":{"extension":".scss","output":"scss"},"stylus":{"extension":".styl","output":"stylus"}}''; rootPath = ./data/templates/styles; };
  sway = { config = builtins.fromJSON ''{"colors":{"extension":".config","output":"themes"}}''; rootPath = ./data/templates/sway; };
  terminator = { config = builtins.fromJSON ''{"default":{"extension":".config","output":"themes"}}''; rootPath = ./data/templates/terminator; };
  termite = { config = builtins.fromJSON ''{"default":{"extension":".config","output":"themes"}}''; rootPath = ./data/templates/termite; };
  termux = { config = builtins.fromJSON ''{"default":{"extension":".properties","output":"colors"},"default-256":{"extension":"-256.properties","output":"colors"}}''; rootPath = ./data/templates/termux; };
  textadept = { config = builtins.fromJSON ''{"default":{"extension":".lua","output":"themes"}}''; rootPath = ./data/templates/textadept; };
  textmate = { config = builtins.fromJSON ''{"default":{"extension":".tmTheme","output":"Themes"}}''; rootPath = ./data/templates/textmate; };
  tilix = { config = builtins.fromJSON ''{"default":{"extension":".json","output":"tilix"}}''; rootPath = ./data/templates/tilix; };
  tmux = { config = builtins.fromJSON ''{"default":{"extension":".conf","output":"colors"}}''; rootPath = ./data/templates/tmux; };
  tty = { config = builtins.fromJSON ''{"default":{"extension":"","output":"themes"}}''; rootPath = ./data/templates/tty; };
  vim = { config = builtins.fromJSON ''{"default":{"extension":".vim","output":"colors"}}''; rootPath = ./data/templates/vim; };
  vim-airline-themes = { config = builtins.fromJSON ''{"default":{"extension":".vim","output":"autoload/airline/themes"}}''; rootPath = ./data/templates/vim-airline-themes; };
  vimiv = { config = builtins.fromJSON ''{"default":{"extension":null,"output":"build"}}''; rootPath = ./data/templates/vimiv; };
  vis = { config = builtins.fromJSON ''{"default":{"extension":".lua","output":"themes"}}''; rootPath = ./data/templates/vis; };
  vscode = { config = builtins.fromJSON ''{"default":{"extension":".json","output":"themes"}}''; rootPath = ./data/templates/vscode; };
  waybar = { config = builtins.fromJSON ''{"default":{"extension":".css","output":"colors"}}''; rootPath = ./data/templates/waybar; };
  wezterm = { config = builtins.fromJSON ''{"default":{"extension":".toml","output":"themes"}}''; rootPath = ./data/templates/wezterm; };
  windows-command-prompt = { config = builtins.fromJSON ''{"default":{"extension":".reg","output":"windows-command-prompt"}}''; rootPath = ./data/templates/windows-command-prompt; };
  windows-terminal = { config = builtins.fromJSON ''{"default":{"extension":".json","output":"colors"},"default-256":{"extension":".json","output":"colors-256"}}''; rootPath = ./data/templates/windows-terminal; };
  wmaker = { config = builtins.fromJSON ''{"default":{"extension":".style","output":"colors"}}''; rootPath = ./data/templates/wmaker; };
  wofi = { config = builtins.fromJSON ''{"default":{"extension":".css","output":"themes"}}''; rootPath = ./data/templates/wofi; };
  xcode = { config = builtins.fromJSON ''{"default":{"extension":".xccolortheme","output":"Themes"}}''; rootPath = ./data/templates/xcode; };
  xfce4-terminal = { config = builtins.fromJSON ''{"default":{"extension":".theme","output":"colorschemes"},"default.16":{"extension":".16.theme","output":"colorschemes"}}''; rootPath = ./data/templates/xfce4-terminal; };
  xresources = { config = builtins.fromJSON ''{"default":{"extension":".Xresources","output":"xresources"},"default-256":{"extension":"-256.Xresources","output":"xresources"}}''; rootPath = ./data/templates/xresources; };
  xshell = { config = builtins.fromJSON ''{"default":{"extension":".xcs","output":"schemes"}}''; rootPath = ./data/templates/xshell; };
  zathura = { config = builtins.fromJSON ''{"default":{"extension":".config","output":"colors"},"recolor":{"extension":".config","output":"recolors"}}''; rootPath = ./data/templates/zathura; };
}
