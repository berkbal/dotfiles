#!/bin/bash

CITY="Ankara"

# Hava durumu verisi al
weather=$(curl -sf "wttr.in/${CITY}?format=%c%t" 2>/dev/null | tr -d '+')

if [ -z "$weather" ]; then
    echo '{"text": "󰼯", "tooltip": "Hava durumu alınamadı"}'
    exit 0
fi

# Detaylı bilgi için
details=$(curl -sf "wttr.in/${CITY}?format=%C+%t+feels+like+%f+humidity+%h+wind+%w" 2>/dev/null | tr -d '+')

tooltip="${CITY}: ${details}"

# JSON çıktı - basit format
printf '{"text": "%s", "tooltip": "%s"}\n' "$weather" "$tooltip"
