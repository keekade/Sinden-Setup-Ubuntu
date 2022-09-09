# Sinden-Setup-Ubuntu
A simple script to setup a Sinden lightgun and its dependencies on Ubuntu

At this stage it does nothing other than install the basic requirements and ensure they work while also dealing with a bug I'm encountering in Ubuntu

## Installing Ubuntu

I have only tested this on a copy of 64bit Ubuntu 20.04 but it should work with any flavour.

## Installing Sinden

Once Ubuntu is installed you need to download git and clone this repository before executing install_sinden.sh

```
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/keekade/Sinden-Setup-Ubuntu
sudo ./install_sinden.sh
```

On completition of the script it will let you know if the sinden software is functioning correctly.