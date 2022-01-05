#! /bin/bash

# fedora-post-install-script
# Copyright (C) 2021 davidhoang05022009(Hoàng Minh Thiên)
# This program comes with ABSOLUTELY NO WARRANTY
# This is free software, and you are welcome to redistribute it
# under certain conditions

# Licensed under GPLv3 License

HEIGHT=20
WIDTH=90
CHOICE_HEIGHT=4
BACKTITLE="Fedora post-install script by davidhoang05022009(Hoàng Minh Thiên)"
MENU_MSG="Please select one of following options:"

# URLs variables
CASCADIA_CODE_URL="https://github.com/microsoft/cascadia-code/releases/download/v2110.31/CascadiaCode-2110.31.zip"
DRACULA_THEME_URL="https://github.com/dracula/gtk/archive/master.zip"

# Install some tools required by the script
sudo dnf install axel deltarpm -y

# First, optimize the dnf package manager
sudo cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak
sudo cp ./dnf.conf /etc/dnf/dnf.conf
sudo dnf update -y

# Check if we have dialog installed
# If not, install it
if [ "$(rpm -q dialog 2>/dev/null | grep -c "is not installed")" -eq 1 ]; 
then
    sudo dnf install -y dialog
fi

OPTIONS=(
    1  "Install tools - Read more in README.md"
    2  "Enable RPM Fusion"
    3  "Enable Flathub"
    4  "Install media codecs - Read more in README.md"
    5  "Disable quiet boot screen"
    6  "Optimize booting time for Intel CPUs" # This is from Clear Linux, my friends found out this and suggested me
    7  "Install Google Noto Sans fonts, Microsoft Cascadia Code Fonts"
    8  "Install Powerline"
    9  "Install Dracula theme"
    10 "Recover maximize, minimize button"
    11 "Install ibus-bamboo(\"Bộ gõ tiếng Việt\" for Vietnamese users)"
    12 "Enable dnf-automatic(Automatic updates)"
    13 "Reboot"
    14 "Quit"
)


while true; do
    CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE $(lscpu | grep -i "Model name:" | cut -d':' -f2- - | grep Intel)" \
                --title "$TITLE" \
                --nocancel \
                --menu "$MENU_MSG" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
    clear
    case $CHOICE in 
        1) echo "Installing Tools"
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
		sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf update -y
        sudo dnf install htop neofetch xclip gnome-tweaks micro code -y
        notify-send "Installed tools"
        ;;
        
        2) echo "Enabling RPM Fusion"
        sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y
        sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y
        notify-send "Enabled RPM Fusion"
        ;;
        
        3) echo "Enabling Flathub"
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        notify-send "Enabled Flathub"
        ;;

        4) echo "Installing media codecs"
        sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
        sudo dnf install lame\* --exclude=lame-devel -y
        sudo dnf group upgrade --with-optional Multimedia -y
        notify-send "Installed media codecs"
        ;;

        5) echo "Disabling quiet boot screen"
        sudo cp /etc/default/grub /etc/default/grub.bak
        sudo cp ./grub /etc/default/grub
        if [ -f "/sys/firmware/efi" ]; 
        then
            sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
        else
            sudo grub2-mkconfig -o /boot/grub2/grub.cfg
        fi
        sudo plymouth-set-default-theme details
        sudo dracut -f
        notify-send "Disabled quiet boot screen"
        ;;

        6) echo "Checking if your CPU is Intel's CPU or not"
        if [ "$(< /proc/cpuinfo grep "GenuineIntel" | head -1 | cut -d "e" -f 4-)" == "Intel" ]; 
        then 
            echo "Your CPU is Intel's CPU, let's optimize it"
            lscpu | grep -i "Model name"
            sudo cp /etc/default/grub /etc/default/grub.bak
            echo -e "\nGRUB_CMDLINE_LINUX_DEFAULT=\"intel_idle.max_cstate=1 cryptomgr.notests initcall_debug intel_iommu=igfx_off no_timer_check noreplace-smp page_alloc.shuffle=1 rcupdate.rcu_expedited=1 tsc=reliable quiet splash\"" | sudo tee -a /etc/default/grub
            if [ -f "/sys/firmware/efi" ]; 
            then
                sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
            else
                sudo grub2-mkconfig -o /boot/grub2/grub.cfg
            fi
            notify-send "Optimized booting time for your PC/Laptop"
        else
            echo "Your CPU is not Intel's CPU"
        fi
        ;;

        7) echo "Installing Google Noto Sans fonts, Microsoft Cascadia Code fonts and apply it to system fonts"
        sudo dnf install google-noto-sans-fonts -y
        axel -n 20 $CASCADIA_CODE_URL
        unzip ./CascadiaCode-2110.31.zip -d ./CascadiaCode-2110.31
        sudo mv ./CascadiaCode-2110.31/ttf/static/\* /usr/share/fonts
        fc-cache -f -v
        dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
        gsettings set org.gnome.desktop.interface font-name 'Noto Sans Medium 11'
        gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans Regular 11'
        gsettings set org.gnome.desktop.interface monospace-font-name 'Cascadia Code PL 13'
        gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Sans Bold 11'
        notify-send "Installed Google Noto Sans fonts, Microsoft Cascadia Code fonts and applied it to system fonts"
        ;;

        8) echo "Installing Powerline"

        # Check if the Cascadia Code fonts exists for this
        if [ "$(fc-list | grep -c 'Cascadia Code')" -lt 1 ];
        then
            while true; do
                read -rp "Seems like Microsoft Cascadia Code fonts(required by Powerline) are not installed. \nDo you want to install it? [y/n](Select 'n' if you have other Powerline-compatible fonts): " yn
                case $yn in
                    [Yy]*) echo "Installing Microsoft Cascadia Code fonts" 
                    axel -n 20 $CASCADIA_CODE_URL
                    unzip ./CascadiaCode-2110.31.zip -d ./CascadiaCode-2110.31
                    sudo mv ./CascadiaCode-2110.31/ttf/static/\* /usr/share/fonts
                    fc-cache -f -v
                    ;;  
                    [Nn]*) echo "Okie, continuing install Powerline" ;;
                esac
            done
        fi
        cp ~/.bashrc ~/.bashrc.bak
        sudo dnf install powerline -y
        echo -e "if [ -f $(which powerline-daemon) ]; then\npowerline-daemon -q\nPOWERLINE_BASH_CONTINUATION=1\nPOWERLINE_BASH_SELECT=1\n. /usr/share/powerline/bash/powerline.sh\nfi" >> ~/.bashrc
        notify-send "Installed Powerline"
        ;;

        9) echo "Installing Dracula theme"
        axel $DRACULA_THEME_URL -o gtk-master.zip
        unzip ./gtk-master.zip -d /usr/share/themes
        gsettings set org.gnome.desktop.interface gtk-theme 'gtk-master' 
        gsettings set org.gnome.desktop.wm.preferences theme 'gtk-master'
        gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
        notify-send "Installed Dracula theme"
        ;;

        10) echo "Recovering maximize, minimize button"
        gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
        notify-send "Recovered maximiaze, minimize button"
        ;;

        11) echo "Installing ibus-bamboo"
        if [ "$(rpm -E %fedora)" -gt 33 ];
        then
            sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:lamlng/Fedora_33/home:lamlng.repo
        else
            sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:lamlng/Fedora_"$(rpm -E %fedora)"/home:lamlng.repo
        fi
        sudo dnf install ibus-bamboo -y
        gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo::Us')]"
        gsettings set org.gnome.desktop.interface gtk-im-module 'ibus'
        notify-send "Installed ibus-bamboo"
        ;;
        
        12) echo "Enabling dnf-automatic(Automatic updates)"
        sudo dnf install dnf-automatic -y
        sudo cp ./automatic.conf /etc/dnf/automatic.conf
        sudo systemctl enable --now dnf-automatic.timer
        notify-send "Enabled dnf-automatic"
        ;;
        
        13)
        sudo systemctl reboot
        ;;

        14) rm -rf CascadiaCode* gtk-master.zip
        exit 0
        ;;

    esac
done
