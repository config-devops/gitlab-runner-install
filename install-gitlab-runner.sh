#!/bin/bash

set -e

echo "========================================="
echo " GitLab Runner Clean Install Script"
echo " Ubuntu 22.04 - Production Ready"
echo "========================================="

# warna output
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}[1/8] Remove old installation (if exists)...${NC}"

sudo gitlab-runner stop 2>/dev/null || true
sudo gitlab-runner uninstall 2>/dev/null || true

sudo rm -f /usr/local/bin/gitlab-runner
sudo rm -rf /etc/gitlab-runner
sudo rm -rf /home/gitlab-runner

sudo userdel gitlab-runner 2>/dev/null || true


echo -e "${GREEN}[2/8] Update system and install dependencies...${NC}"

sudo apt update -y
sudo apt install -y curl ca-certificates tzdata


echo -e "${GREEN}[3/8] Download GitLab Runner binary...${NC}"

sudo curl -L --output /usr/local/bin/gitlab-runner \
https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64


echo -e "${GREEN}[4/8] Set executable permission...${NC}"

sudo chmod +x /usr/local/bin/gitlab-runner


echo -e "${GREEN}[5/8] Create gitlab-runner user...${NC}"

sudo useradd \
  --comment 'GitLab Runner' \
  --create-home \
  --shell /bin/bash \
  gitlab-runner


echo -e "${GREEN}[6/8] Install GitLab Runner service...${NC}"

sudo gitlab-runner install \
  --user=gitlab-runner \
  --working-directory=/home/gitlab-runner


echo -e "${GREEN}[7/8] Start GitLab Runner service...${NC}"

sudo gitlab-runner start


echo -e "${GREEN}[8/8] Enable auto start on boot...${NC}"

sudo systemctl enable gitlab-runner


echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN} GitLab Runner installed successfully!${NC}"
echo -e "${GREEN}=========================================${NC}"

echo ""
echo "Version:"
gitlab-runner --version

echo ""
echo "Service status:"
sudo systemctl status gitlab-runner --no-pager

echo ""
echo "Next step: Register runner using command:"
echo ""
echo "sudo gitlab-runner register"
echo ""
