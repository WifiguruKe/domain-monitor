#!/bin/bash
set -e

# Create .env from environment variables
cat > /var/www/html/.env << EOF
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT:-3306}
DB_DATABASE=${DB_DATABASE}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}
APP_URL=${APP_URL}
APP_TIMEZONE=${APP_TIMEZONE:-UTC}
APP_ENCRYPTION_KEY=${APP_ENCRYPTION_KEY}
EOF

# Create .installed flag if DB has users (already installed)
php -r "
try {
    \$pdo = new PDO('mysql:host=${DB_HOST};port=${DB_PORT:-3306};dbname=${DB_DATABASE}', '${DB_USERNAME}', '${DB_PASSWORD}');
    \$count = \$pdo->query('SELECT COUNT(*) FROM users')->fetchColumn();
    if (\$count > 0) { file_put_contents('/var/www/html/.installed', date('Y-m-d H:i:s')); }
} catch (Exception \$e) {}
"

exec "$@"