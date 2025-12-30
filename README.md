# dotfiles

Arch Linux icin kisisel yapilandirma dosyalarim.

## Icerik

### Pencere Yoneticileri
- **i3** - X11 tiling window manager
- **Hyprland** - Wayland compositor (hyprlock, hypridle, hyprpaper dahil)

### Terminal Emulatorleri
- **Alacritty**
- **Kitty**

### Bar/Panel
- **Polybar** - X11 icin (blocks, colorblocks, cuts, docky, forest, grayblocks, hack, material, panels, pwidgets, shades, shapes temalari)
- **Waybar** - Wayland icin

### Diger
- **Neovim** - Metin editoru yapilandirmasi
- **Compton** - X11 compositor
- **Mako** - Bildirim daemon'u (Wayland)
- **Wofi** - Uygulama baslatinici (Wayland)
- **Swaylock** - Ekran kilidi

### Shell
- `.bashrc`
- `.bash_profile`

## Kurulum

```bash
./install.sh
```

Bu betik:
1. Gerekli dizinleri olusturur (Downloads, Workspace, Pictures)
2. Gerekli paketleri pacman ile kurar
3. Yapilandirma dosyalarini `~/.config/` altina kopyalar

**Not:** Betigi root olarak calistirmayin.

## Kurulum Sonrasi Oneriler
- Yay (AUR helper) kur
- Bluetooth'u etkinlestir

## Waybar

Waybar profili bana ait degil.