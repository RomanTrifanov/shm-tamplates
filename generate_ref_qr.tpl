{{# Шаблон для генерации реферального QR-кода }}
  
{{# НАСТРОЙКИ }}
{{ top_text = 'Твой QR-код' }}
{{ bot_name = 'My_vpn_Bot' #Имя вашего бота}}
{{ qr_color = '2e47c3' }}{{# настройка цвета HEX https://www.colorhexa.com }}
{{ qr_size = 7 }}{{# настройка размера }}
{{# ---------------------------------- }}

{{ IF request.params.uid }}
{{ user = user.switch( request.params.uid ) }}
{{ END }}
{{ ref_url = "https://t.me/${bot_name}?start=${user.id}" }}
{{ PERL }}
     my $ref_link = $stash->get('ref_url');
     my $qr_color = $stash->get('qr_color');
     my $qr_size = $stash->get('qr_size');
     my $data = qx(echo "$ref_link" | qrencode -l H -s $qr_size -t PNG --foreground=$qr_color -o - | base64);
     $stash->set('user_ref_qr',$data)
{{ END }}
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ top_text }}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f9f9f9;
        }
        h1 {
            margin-top: 50px;
        }
        img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 20px auto;
        }
    </style>
</head>
<body>
    <h1>{{ top_text }}</h1>
    <img style="display: block;-webkit-user-select: none;margin: auto;background-color: hsl(0, 0%, 90%);transition: background-color 300ms;" src="data:image/png;base64,{{ user_ref_qr }}">
     <h2>{{ bot_name }}</h2>
</body>
</html>
