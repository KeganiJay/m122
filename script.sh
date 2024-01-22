#!/bin/bash
# Farbe für die Fehlermeldungen
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Willkommen! Bitte akzeptieren Sie die Datenschutzvereinbarung.${NC}"
read -p "1 für Zustimmen, 2 für Ablehnen: " choice

if [ "$choice" != "1" ]; then
    echo "Datenschutzvereinbarung abgelehnt. Das Skript wird beendet."
    exit 1
fi

while true; do
    clear
    echo -e "${GREEN}Optionen:${NC}"
    echo "1- OS Update überprüfen und installieren"
    echo "2- Sicherheit überprüfen (UFW Regeln)"
    echo "3- Netzwerkstatus überprüfen"
    echo "4- Benutzer und Berechtigungen überprüfen"
    echo "q- Skript beenden"
    
    read -p "Wählen Sie eine Option: " option
    
    case "$option" in
        1)
            sudo apt update
            sudo apt upgrade -y
            sudo apt autoremove -y
            sudo apt autoclean
            echo "Automatische Updates nach jedem Neustart wurden eingerichtet."
            echo "@reboot root apt update && apt upgrade -y" | sudo tee -a /etc/crontab > /dev/null
            ;;
        2)
            sudo ufw status
            read -p "Geben Sie die Regelnummer ein, die gelöscht werden soll (0 für nichts): " rule_number
            if [ "$rule_number" -gt 0 ]; then
                sudo ufw delete $rule_number
            fi
            ;;
        3)
            echo -e "${GREEN}Netzwerkkonfiguration:${NC}"
            sudo apt install net-tools
            ifconfig
            if ping -c 4 8.8.8.8 &> /dev/null; then
                echo -e "${GREEN}Erfolgreich: Verbindung zu 8.8.8.8 hergestellt.${NC}"
            else
                echo -e "${GREEN}Fehler: Konnte 8.8.8.8 nicht erreichen. Überprüfen Sie die Netzwerkkonfiguration.${NC}"
                echo -e "${GREEN}Überprüfe Netzwerkkonfiguration...${NC}"
                sleep 2
                echo -e "${GREEN}Überprüfe /etc/resolv.conf...${NC}"
                sleep 2
                cat /etc/resolv.conf
                echo -e "${GREEN}Überprüfe Netzwerkadapter-Status...${NC}"
                sleep 2
                ip link
            fi
            ;;
        4)
            echo -e "${GREEN}Anzahl der Benutzer auf dem Server:${NC}"
            cat /etc/passwd | wc -l
            read -p "Geben Sie den Benutzernamen ein, dessen Passwort geändert oder der gelöscht werden soll: " username
            if [ -n "$username" ]; then
                echo -e "${GREEN}Optionen:${NC}"
                echo "1- Passwort ändern"
                echo "2- Benutzer löschen"
                read -p "Wählen Sie eine Option: " user_option
                
                case "$user_option" in
                    1)
                        sudo passwd $username
                        ;;
                    2)
                        sudo userdel -r $username
                        ;;
                    *)
                        echo "Ungültige Option."
                        ;;
                esac
            fi
            ;;
        q)
            echo -e "${GREEN}Skript wird beendet.${NC}"
            exit 0
            ;;
        *)
            echo "Ungültige Option."
            ;;
    esac
    
    read -p "Drücken Sie Enter, um fortzufahren."
done
