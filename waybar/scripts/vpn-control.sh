#!/bin/bash

VPN_DIR="$HOME/.config/openvpn"
WG_DIR="$HOME/.config/wireguard"

# Aktif VPN bağlantılarını kontrol et (OpenVPN + WireGuard)
get_active_vpns() {
    # OpenVPN
    nmcli -t -f NAME,TYPE con show --active | grep ":vpn" | cut -d: -f1
    # WireGuard
    nmcli -t -f NAME,TYPE con show --active | grep ":wireguard" | cut -d: -f1
}

# Waybar için durum çıktısı
show_status() {
    active_vpns=$(get_active_vpns)
    count=$(echo "$active_vpns" | grep -c . 2>/dev/null || echo 0)

    if [ "$count" -gt 1 ]; then
        echo '{"text": "󰌾 '"$count"'", "tooltip": "VPN: '"$(echo $active_vpns | tr '\n' ', ' | sed 's/, $//')"'", "class": "connected"}'
    elif [ "$count" -eq 1 ]; then
        echo '{"text": "󰌾", "tooltip": "VPN: '"$active_vpns"'", "class": "connected"}'
    else
        echo '{"text": "󰿆", "tooltip": "VPN: Bağlı değil", "class": "disconnected"}'
    fi
}

# VPN'i kapat
disconnect_vpn() {
    # OpenVPN
    active=$(nmcli -t -f NAME,TYPE con show --active | grep ":vpn" | cut -d: -f1)
    for conn in $active; do
        nmcli con down "$conn" 2>/dev/null
        notify-send "VPN" "Bağlantı kesildi: $conn" -i network-vpn-disconnected
    done

    # WireGuard
    active=$(nmcli -t -f NAME,TYPE con show --active | grep ":wireguard" | cut -d: -f1)
    for conn in $active; do
        nmcli con down "$conn" 2>/dev/null
        notify-send "WireGuard" "Bağlantı kesildi: $conn" -i network-vpn-disconnected
    done
}

# VPN'e bağlan
connect_vpn() {
    local profile="$1"

    # Bağlan (mevcut bağlantıları kapatmadan)
    if nmcli con up "$profile" 2>&1; then
        notify-send "VPN" "Bağlandı: $profile" -i network-vpn
    else
        notify-send "VPN Hatası" "Bağlanılamadı: $profile" -i network-error
    fi
}

# .ovpn dosyasını NetworkManager'a import et
import_ovpn() {
    local file="$1"
    local name=$(basename "$file" .ovpn)

    if nmcli con import type openvpn file "$file" 2>/dev/null; then
        notify-send "VPN" "Profil eklendi: $name" -i network-vpn
        echo "$name"
        return 0
    else
        notify-send "VPN Hatası" "Import başarısız: $name" -i network-error
        return 1
    fi
}

# .conf WireGuard dosyasını import et
import_wireguard() {
    local file="$1"
    local name=$(basename "$file" .conf)

    if nmcli con import type wireguard file "$file" 2>/dev/null; then
        notify-send "WireGuard" "Profil eklendi: $name" -i network-vpn
        echo "$name"
        return 0
    else
        notify-send "WireGuard Hatası" "Import başarısız: $name" -i network-error
        return 1
    fi
}

# Rofi menüsünü göster
show_menu() {
    # Mevcut NM VPN profillerini al (OpenVPN)
    ovpn_profiles=$(nmcli -t -f NAME,TYPE con show | grep ":vpn" | cut -d: -f1)

    # Mevcut NM WireGuard profillerini al
    wg_profiles=$(nmcli -t -f NAME,TYPE con show | grep ":wireguard" | cut -d: -f1)

    # Aktif bağlantıları al
    active_vpns=$(get_active_vpns)

    # Import edilmemiş .ovpn dosyalarını bul
    ovpn_imports=""
    if [ -d "$VPN_DIR" ]; then
        for f in "$VPN_DIR"/*.ovpn; do
            [ -f "$f" ] || continue
            name=$(basename "$f" .ovpn)
            if ! echo "$ovpn_profiles" | grep -q "^$name$"; then
                ovpn_imports="$ovpn_imports  [Import] $name.ovpn\n"
            fi
        done
    fi

    # Import edilmemiş .conf (WireGuard) dosyalarını bul
    wg_imports=""
    if [ -d "$WG_DIR" ]; then
        for f in "$WG_DIR"/*.conf; do
            [ -f "$f" ] || continue
            name=$(basename "$f" .conf)
            if ! echo "$wg_profiles" | grep -q "^$name$"; then
                wg_imports="$wg_imports  [Import] $name.conf\n"
            fi
        done
    fi

    # Menü oluştur
    menu=""

    # Aktif bağlantılar varsa her biri için kapatma seçeneği
    if [ -n "$active_vpns" ]; then
        menu="󰿆  Tümünü Kapat\n"
        while IFS= read -r vpn; do
            [ -z "$vpn" ] && continue
            menu="$menu  Kapat: $vpn\n"
        done <<< "$active_vpns"
        menu="$menu───────────────────\n"
    fi

    # OpenVPN profilleri
    if [ -n "$ovpn_profiles" ]; then
        menu="$menu OpenVPN\n"
        while IFS= read -r profile; do
            [ -z "$profile" ] && continue
            if echo "$active_vpns" | grep -q "^$profile$"; then
                menu="$menu󰌾  $profile (Bağlı)\n"
            else
                menu="$menu󰌿  $profile\n"
            fi
        done <<< "$ovpn_profiles"
    fi

    # WireGuard profilleri
    if [ -n "$wg_profiles" ]; then
        menu="$menu󰖂 WireGuard\n"
        while IFS= read -r profile; do
            [ -z "$profile" ] && continue
            if echo "$active_vpns" | grep -q "^$profile$"; then
                menu="$menu󰖂  $profile (Bağlı)\n"
            else
                menu="$menu󱘖  $profile\n"
            fi
        done <<< "$wg_profiles"
    fi

    # Import seçenekleri
    if [ -n "$ovpn_imports" ] || [ -n "$wg_imports" ]; then
        menu="$menu───────────────────\n"
        menu="$menu Import Edilebilir\n"
        menu="$menu$ovpn_imports$wg_imports"
    fi

    # Rofi ile seçim yap
    choice=$(echo -e "$menu" | sed '/^$/d' | rofi -dmenu -p "󰌾 VPN" -i -selected-row 0)

    [ -z "$choice" ] && exit 0

    # Ayraçları ve başlıkları atla
    case "$choice" in
        *"─"*|*"OpenVPN"*|*"WireGuard"*|*"Import Edilebilir"*)
            exit 0
            ;;
    esac

    case "$choice" in
        *"Tümünü Kapat"*)
            disconnect_vpn
            ;;
        *"Kapat:"*)
            profile=$(echo "$choice" | sed 's/.*Kapat: //')
            nmcli con down "$profile" 2>/dev/null
            notify-send "VPN" "Bağlantı kesildi: $profile" -i network-vpn-disconnected
            ;;
        *"(Bağlı)"*)
            # Zaten bağlı, bir şey yapma
            ;;
        *"[Import]"*".ovpn"*)
            name=$(echo "$choice" | sed 's/.*\[Import\] //' | sed 's/\.ovpn$//')
            if imported=$(import_ovpn "$VPN_DIR/$name.ovpn"); then
                sleep 1
                connect_vpn "$imported"
            fi
            ;;
        *"[Import]"*".conf"*)
            name=$(echo "$choice" | sed 's/.*\[Import\] //' | sed 's/\.conf$//')
            if imported=$(import_wireguard "$WG_DIR/$name.conf"); then
                sleep 1
                connect_vpn "$imported"
            fi
            ;;
        *)
            # Profil adını çıkar ve bağlan
            profile=$(echo "$choice" | sed 's/^[󰌿󰌾󰖂󱘖 ]*//' | sed 's/ *$//')
            connect_vpn "$profile"
            ;;
    esac

    # Waybar'ı güncelle
    pkill -SIGRTMIN+10 waybar
}

# Ana mantık
case "$1" in
    --menu)
        show_menu
        ;;
    --disconnect)
        disconnect_vpn
        ;;
    --connect)
        connect_vpn "$2"
        ;;
    *)
        show_status
        ;;
esac
