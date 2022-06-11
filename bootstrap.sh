#!/bin/bash

REPO=https://github.com/autotelic/bill
DEST=~/src/bill

echo -ne "\x1b[37m"
cat <<'EOF'

   ___            __      __                  ___  _ ____
  / _ )___  ___  / /____ / /________ ____    / _ )(_) / /
 / _  / _ \/ _ \/ __(_-</ __/ __/ _ `/ _ \  / _  / / / /
/____/\___/\___/\__/___/\__/_/  \_,_/ .__/ /____/_/_/_/
                                   /_/

EOF

echo -ne "\x1b[0m"
echo "
Bill will bootstrap your machine. It will:

- install Homebrew
- install Ansible and Git with Homebrew
- clone the bill repo
- run the Ansible playbooks to install and setup some apps

It will take a bit of time to download and install everything.
"

read -n1 -p  $'\e[0;1m Hit enter to start setup, \'n\' to cancel. Start bootstrapping? \e[2m[Y/n] ' yn

if [[ $yn == [Nn] ]]; then
  printf "\nSetup cancelled.\n"; exit;
fi

echo "Homebrew will ask for your login password."

printf "\nInstalling Homebrew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)

printf "\nInstalling Ansible and Git"

brew install git ansible

printf "\nCloning playbooks"

if [ ! -d  $DEST ]; then
  mkdir -p "$(dirname $DEST)"
  git clone "$REPO" "$DEST"
else
  printf "\nAlready cloned, updating to latest.\n"
  (cd $DEST && git pull --ff-only)
fi

cd $DEST && ansible-playbook -K install.yml
