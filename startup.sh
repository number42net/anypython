#!/bin/bash

# Test if private key exists, use default path if not, or ignore private key completely
if [ -f "$GIT_KEY" ] && [ -v GIT_REPO ]; then
    echo "Using key: $GIT_KEY to clone repo..."
    # Prevent issues when the SSH key doesn't end in a newline.
    cp $GIT_KEY /deploy_temp.key
    chmod 600 /deploy_temp.key
    echo >> /deploy_temp.key
    GIT_SSH_COMMAND='ssh -i /deploy_temp.key -o IdentitiesOnly=yes' git clone --quiet $GIT_REPO /app

elif [ -f /deploy.key ]; then
    echo "Using key: /deploy.key to clone repo: $GIT_REPO  ..."
    GIT_SSH_COMMAND='ssh -i /deploy_temp.key -o IdentitiesOnly=yes' git clone --quiet $GIT_REPO /app

elif [ -v GIT_REPO ]; then
    echo "Cloning public repo..."
    git clone --quiet $GIT_REPO

fi

# Test if /app has been created or already existed
if [ -d /app ]; then
  cd /app
else
  echo "No /app directory"
  exit
fi

# Install requirements
if [ -f "$REQUIREMENTS_TXT" ]; then
  echo
  echo "Installing requirements from $REQUIREMENTS_TXT ..."
  echo
  pip3 -q install --upgrade pip
  pip3 -q install -r $REQUIREMENTS_TXT
elif [ -f "requirements.txt" ]; then
  echo
  echo "Installing requirements from /app/requirements.txt ..."
  echo
  pip3 -q install --upgrade pip
  pip3 -q install -r requirements.txt
fi

echo
echo "##  Installation complete  ##"
echo
if [ -f "$SCRIPT" ]; then
  python3 $SCRIPT
elif [ -f "main.py" ]; then
  python3 main.py
else
  echo "No script found..."
fi
