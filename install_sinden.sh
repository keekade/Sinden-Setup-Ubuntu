#!/bin/bash

USER="$SUDO_USER"

function install_dependencies() {
  echo "Updating & Installing Packages..."
  apt-get update
  apt-get -y upgrade
  apt install -y mono-complete v4l-utils libsdl1.2-dev libsdl-image1.2-dev libjpeg-dev
}

function download_sinden_software() {
  if [[ -z "$1" ]]; then
    echo "--------------------------------------------------------------------------------"
    echo "| No Version was provided for the Sinden Software"
    echo "--------------------------------------------------------------------------------"
    echo -e "Skipped\n\n"
    return 1
  fi
  local version=$1
  echo "Downloading Sinden Software Version: ${version}"

  wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 "https://www.sindenlightgun.com/software/SindenLightgunSoftwareReleaseV1.0${version}.zip" -P "/home/${USER}/sinden-setup"
}

function extract_sinden_software() {
  local version=$1

  cd "/home/${USER}/sinden-setup"
  unzip "SindenLightgunSoftwareReleaseV1.0${version}.zip"
}

function copy_lightgun_folder() {
  local version=$1
  local p1_dir="SindenLightgunSoftwareReleaseV1.0${version}/SindenLightgunLinuxSoftwareV1.0${version}/X86/64bit/Lightgun"

  cd "/home/${USER}/sinden-setup"
  cp -R $p1_dir "/home/${USER}"

  echo "Installed SindenLightgunSoftwareReleaseV1.0${version} at /home/${USER}/Lightgun"
}

function copy_camera_lib() {
  local version=$1
  local p1_dir="SindenLightgunSoftwareReleaseV1.0${version}/SindenLightgunLinuxSoftwareV1.0${version}/X86/64bit/Lightgun"

  cd "/home/${USER}/sinden-setup"

  cp "${p1_dir}/Player1/libCameraInterface.so" "/home/${USER}/Lightgun/Player1/libCameraInterface.so"
}

function execute_software() {
    mono "LightgunMono.exe" 2>&1 >/dev/null &
    PID=$!
    echo "--------------------------------------------------------------------------------"
    echo "| Waiting for an artifical amount of time while the software starts up"
    echo "--------------------------------------------------------------------------------"    
    sleep 10
    if [[ -d "/proc/${PID}" ]]; then
      return 0
    else
      return 1
    fi  
}

function try_fix() {
    download_sinden_software "7"
    extract_sinden_software "7"
    copy_camera_lib 7

    cd "/home/${USER}/Lightgun/Player1"
    execute_software
    local RET=$?
    if [ $RET -eq 0 ]; then
      echo "--------------------------------------------------------------------------------"
      echo "| Success the Sinden software is installed correctly"
      echo "--------------------------------------------------------------------------------"
      return 0
    else
      echo "--------------------------------------------------------------------------------"
      echo "| There is still an issue running the Sinden Software sorry!"
      echo "--------------------------------------------------------------------------------"
      return 1
    fi
}



function run_sinden_software() {
  cd "/home/${USER}/Lightgun/Player1"

  execute_software
  local RET=$?
  if [ $RET -eq 0 ]; then
    echo "--------------------------------------------------------------------------------"
    echo "| Success the Sinden software is installed correctly"
    echo "--------------------------------------------------------------------------------"
    killall mono
    return 0
  else
    echo "--------------------------------------------------------------------------------"
    echo "| Sinden Software did not run attempting to fix"
    echo "--------------------------------------------------------------------------------"

    try_fix
  fi
}

function install() {
  killall mono
  
  mkdir "/home/${USER}/sinden-setup"

  install_dependencies
  download_sinden_software "8"
  extract_sinden_software "8"
  copy_lightgun_folder "8"
  run_sinden_software
}

install