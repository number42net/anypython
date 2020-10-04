#!/bin/bash
echo
env
echo

ls -lha /

# Test if private key exists, use default path if not, or ignore private key completely
if [ -f "$GIT_KEY" ] && [ -v GIT_REPO ]; then
    echo "Using key: $GIT_KEY to clone repo..."
    echo
    GIT_SSH_COMMAND='ssh -i $GIT_KEY -o IdentitiesOnly=yes' git clone $GIT_REPO /app
elif [ -f /deploy.key ]; then
    echo "Using key: /deploy.key to clone repo: $GIT_REPO"
    GIT_SSH_COMMAND='ssh -i /deploy.key -o IdentitiesOnly=yes -o StrictHostKeyChecking=no' git clone $GIT_REPO /app
elif [ -v GIT_REPO ]; then
    echo "Cloning public repo..."
    git clone $GIT_REPO
fi

cd /app

if [ -f "$REQUIREMENTS_TXT" ]; then
  echo
  echo "Installing requirements from $REQUIREMENTS_TXT"
  echo
  pip3 install -r $REQUIREMENTS_TXT
elif [ -f "requirements.txt" ]; then
  echo
  echo "Installing requirements from /app/requirements.txt"
  echo
  pip3 install -r requirements.txt
fi

echo
if [ -f "$SCRIPT" ]; then
  python3 $REQUIREMENTS_TXT
elif [ -f "main.py" ]; then
  python3 main.py
else
  echo "No script found..."
fi
