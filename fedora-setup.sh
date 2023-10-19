#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
HEIGHT=20
WIDTH=90
CHOICE_HEIGHT=4
BACKTITLE="Fedora Setup Util - By Smittix, Revised for personal use by Xirxes"
TITLE="Please Make a selection"
MENU="Please Choose one of the following options:"

#Other variables
OH_MY_ZSH_URL="https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

#Check to see if Dialog is installed, if not install it - Thanks Kinkz_nl
if [ $(rpm -q dialog 2>/dev/null | grep -c "is not installed") -eq 1 ]; then
sudo dnf install -y dialog
fi

OPTIONS=(1 "Enable RPM Fusion - Enables the RPM Fusion repos for your specific version"
         2 "Update Firmware - If your system supports FW update delivery"
         3 "Speed up DNF - Sets max parallel downloads to 10"
         4 "Enable Flatpak - Enables the Flatpak repo and installs packages located in flatpak-packages.txt"
         5 "Install Software - Installs software located in dnf-packages.txt"
         6 "Install Oh-My-ZSH - Installs Oh-My-ZSH along with Starship prompt"
         7 "Install Github Desktop"
         8 "Install Nvidia - Install akmod Nvidia drivers"
         9 "Install Tailscale & VSCode"
         10 "Configure Git"
         11 "Apply my preferred changes - Options 1 2 3 4 5 6 9 10"
         12 "Log in to Tailscale"
         13 "Log in to gh"
	     14 "Quit")

while [ "$CHOICE -ne 4" ]; do
    CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --nocancel \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

    clear
    case $CHOICE in
        1)  echo "Enabling RPM Fusion"
            sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	        sudo dnf upgrade --refresh
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
            notify-send "RPM Fusion Enabled" --expire-time=10
           ;;
        2)  echo "Updating System Firmware"
            sudo fwupdmgr get-devices 
            sudo fwupdmgr refresh --force 
            sudo fwupdmgr get-updates 
            sudo fwupdmgr update
           ;;
        3)  echo "Speeding Up DNF"
            echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
            notify-send "Your DNF config has now been amended" --expire-time=10
           ;;
        4)  echo "Enabling Flatpak"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak update
            source flatpak-install.sh
            notify-send "Flatpak has now been enabled" --expire-time=10
           ;;
        5)  echo "Installing Software"
            sudo dnf install -y $(cat dnf-packages.txt)
            # Github Desktop
            sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
            sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/yum.repos.d/shiftkey-packages.repo'
            sudo dnf update
            sudo dnf install -y github-desktop
            notify-send "Software has been installed" --expire-time=10
           ;;
        6)  echo "Installing Oh-My-Zsh with Starship"
            sudo dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"
            echo "change shell to ZSH"
            chsh -s "$(which zsh)"
            notify-send "Oh-My-Zsh is ready to rock n roll" --expire-time=10
            curl -sS https://starship.rs/install.sh | sh
            echo "eval "$(starship init zsh)"" >> ~/.zshrc
            notify-send "Starship Prompt Activated" --expire-time=10
           ;;
        7)  echo "Installing Github Desktop"
            sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
            sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/yum.repos.d/shiftkey-packages.repo'
            sudo dnf update
            sudo dnf install -y github-desktop
            notify-send "All done" --expire-time=10
           ;;
        8)  echo "Installing Nvidia Driver Akmod-Nvidia"
            sudo dnf install -y akmod-nvidia
            notify-send "Please wait 5 minutes until rebooting" --expire-time=10
	       ;;
        9)  echo "Installing Tailscale"
            sudo dnf config-manager --add-repo -y https://pkgs.tailscale.com/stable/fedora/tailscale.repo
            sudo dnf install -y tailscale
            sudo systemctl enable --now tailscaled
            echo "Installing VSCode"
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            dnf check-update
            sudo dnf install -y code
           ;;
        10) echo "Configuring Git"
            sudo dnf install git
            git config --global user.name "Luke Wells"
            git config --global user.email "wellsluke88@gmail.com"
           ;;
        11) echo "My preferred changes - Options 1 2 3 4 5 6 9 10"
            echo "Enabling RPM Fusion"
            sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	        sudo dnf upgrade --refresh
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
            echo "Updating System Firmware"
            sudo fwupdmgr get-devices 
            sudo fwupdmgr refresh --force 
            sudo fwupdmgr get-updates 
            sudo fwupdmgr update
            echo "Speeding Up DNF"
            echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
            echo "Enabling Flatpak"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak update
            source flatpak-install.sh
            echo "Installing Software"
            sudo dnf install -y $(cat dnf-packages.txt)
            sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
            sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/yum.repos.d/shiftkey-packages.repo'
            sudo dnf update
            sudo dnf install -y github-desktop
            echo "Installing Oh-My-Zsh with Starship"
            sudo dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"
            echo "change shell to ZSH"
            chsh -s "$(which zsh)"
            curl -sS https://starship.rs/install.sh | sh
            echo "eval "$(starship init zsh)"" >> ~/.zshrc
            echo "Installing Tailscale"
            sudo dnf config-manager --add-repo -y https://pkgs.tailscale.com/stable/fedora/tailscale.repo
            sudo dnf install -y tailscale
            sudo systemctl enable --now tailscaled
            echo "Installing VSCode"
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            dnf check-update
            sudo dnf install -y code
            echo "Configuring Git"
            sudo dnf install git
            git config --global user.name "Luke Wells"
            git config --global user.email "wellsluke88@gmail.com"
           ;;
        12) echo "Logging in to tailscale"
            sudo tailscale up -qr --accept-routes
           ;;
        13) echo "Logging in to gh"
            gh auth login
           ;;
        14)
          exit 0
          ;;
    esac
done
