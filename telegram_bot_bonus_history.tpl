{{ limit = 5, data = [], offset = ( args0 || 0 ) }}
{{ items_all = bonus.limit(300).filter( user_id = user.id).items.size }}
{{ TEXT = BLOCK }}
  {{ IF ! items_all }}
Пока здесь ничего нет
  {{ ELSE }}
    {{ USE date }}
    {{ page_n = ( items_all div limit + 1 ) - ( ( items_all - offset) div limit ) }}
    {{ page_iz = ( items_all - 1 ) div limit  + 1 }}
    {{ items = bonus.limit(limit, offset).filter( user_id = user.id).rsort('date').items }}
<b>История начисления и списания бонусов.</b>

    {{ FOR item IN items }}
      {{ loop.count + offset }}. Дата: {{date.format(item.date, '%d.%m.%Y %H:%M') }}
      {{ inc_or_decr = item.bonus > 0 ? 'inc' : 'decr' }}
      {{SWITCH inc_or_decr }}
      {{ CASE 'inc' }}
<b>Начислено бонусов</b>: {{ item.bonus }}
      {{ IF item.comment.from_user_id }}
Реферал: {{ user.id(item.comment.from_user_id).full_name || 'Пользователь удален' }}
{{ login = user.id(ref_id).settings.telegram.login }}
{{ "
login: $login" IF login 
}}
      {{ END #item.comment.from_user_id }}
{{ " 
$item.comment.msg" IF item.comment.msg 
}}
{{ " 
$item.comment.text" IF item.comment.text 
}}
    {{ CASE 'decr' }}
<b>Списано бонусов</b>: {{ item.bonus }}
    {{ user_service_id = wd.id(item.comment.withdraw_id).user_service_id }}
Продление услуги: {{ us.id(user_service_id).name || 'Услуга удалена' }}
ID: {{ user_service_id || 'Услуга удалена' }}
    {{ END #switch }}
{{ '
------------------------------------' IF ! loop.last
}}

    {{ END # FOR }}
<b>Страница</b> {{ page_n }} из {{ page_iz }}
  {{ END #IF ! items_all }}
{{ END #TEXT}}

{{ IF offset == 0 && items.size == limit }}
  {{ data.push(
      [{
        "text" = '⇨⇨⇨ стр. ' _ ( page_n + 1 )
        "callback_data" = '/bonus_history ' _ (limit + offset)
      }]
    )
  }}
  {{ ELSIF offset != 0 && items.size == limit && offset != ( items_all - limit ) }}
  {{ data.push(
      [{
        "text" = 'стр. '_ ( page_n - 1 ) _ ' ⇦⇦⇦'
        "callback_data" = '/bonus_history ' _ (offset - limit)
      }
      {
        "text" = '⇨⇨⇨ стр. ' _ ( page_n + 1 )
        "callback_data" = '/bonus_history ' _ (limit + offset)
      }]
    )
  }}
  {{ ELSIF items.size && items.size != 0 && offset != 0  }}
  {{ data.push(
      [{
        "text" = 'стр. ' _ ( page_n - 1 ) _ ' ⇦⇦⇦'
        "callback_data" = '/bonus_history ' _ (offset - limit)
      }]
    )
  }}
{{ END }}
{{ data.push(
    [{
      "text" = '⇦  Бонусная программа'
      "callback_data" = '/referrals <--bonus_history'
    }]
  )
}}
{{ tg_api( "editMessageText" = {
        "message_id" = bot_message_id
        "parse_mode" = "HTML"
        "disable_notification" = "true"
        "text" = TEXT
        "reply_markup" = { "inline_keyboard" = data }
    })
}}
