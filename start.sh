#!/bin/bash

# Menyiapkan koneksi RDP
echo "Mengonfigurasi RDP untuk pengguna 'administrator'..."

# Menambahkan pengguna administrator dan password
sudo useradd -m administrator
echo "administrator:HenCoders2024" | sudo chpasswd
sudo usermod -aG sudo administrator

# Mengaktifkan xRDP dan mulai sesi RDP
echo "Mengonfigurasi xRDP..."
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Mengatur sesi default ke xfce4
echo "xfce4-session" > ~/.xsession

# Restart xRDP service
sudo systemctl restart xrdp

# Menghubungkan ke Cloudflare Tunnel atau ngrok
echo "Menghubungkan ke Ngrok..."
./ngrok authtoken $NGROK_AUTH_TOKEN
nohup ./ngrok tcp 3389 &> ngrok.log &
sleep 10

# Menampilkan alamat RDP yang dapat diakses
echo "============================================"
echo "RDP setup completed successfully!"
echo "Username: administrator"
echo "Password: HenCoders2024"
echo "Connect to RDP using the following address:"
curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url
echo "============================================"