# 環境変数の読み込み
. /root/env.sh

# 証明書更新処理
if [ $STAGE = "production" ]; then
    echo "This is Production"
    certbot renew
else
    echo "This is Staging"
    certbot renew --dry-run
fi

# nginx再起動処理
supervisorctl restart nginx

exit 0
