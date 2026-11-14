#!/usr/bin/env bash
# ==========================================================
# Instala o actualiza Fressia en el servidor de DonWeb,
# al lado de la tienda VELT (que no se toca).
#
#   Fressia  → /var/www/fressia · PM2 "fressia" · puerto 3001
#              base tienda_fressia · https://fressia.veltaweb.com.ar
#
# Uso (como root, dentro del servidor):
#   curl -fsSL https://raw.githubusercontent.com/ExequielJuarez/Fressia/main/deploy/instalar-donweb.sh | bash
#
# La primera vez: clona el repo, crea la base y su usuario (con una
# clave al azar que queda solo en el .env del servidor), carga los
# datos de prueba, prende la app, configura Nginx y saca el certificado https.
# Las veces siguientes: solo trae los cambios de GitHub y reinicia.
# ==========================================================
set -euo pipefail

DOMINIO="fressia.veltaweb.com.ar"
CARPETA="/var/www/fressia"
REPO="https://github.com/ExequielJuarez/Fressia.git"
PUERTO=3001
APP="fressia"
BASE="tienda_fressia"
USUARIO_BASE="fressia"

paso() { printf '\n\033[1;33m▶ %s\033[0m\n' "$1"; }
ok() { printf '\033[1;32m✔ %s\033[0m\n' "$1"; }

[ "$(id -u)" -eq 0 ] || { echo "Correlo como root"; exit 1; }

# ── Actualización: si ya está instalada, solo trae lo nuevo ──
if [ -d "$CARPETA/.git" ] && [ -f "$CARPETA/.env" ]; then
  paso "Fressia ya está instalada: traigo los cambios de GitHub"
  cd "$CARPETA"
  git pull --ff-only
  npm ci --omit=dev --no-audit --no-fund
  pm2 restart "$APP" --update-env
  pm2 save
  ok "Actualizada: https://$DOMINIO"
  exit 0
fi

paso "1/7 Programas necesarios"
apt-get update -qq
apt-get install -y -qq git nginx mariadb-server certbot python3-certbot-nginx >/dev/null
systemctl enable --now mariadb nginx >/dev/null
node -v

paso "2/7 Bajando el proyecto de GitHub"
mkdir -p /var/www
rm -rf "$CARPETA"
git clone -q "$REPO" "$CARPETA"
cd "$CARPETA"
npm ci --omit=dev --no-audit --no-fund

paso "3/7 Base de datos $BASE y su usuario"
CLAVE_BASE="$(openssl rand -hex 16)"
mysql -e "CREATE DATABASE IF NOT EXISTS $BASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$USUARIO_BASE'@'localhost' IDENTIFIED BY '$CLAVE_BASE';
ALTER USER '$USUARIO_BASE'@'localhost' IDENTIFIED BY '$CLAVE_BASE';
GRANT ALL PRIVILEGES ON $BASE.* TO '$USUARIO_BASE'@'localhost';
FLUSH PRIVILEGES;"
ok "Base lista (la clave quedó solo en $CARPETA/.env)"

paso "4/7 Archivo .env del servidor"
cat > .env <<EOF
NODE_ENV=production
HOST=127.0.0.1
PORT=$PUERTO
SESSION_SECRET=$(openssl rand -hex 32)
APP_URL=https://$DOMINIO

DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=$USUARIO_BASE
DB_PASSWORD=$CLAVE_BASE
DB_NAME=$BASE
DB_TIMEZONE=-03:00
DB_POOL_MAX=5

MP_ACCESS_TOKEN=
MP_WEBHOOK_SECRET=
MP_NOMBRE_TIENDA=Fressia
MP_MAX_CUOTAS=6
PAGO_VENCE_HORAS=48

TRANSFERENCIA_ALIAS=
TRANSFERENCIA_CBU=
TRANSFERENCIA_TITULAR=
TRANSFERENCIA_BANCO=

SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
SMTP_USER=
SMTP_PASS=
MAIL_FROM=Fressia <tu-cuenta@gmail.com>

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_CALLBACK_URL=https://$DOMINIO/auth/google/callback

TIENDA_DIRECCION=Av. Belgrano Sur 1704 (esq. Dorrego), Santiago del Estero
TIENDA_TELEFONO=
TIENDA_EMAIL=
TIENDA_CUIT=
TIENDA_WHATSAPP=
TIENDA_INSTAGRAM=
TIENDA_HORARIOS=
EOF
chmod 600 .env
ok ".env creado"

paso "5/7 Tablas y productos de prueba"
npm run db:instalar

paso "6/7 Prendiendo la tienda con PM2 (puerto $PUERTO)"
pm2 delete "$APP" >/dev/null 2>&1 || true
pm2 start src/app.js --name "$APP"
pm2 save
sleep 3
pm2 logs "$APP" --lines 8 --nostream || true

paso "7/7 Nginx para $DOMINIO y certificado https"
cat > /etc/nginx/sites-available/$APP <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMINIO;
    client_max_body_size 20M;

    location /admin/notificaciones/stream {
        proxy_pass http://127.0.0.1:$PUERTO;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_buffering off;
        proxy_read_timeout 1h;
    }

    location / {
        proxy_pass http://127.0.0.1:$PUERTO;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
ln -sf /etc/nginx/sites-available/$APP /etc/nginx/sites-enabled/$APP
nginx -t
systemctl reload nginx

if certbot --nginx -d "$DOMINIO" --non-interactive --agree-tos --register-unsafely-without-email --redirect; then
  ok "https activado"
else
  echo "⚠️  No se pudo sacar el certificado todavía (¿el DNS recién creado aún no llegó?)."
  echo "   La tienda ya anda en http://$DOMINIO. Probá más tarde con:"
  echo "   certbot --nginx -d $DOMINIO --redirect"
fi

printf '\n\033[1;32m══════════════════════════════════════════\033[0m\n'
ok "Fressia publicada: https://$DOMINIO"
pm2 status
