<!-- 
fedora-post-install-script
Copyright (C) 2021 Hoàng Minh Thiên
This program comes with ABSOLUTELY NO WARRANTY
This is free software, and you are welcome to redistribute it
under certain conditions

Licensed under GPLv3 License
-->

# fedora-post-install-script

## How to run?

1. Make sure `git`, `dnf` and `python3` are usable

2. Open Terminal, type: 
```sh
git clone https://github.com/davidhoang05022009/fedora-post-install-script
cd ./fedora-post-install-script
``` 

3. Run it: 
```sh 
sudo python3 ./post-install.py

# or with logging:

sudo python3 ./post-install.py | tee -a post-install.log
```

## What does this script do?
1. Speed-up and optimize `dnf`
2. Check update for your system
3. Install some tools, includes: `htop`, `neofetch`, `xclip`, `axel`, `gnome-tweaks`, `deltarpm`, `micro`, `code`(VSCode), `dnf-automatic`
4. Enable RPMFusion, Flathub
5. Install media codecs(from the docs [here](https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/))
6. Disable "quiet" boot screen(make your boot screen look like hacker's screen XD) (make some changes to GRUB config file, don't worry, I tested it and it's fine)
7. Install Google Noto Sans fonts, Microsoft Cascadia Code fonts, Powerline and Dracula theme
8. Install ibus-bamboo for Vietnamese user(available when choosing Vietnamese)

## Found an issue?
Create an issue, re-run the script with logging, then upload the log file, ~/.bashrc, /etc/default/grub and /etc/dnf/dnf.conf

## Special thanks to:
- Google for the [Noto Sans fonts](https://fonts.google.com/noto/specimen/Noto+Sans?query=Noto+Sans) (with OFL License)
- Microsoft and their contributors for the [Cascadia Code fonts](https://github.com/microsoft/cascadia-code) (with OFL License) and [VSCode](https://github.com/Microsoft/vscode) (with MIT License)
- The Dracula team and their contributors for the [Dracula Theme for GTK](https://github.com/dracula/gtk) (with GPLv3 License)
- The [TechHut YouTube channel](https://www.youtube.com/c/TechHutHD) for the video ['5 Things You MUST DO After Installing Fedora 35'](https://www.youtube.com/watch?v=-NwWE9YFFIg)
- The official Fedora Magazine for the guide [how to install Powerline](https://fedoramagazine.org/add-power-terminal-powerline/)
- The official Fedora docs for the guide [how to setup automatic updates](https://docs.fedoraproject.org/en-US/quick-docs/autoupdates/) and [codecs install](https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/)
- The [StackOverflow](https://stackoverflow.com), [AskUbuntu](https://askubuntu.com) community for helping me writing themes, fonts install script
- [ibus-bamboo](https://github.com/BambooEngine/ibus-bamboo) for the Vietnamese input service on Linux(thanks to [OpenBuildService](https://software.opensuse.org//download.html?project=home%3Alamlng&package=ibus-bamboo) for the Fedora ibus-bamboo build)
- [Zachary Yedidia (zyedidia)](https://github.com/zyedidia) and contributors for the [Micro Text Editor](https://github.com/zyedidia/micro)

## License
This repository is licensed under GPLv3 License, see it [here](./LICENSE)</br>
Copyright (C) 2021 Hoàng Minh Thiên</br>
This program comes with ABSOLUTELY NO WARRANTY</br>
This is free software, and you are welcome to redistribute it
under certain conditions