@echo off
chcp 65001 >nul
set correct=0
set points=0
set total=4
set reviewer_level=Не определён

echo ==================================================
echo   Модуль инспекции кода (Код-ревью)
echo   Тематика: боты и интеграции мессенджеров
echo ==================================================
echo.

echo Фрагмент 1 (уведомление в Slack):
echo 10: def send_slack_alert(channel, text):
echo 11:     conn = open_slack_socket()
echo 12:     conn.post(channel, text)
echo 13:     return True
echo 14:     conn.close()
echo.
echo Какой дефект здесь скрыт?
echo 1. Мёртвое присваивание
echo 2. Утечка ресурса (недостижимый код после return)
echo 3. Магическое число
choice /c 123 /n /m "Ваш ответ (1-3): "
if errorlevel 3 goto f1_wrong
if errorlevel 2 goto f1_ok
if errorlevel 1 goto f1_wrong

:f1_ok
echo Верно! Строка 14 никогда не выполнится, соединение не закрывается. (+10 очков)
set /a correct+=1
set /a points+=10
goto f2

:f1_wrong
echo Неверно. Правильный ответ: 2 (строка conn.close() недостижима). (-5 очков)
set /a points-=5
goto f2

:f2
echo.
echo Фрагмент 2 (бот для Mattermost):
echo 20: def format_mattermost_msg(text):
echo 21:     if len(text) ^> 16383:
echo 22:         return text[:16380] + "..."
echo 23:     return text
echo.
echo Какой дефект здесь скрыт?
echo 1. Магическое число (16383, 16380)
echo 2. Неинициализированная переменная
echo 3. Отсутствие обработки ошибок
choice /c 123 /n /m "Ваш ответ (1-3): "
if errorlevel 3 goto f2_wrong
if errorlevel 2 goto f2_wrong
if errorlevel 1 goto f2_ok

:f2_ok
echo Верно! Лимит длины сообщения должен быть вынесен в константу. (+10 очков)
set /a correct+=1
set /a points+=10
goto f3

:f2_wrong
echo Неверно. Правильный ответ: 1 (магическое число 16383). (-5 очков)
set /a points-=5
goto f3

:f3
echo.
echo Фрагмент 3 (вебхук Rocket.Chat):
echo 30: def push_rocketchat_hook(url, payload):
echo 31:     resp = requests.post(url, json=payload)
echo 32:     return resp.status_code
echo.
echo Какой дефект здесь скрыт?
echo 1. Отсутствие обработки ошибок
echo 2. Неинициализированная переменная
echo 3. Утечка ресурса
choice /c 123 /n /m "Ваш ответ (1-3): "
if errorlevel 3 goto f3_wrong
if errorlevel 2 goto f3_wrong
if errorlevel 1 goto f3_ok

:f3_ok
echo Верно! Нет try/except и timeout для сетевого запроса. (+10 очков)
set /a correct+=1
set /a points+=10
goto f4

:f3_wrong
echo Неверно. Правильный ответ: 1 (отсутствие обработки сетевых ошибок). (-5 очков)
set /a points-=5
goto f4

:f4
echo.
echo Фрагмент 4 (подсчёт непрочитанных сообщений):
echo 40: def count_unread(channels):
echo 41:     for ch in channels:
echo 42:         total = total + ch["unread"]
echo 43:     return total
echo.
echo Какой дефект здесь скрыт?
echo 1. Магическое число
echo 2. Мёртвое присваивание
echo 3. Неинициализированная переменная
choice /c 123 /n /m "Ваш ответ (1-3): "
if errorlevel 3 goto f4_ok
if errorlevel 2 goto f4_wrong
if errorlevel 1 goto f4_wrong

:f4_ok
echo Верно! Переменная total не инициализирована перед циклом. (+10 очков)
set /a correct+=1
set /a points+=10
goto report

:f4_wrong
echo Неверно. Правильный ответ: 3 (неинициализированная переменная total). (-5 очков)
set /a points-=5
goto report

:report
set /a percentage=correct*100/total

echo.
echo === Итоговый отчёт ревьюера ===
echo Просмотрено фрагментов: %total%
echo Правильных ответов:     %correct% из %total%
echo Набрано очков:          %points%
echo Точность:               %percentage%%%

if %percentage% geq 80 (
    set reviewer_level=Senior Reviewer
) else if %percentage% geq 50 (
    set reviewer_level=Middle Reviewer
) else (
    set reviewer_level=Junior Reviewer
)

echo Уровень ревьюера:       %reviewer_level%
echo.
pause
