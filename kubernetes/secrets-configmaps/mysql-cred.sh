cat << EOF | kubectl apply -f-
apiVersion: v1
kind: Secret
metadata:
  name: mysql-cred
  namespace: dev
data:
  MYSQL_DATABASE: `echo -n mydb | base64 -w0`
  MYSQL_ROOT_PASSWORD: `echo -n $PASS | base64 -w0`
  MYSQL_USERNAME: `echo -n $USER | base64 -w0`
EOF
