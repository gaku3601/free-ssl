if [ -e /etc/letsencrypt/live ]; then
    echo "SSL Certificate Folder is Fonund"
else
    echo "SSL Certificate Folder is Not Fonund"
    # 証明書の発行
    if [ $STAGE = "production" ]; then
        echo "This is Production"
        certbot certonly --webroot --webroot-path /usr/share/nginx/html/ssl -d $DOMAIN -m $MAIL --agree-tos -n
    else
        echo "This is Staging"
        certbot certonly --test-cert --webroot --webroot-path /usr/share/nginx/html/ssl -d $DOMAIN -m $MAIL --agree-tos -n
    fi
    # nginxの設定
    mv /etc/nginx/conf.d/default.ssl.conf~ /etc/nginx/conf.d/default.ssl.conf
    # basic認証設定
    if [ $BASIC_AUTH = "true" ]; then
      htpasswd -c -b /etc/nginx/conf.d/.htpasswd $BASIC_USER $BASIC_PASSWORD
    fi
    #プロキシ設定
    proxy=$(echo $REVERSE_PROXY | tr ',' ' ')
    for val in ${proxy[@]};
    do
      echo ${val}
      v=$(echo $val | tr '\->' ' ')
      data=()
      for val2 in ${v[@]};
      do
        data+=($val2)
      done
      echo ${data[0]} # path
      echo ${data[1]} # url
      # basic認証をかけるかかけないかで追記内容を変更
      if [ $BASIC_AUTH = "true" ]; then
        sed -i -e "$ i location ${data[0]} {\nproxy_pass ${data[1]};\n auth_basic 'Restricted';\n auth_basic_user_file /etc/nginx/conf.d/.htpasswd;\n}" /etc/nginx/conf.d/default.ssl.conf
      else
        sed -i -e "$ i location ${data[0]} {\nproxy_pass ${data[1]};\n}" /etc/nginx/conf.d/default.ssl.conf
      fi
    done


    sed -i -e "s/convert_domain/$DOMAIN/g" /etc/nginx/conf.d/default.ssl.conf
    #sed -i -e "s|convert_pass|$REVERSE_PROXY|g" /etc/nginx/conf.d/default.ssl.conf
    supervisorctl restart nginx
fi

echo "process end"
exit 0
