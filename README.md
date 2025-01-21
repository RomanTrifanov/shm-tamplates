**generate_ref_qr** - настраеваемый шаблон SHM (https://myshm.ru/), генерирует партнерский QR-код для вывода в telegram bot по кнопке.

Пример кода кнопки:

```
[
  {
    "text": "Показать твой QR",
    "web_app": { "url": "{{ config.api.s_url }}/shm/v1/template/generate_ref_qr?format=html&session_id={{ user.gen_session.id }}"}
  }
]
```
