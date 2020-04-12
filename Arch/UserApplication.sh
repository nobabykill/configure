#!/bin/bash

## detect laptop or pc
read -p 'this device is pc or laptop (1:pc, 2:laptop) ? ' device_type

## install xorg
sudo pacman -S --noconfirm xorg xorg-xinit git
echo 'exec i3' >> ~/.xinitrc

## install i3 and i3status
sudo pacman -S --noconfirm i3-gaps i3blocks
mkdir -p ~/.config/i3
mkdir ~/.config/i3blocks
cp ~/configure/Arch/config_file/i3 ~/.config/i3/config
cp ~/configure/Arch/config_file/i3blocks ~/.config/i3blocks/config

## install urxvt
sudo pacman -S --noconfirm rxvt-unicode
cp ~/configure/Arch/config_file/Xresources ~/.Xresources

## install gvim
sudo pacman -S --noconfirm gvim
cp ~/configure/Arch/config_file/vimrc ~/.vimrc

## install zsh
sudo pacman -S --noconfirm zsh zsh-completions dash
cp ~/configure/Arch/config_file/zshrc ~/.zshrc # copy config 

## audio
sudo pacman -S --noconfirm alsa-utils pulseaudio-alsa pamixer

## screenshot
sudo pacman -S --noconfirm xclip scrot

## install dmenu
sudo pacman -S --noconfirm dmenu

## file management
sudo pacman -S --noconfirm nautilus

## fcitx
sudo pacman -S --noconfirm fcitx fcitx-im fcitx-unikey fcitx-configtool fcitx-mozc
cp ~/configure/Arch/config_file/pam_environment ~/.pam_environment

## yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd -
rm -rf yay

## compton
yay -S --noconfirm compton-tryone-git feh
cp ~/configure/Arch/config_file/compton ~/.config/compton.conf

## wallpaper
mkdir ~/Pictures
cp -R ~/configure/Arch/wallpaper ~/Pictures/

## font
sudo pacman -S --noconfirm ttf-dejavu ttf-liberation noto-fonts ttf-font-awesome noto-fonts-emoji otf-ipafont ttf-hanazono

## kvm
sudo pacman -S --noconfirm virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat ovmf
sudo bash -c 'echo nvram = [\"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd\"] >> /etc/libvirt/qemu.conf'
sudo cp ~/configure/Arch/config_file/50-libvirt.rules /etc/polkit-1/rules.d/50-libvirt.rules
sudo usermod -aG kvm linh
sudo systemctl enable libvirtd

## auto start
cp ~/configure/Arch/config_file/zprofile ~/.zprofile

## change default shell for user
sudo usermod -s /bin/zsh $USER 

## time zone
sudo timedatectl set-timezone Asia/Ho_Chi_Minh
sudo timedatectl set-local-rtc 1 --adjust-system-clock

## git
git config --global core.editor vim
git config --global credential.helper store
git config --global user.email "linh1612340@gmail.com"
git config --global user.name "nobabykill" 

## lightdm
sudo pacman -S --noconfirm lightdm lightdm-webkit2-greeter 
sudo systemctl enable lightdm
sudo sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf

## utilize multi threads compress
sudo sed -i -e "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -z - --threads=`grep -c ^processor /proc/cpuinfo`)/g" /etc/makepkg.conf 

## enable android caple connection file transfer
sudo pacman -S --noconfirm gvfs-mtp mtpfs

## check if device is laptop
if [ $device_type -eq 2 ] 
then
    ## brightness
    sudo pacman -S --noconfirm xorg-xbacklight xf86-video-intel
    sudo cp ~/configure/Arch/config_file/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf

    ## touchpad
    sudo pacman -S --noconfirm xf86-input-libinput
    sudo cp ~/configure/Arch/config_file/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
fi
