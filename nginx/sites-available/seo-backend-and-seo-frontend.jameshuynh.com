upstream seo_backend {
  server unix:/tmp/seo_backend.sock fail_timeout=0;
}

server {
  listen app-server:80;
  server_name seo-backend.jameshuynh.com;
  root /home/app/www/seo/backend/current/public;
  if (-f $request_filename) {
    break;
  }

  try_files $uri/index.html $uri @seo_backend;

  location @seo_backend {
    proxy_set_header Host $http_host;
    if (!-f $request_filename) {
      proxy_pass http://seo_backend;
      break;
    }
  }
  error_page 500 502 503 504 /500.html;

  access_log  /var/log/nginx/seo_backend.log;
  error_log  /var/log/nginx/seo_backend.log;
}

server {
  listen app-server:80;
  server_name seo-frontend.jameshuynh.com;
  root /home/app/www/seo/frontend/current/public;

  location ~ ^/(images|scripts|javascripts|stylesheets|system)/ {
    root /home/app/www/seo/frontend/current/public;
  }

  location / {

    if ($request_uri ~* "sitemap") {
      break;
    }

    if ($http_user_agent ~* "curl|Wget|googlebot|Google\-Structured\-Data\-Testing\-Tool|yahoo|bingbot|baiduspider|yandex|yeti|yodaobot|gigabot|ia_archiver|facebookexternalhit|twitterbot|developers\.google\.com") {
      rewrite ^ /seo?path=$uri break;
      proxy_pass http://seo_backend;
      break;
    }

    rewrite .* /index.html break;
  }

  access_log  /var/log/nginx/seo_frontend.log;
  error_log  /var/log/nginx/seo_frontend.log;
}
