# 環境変数の設定
printenv | awk '{print "export " $1}' > /root/env.sh

# 起動
cron -f
