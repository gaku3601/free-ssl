if [ -e /etc/letsencrypt/live ]; then
    echo "SSL Certificate Folder is Fonund"
else
    echo "SSL Certificate Folder is Not Fonund"
    # 証明書の発行
    if [ $STAGE = "production" ]; then
        echo "This is Production"
        certbot certonly --webroot --webroot-path /usr/share/nginx/html/ssl -d $DOMAIN -m $MAIL --http-01-port $PORT --tls-sni-01-port $SSLPORT --agree-tos -n
    else
        echo "This is Staging"
        certbot certonly --test-cert --webroot --webroot-path /usr/share/nginx/html/ssl -d $DOMAIN -m $MAIL --http-01-port $PORT --tls-sni-01-port $SSLPORT --agree-tos -n
    fi
    # nginxの設定
    mv /etc/nginx/conf.d/default.ssl.conf~ /etc/nginx/conf.d/default.ssl.conf
    sed -i -e "s/convert_domain/$DOMAIN/g" /etc/nginx/conf.d/default.ssl.conf
    sed -i -e "s|convert_pass|$REVERSE_PROXY|g" /etc/nginx/conf.d/default.ssl.conf
    supervisorctl restart nginx
fi

echo "process end"
exit 0
