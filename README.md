# fitness-tracker
Doing things with fitness tracking data files.

# Usefull information
- [This Post from Alan Bundury](https://towardsdatascience.com/parsing-fitness-tracker-data-with-python-a59e7dc17418)

## Garmin Forerunner 255
- Garmin Forerunner uses MTP to connect to PC via USB.

- Install a FUSE based file system for MTP devices, like
  [jmtpfs](https://github.com/JasonFerrara/jmtpfs):
  ```bash
  sudo apt update
  sudo apt install jmtpfs
  ```
- Edit `/etc/fuse.conf` to allow other users to read and write to MTP devices:
  ```bash
  sudo sed -i '/user_allow_other/s/^#//g' /etc/fuse.conf
  ```
- Mount device:
  ```bash
  mkdir -p $HOME/GARMIN-FR255
  jmtpfs $HOME/GARMIN-FR255
  ```
- Remove device:
  ```bash
  jmtpfs -o hard_remove $HOME/GARMIN-FR255
  ```
  - or remove from file manager
