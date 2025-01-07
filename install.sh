#!/bin/bash

PURPLE='\033[0;35m'
NC='\033[0m' # скидання кольору

purple_echo() {
  echo -e "${PURPLE}$*${NC}"
}

# ==========================================
# Відображення логотипу
# ==========================================
purple_echo "Відображення логотипу..."

curl -s https://raw.githubusercontent.com/abzalliance/logo/main/logo.sh -o logo.sh

if [ -f logo.sh ]; then
    chmod +x logo.sh
    # Запускаємо logo.sh
    bash logo.sh
    # Пауза в 5 секунд
    sleep 5
    rm logo.sh
else
    purple_echo "Не вдалося завантажити логотип."
fi
set -e

# Пакет unzip та screen можуть бути не встановлені
sudo apt update
sudo apt install -y unzip screen

echo "=================================================="
echo "1. Встановлення Snap (якщо не встановлений)"
echo "=================================================="
sudo apt install -y snapd

echo "=================================================="
echo "2. Увімкнення Snap"
echo "=================================================="
sudo systemctl enable --now snapd.socket

echo "=================================================="
echo "3. Встановлення Multipass"
echo "=================================================="
sudo snap install multipass

echo "=================================================="
echo "4. Завантаження інсталяційного пакету"
echo "=================================================="
wget https://pcdn.titannet.io/test4/bin/agent-linux.zip

echo "=================================================="
echo "5. Створення теки /opt/titanagent"
echo "=================================================="
mkdir -p /opt/titanagent

echo "=================================================="
echo "6. Розпакування агенту в /opt/titanagent"
echo "=================================================="
unzip agent-linux.zip -d /opt/titanagent

echo "=================================================="
echo "7. Створення screen-сесії з назвою 'titan'"
echo "   і запуск агента у фоновому режимі"
echo "=================================================="
# Запустимо порожню сесію screen у фоні
screen -dmS titan

# Усередині сесії виконаємо послідовно команди:
# - перехід у директорію
# - запуск агента з потрібними параметрами
# ВАЖЛИВО: тут замість <your-key> впишіть ваш ключ
screen -S titan -p 0 -X stuff "cd /opt/titanagent && ./agent --working-dir=/opt/titanagent --server-url=https://test4-api.titannet.io --key=<your-key>\n"

echo "=================================================="
echo "8. Агент запущено у screen-сесії 'titan'"
echo "   Щоб приєднатися, введіть:  screen -r titan"
echo "   Скопіюйте свій Node ID і потім натисніть CTRL + A, D"
echo "=================================================="
