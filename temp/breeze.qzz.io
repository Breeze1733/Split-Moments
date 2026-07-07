server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name breeze.qzz.io;

    root /var/www/breeze.qzz.io;
    index index.html;

    # =========================================================
    # 1. 旧业务后端 (moments / users / audio) -> 3000 端口（支持无限传）
    # =========================================================
    location /api/ {
        client_max_body_size 0;            # 解除上传大小限制
        client_body_timeout 3600s;         # 允许 1 小时的上传时间
        
        # 代理超时设置
        proxy_connect_timeout 3600s;
        proxy_send_timeout 3600s;
        proxy_read_timeout 3600s;

        # 关闭缓存，让大数据流直接穿透 Nginx
        proxy_request_buffering off;
        proxy_buffering off;

        rewrite ^/api/(.*)$ /$1 break; 
        proxy_pass http://127.0.0.1:3000;
        
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # =========================================================
    # 2. 新文件中转站后端 -> 3001 端口（支持无限传）
    # =========================================================
    location /transfer-api/ {
        client_max_body_size 0;            # 解除上传大小限制
        client_body_timeout 3600s;         # 允许 1 小时的上传时间
        
        # 代理超时设置
        proxy_connect_timeout 3600s;
        proxy_send_timeout 3600s;
        proxy_read_timeout 3600s;

        # 关闭缓存，让大数据流直接穿透 Nginx
        proxy_request_buffering off;
        proxy_buffering off;

        proxy_pass http://127.0.0.1:3001/;
        
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # =========================================================
    # 3. 文件上传目录映射 (由 3001 端口服务代理)
    # =========================================================
    location /uploads/ {
        proxy_pass http://127.0.0.1:3001/uploads/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # =========================================================
    # 4. 静态网页与通用安全配置
    # =========================================================
    # 前端静态网页
    location / {
        try_files $uri $uri/ =404;
    }

    # 隐藏文件保护
    location ~ /\. {
        deny all;
    }
}