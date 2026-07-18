#!/bin/bash

# get admin privileges
sudo su

# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
cd /var/www/html
aws s3 cp s3://kubus-s3bucket/index.html .



# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root or with sudo."
  exit 1
fi

# Variables - Modify these as needed
USERNAME="george" # Change this to the desired username
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDn6Hr+FfIN5pLOLt5P0+Z16bqrwA6g1QN22CZGrG3XQOWL/TvqpU87gJ42g5mjR4exvFNtYnfBbMlFRY06pbSnjx72iG1K45b4aZhElKvDoVCYEmQOtTXYbUotwEwyw2Op/rpD7P796pogSe2gTYwv37YbvwydNeNBLBFrC4ZbrBMWLagxR/fnXSobZDUva2gKj8ahP/1Zm/1Na8u1+kak4gQQKsRkEpkfxWmUxxYGUFoZFYvKH+hEq7V6abDVvqGwios97eyAabwd2W2CxT42VybssQ330bvrxivjQBNDPooDM4u6lRj33NLOuaExSNX16ZRegjypwEF/4o042ctnDb8J+u1BMX7facBweg0r85StlnNdP9ZWiWCfWrDmfcd+/H4zNI1Sekd5uJQ57YmZKuaf9Lu57Z+BEsi8JIxkvBtbB6apFRdh2mc0MRdEMBX6+qJLWYHD5TgQtUYEhA+3BJnHcFRt0MXnaxSURCQDViJ9ZUQGjcQRw6gL6TZ12vM= kubus@GeorgeAkwari" # Paste the full public key here

# 1. Create the user with a home directory and default bash shell
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists."
else
    useradd -m -s /bin/bash "$USERNAME"
    echo "User '$USERNAME' created successfully."
fi

# 2. Set up the .ssh directory structure
USER_HOME="/home/$USERNAME"
SSH_DIR="$USER_HOME/.ssh"

mkdir -p "$SSH_DIR"

# 3. Add the public key to authorized_keys
echo "$PUBLIC_KEY" > "$SSH_DIR/authorized_keys"

# 4. Set strict, mandatory AWS Linux security permissions
chmod 700 "$SSH_DIR"
chmod 600 "$SSH_DIR/authorized_keys"
chown -R "$USERNAME:$USERNAME" "$SSH_DIR"

echo "SSH public key successfully configured for '$USERNAME'."

# 5. Optional: Grant sudo access (uncomment the 2 lines below if required)
# echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USERNAME"
# chmod 440 "/etc/sudoers.d/$USERNAME"

echo "Setup complete! The user can now log in via: ssh $USERNAME@<your-ec2-ip>"
