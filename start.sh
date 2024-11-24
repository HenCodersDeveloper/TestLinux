#!/bin/bash

# Menyiapkan koneksi RDP
echo "Mengonfigurasi RDP untuk pengguna 'administrator'..."

# Menambahkan pengguna administrator dan password
sudo useradd -m administrator
echo "administrator:HenCoders2024" | sudo chpasswd
sudo usermod -aG sudo administrator

# Mengaktifkan dan mengonfigurasi xRDP
echo "Mengonfigurasi xRDP..."
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Mengatur sesi default ke xfce4 untuk administrator
sudo -u administrator bash -c "echo 'xfce4-session' > /home/administrator/.xsession"
sudo chown administrator:administrator /home/administrator/.xsession

# Menyesuaikan konfigurasi xRDP untuk xfce4
sudo sed -i.bak '/. /c\startxfce4' /etc/xrdp/startwm.sh
sudo systemctl restart xrdp

# Menghubungkan ke Ngrok
echo "Menghubungkan ke Ngrok..."
./ngrok authtoken $NGROK_AUTH_TOKEN
nohup ./ngrok tcp 3389 &> ngrok.log &
sleep 10

# Menampilkan informasi Ngrok (IP dan port)
NGROK_INFO=$(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
if [ -z "$NGROK_INFO" ]; then
  echo "Gagal mendapatkan informasi Ngrok. Pastikan token valid."
else
  echo "============================================"
  echo "RDP setup completed successfully!"
  echo "Username: administrator"
  echo "Password: HenCoders2024"
  echo "Connect to RDP using the following address:"
  echo "$NGROK_INFO"
  echo "============================================"
fi
