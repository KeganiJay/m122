#!/bin/bash
# Farbe für die Fehlermeldungen
GREEN='\033[0;32m'
NC='\033[0m' # No Color
# slash dreht um das Skript gut aussehen zu lassen
rotateCursor() {
s="-,\\,|,/"
    for i in `seq 1 $1`; do
        for i in ${s//,/ }; do
            echo -n $i
            sleep 0.1
            echo -ne '\b'
        done
    done
}

# Single loop, kann man ohne Zahl eingeben
rotateCursor

# mehrere loops
rotateCursor 10

# Datenschutz anehmen
echo -e "${GREEN}Willkommen! Bitte akzeptieren Sie die Datenschutzvereinbarung.${NC}"
read -p "1 für Zustimmen, 2 für Ablehnen: " choice

# Wenn der Benutzer 2 wählt, wird das Skript beendet
if [ "$choice" != "1" ]; then
    echo "Datenschutzvereinbarung abgelehnt. Das Skript wird beendet."
    exit 1
fi
# While true schleife um mehrere Optionen darzustellen
while true; do
    clear
    echo -e "${GREEN}Optionen:${NC}"
    echo "1- OS Update überprüfen und installieren"
    echo "2- Sicherheit überprüfen (UFW Regeln)"
    echo "3- Netzwerkstatus überprüfen"
    echo "4- Benutzer und Berechtigungen überprüfen"
    echo "5- calm av antivirus installieren"
    echo "q- Skript beenden"
    
    read -p "Wählen Sie eine Option: " option
    # Optionen von 1 bis 5 mit Befehle aufgelistet
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
sudo ufw enable            
sudo ufw status
            read -p "Geben Sie die Regelnummer ein, die gelöscht werden soll (0 für nichts): " rule_number
            if [ "$rule_number" -gt 0 ]; then
                sudo ufw delete $rule_number
            fi
            ;;
        3)
            echo -e "${GREEN}Netzwerkkonfiguration:${NC}"
#installiert ein networking toolkit
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
            
         5)
            
            echo " ok, clamav wird auf diesem system installiert."
            
 
#installiert einen open-source antivirus
           apt -y install clamav
           apt install -y clamav-daemon
           systemctl status clamav-freshclam
           systemctl start clamav-freshclam
           reset
           
       echo " perfect, alles ist erfolgreich installiert."    
           
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
