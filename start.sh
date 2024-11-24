#!/bin/bash

# Mengonfigurasi RDP
echo "Mengonfigurasi RDP untuk pengguna 'administrator'..."
sudo useradd -m administrator
echo "administrator:HenCoders2024" | sudo chpasswd
sudo usermod -aG sudo administrator

# Mengaktifkan xRDP
echo "Mengaktifkan xRDP..."
sudo systemctl enable xrdp
sudo systemctl start xrdp
echo "xfce4-session" > ~/.xsession
sudo systemctl restart xrdp

# Mengonfigurasi Ngrok
echo "Menghubungkan ke Ngrok..."
./ngrok authtoken $NGROK_AUTH_TOKEN
sleep 5
nohup ./ngrok tcp --region ap 3389 &> ngrok.log &
sleep 10

# Mengecek dan Menampilkan URL Ngrok
NGROK_URL=$(curl -s localhost:4040/api/tunnels | jq -r .tunnels[0].public_url)
if [[ $NGROK_URL == null ]]; then
    echo "Gagal mendapatkan informasi Ngrok. Pastikan token valid."
    cat ngrok.log
    exit 1
else
    echo "============================================"
    echo "RDP setup completed successfully!"
    echo "Username: administrator"
    echo "Password: HenCoders2024"
    echo "Connect to RDP using the following address:"
    echo "$NGROK_URL"
    echo "============================================"
fi
