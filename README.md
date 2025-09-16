### generate_ref_qr.tpl
```generate_ref_qr.tpl``` - настраеваемый шаблон SHM (https://myshm.ru/), генерирует партнерский QR-код для вывода в telegram bot по кнопке.

Пример кода кнопки:

```
[{
  "text": "Показать твой QR",
  "web_app": { "url": "{{ config.api.url }}/shm/v1/template/generate_ref_qr?format=html&session_id={{ user.gen_session.id }}"}
}]
```

---


### telegram_bot_bonus_history.tpl
```telegram_bot_bonus_history.tpl``` - шаблон для просмотра истории бонусов в телеграм боте.

В код шаблона телеграм бота добавить кейс ```/bonus_history```

```
<% CASE '/bonus_history' %>
{{ my_vars = {
     args0 = args.0
     bot_message_id = message.message_id
     }
}}
{{ tpl.id( 'telegram_bot_bonus_history' ).parse('vars', my_vars ) }}
```

Добавить кнопку для вызова кейса в желаемое место, например в раздел реферальной программы.

Пример
```
[{
  text = "⚡️ История бонусов"
  callback_data = "/bonus_history"
}]
```
