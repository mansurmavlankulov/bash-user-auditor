#!/bin/bash

# ============================================
# Linux User Auditor
# Author: theshadow (Mansur)
# Description: Tizimdagi userlarni audit qiladi
# ============================================

# O'zgaruvchilar (Variables)
REPORT_FILE="audit_report.txt"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# ============================================
# Root tekshiruvi
# ============================================
if [ "$EUID" -ne 0 ]; then
    echo "[!] Xato: Bu script root huquqi bilan ishga tushirilishi kerak."
    echo "[!] Qaytadan urinib ko'ring: sudo $0"
    exit 1
fi

# ============================================
# Funksiya: Oddiy userlarni topish (UID >= 1000)
# ============================================
get_normal_users() {
    echo "[*] Oddiy userlar (UID >= 1000):"
    echo "----------------------------------------"
    awk -F":" '$3 >= 1000 && $3 < 65534 {printf "  Username: %-20s UID: %s\n", $1, $3}' /etc/passwd
    echo ""
}


# ============================================
# Funksiya: Sudo huquqiga ega userlarni topish
# ============================================
get_sudo_users() {
    echo "[*] Sudo huquqiga ega userlar:"
    echo "----------------------------------------"
# ============================================
# Funksiya: Bo'sh parolli userlarni tekshirish
# ============================================
check_empty_passwords() {
    echo "[*] Bo'sh parolli userlar (XAVF!):"
    echo "----------------------------------------"
    
    empty_pass_users=$(awk -F":" '$2 == "" {print $1}' /etc/shadow)
    
    if [ -z "$empty_pass_users" ]; then
        echo "  [+] Bo'sh parolli user topilmadi. Tizim xavfsiz."
    else
        echo "$empty_pass_users" | while read user; do
            printf "  [!] Username: %-20s [PAROL YO'Q]\n" "$user"
        done
    fi
    echo ""
}
    
    sudo_members=$(grep "^sudo:" /etc/group | cut -d ":" -f 4)
    
    if [ -z "$sudo_members" ]; then
        echo "  [!] Sudo guruhida hech kim yo'q"
    else
        echo "$sudo_members" | tr ',' '\n' | while read user; do
            printf "  Username: %-20s [sudo group]\n" "$user"
        done
    fi
    echo ""
}

# ============================================
# Asosiy qism — hisobot yaratish va chiqarish
# ============================================

# Hisobot sarlavhasi (fayl qaytadan yaratiladi)
{
    echo "=========================================="
    echo "  LINUX USER AUDIT REPORT"
    echo "  Generated: $DATE"
    echo "  Hostname: $(hostname)"
    echo "=========================================="
    echo ""
} | tee "$REPORT_FILE"

# Audit funksiyalarini chaqirish (faylga qo'shiladi)
{
    get_normal_users
    get_sudo_users
    check_empty_passwords
} | tee -a "$REPORT_FILE"

echo "[+] Hisobot saqlandi: $REPORT_FILE"

