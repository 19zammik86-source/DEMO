touch /var/www/html/index.html
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мой сервер на Альт Линукс</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            max-width: 600px;
        }
        h1 { margin-top: 0; font-size: 2.5em; }
        p { font-size: 1.2em; line-height: 1.6; }
        .time { font-size: 1.5em; font-weight: bold; color: #4facfe; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Добро пожаловать!</h1>
        <p>Ваш собственный веб-сервер на базе <strong>Nginx</strong> и <strong>Альт Линукс</strong> успешно настроен и работает.</p>
        <div class="time" id="clock">Загрузка времени...</div>
    </div>

    <script>
        function updateClock() {
            const now = new Date();
            const options = { 
                weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', 
                hour: '2-digit', minute: '2-digit', second: '2-digit' 
            };
            document.getElementById('clock').innerText = now.toLocaleDateString('ru-RU', options);
        }
        setInterval(updateClock, 1000);
        updateClock();
    </script>
</body>
</html>
EOF
    
    mkdir -p /var/www/mysite
   cp /var/www/html/index.html /var/www/mysite/
   chown -R nginx:nginx /var/www/mysite
   chmod -R 755 /var/www/mysite

