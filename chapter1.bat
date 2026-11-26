@echo off
chcp 65001 >nul
set score_slack=0
set score_mattermost=0
set score_rocketchat=0
set rec_tech=Не определено

echo ==================================================
echo   Модуль выбора корпоративного мессенджера
echo   (Вариант 3: Slack / Mattermost / Rocket.Chat)
echo ==================================================
echo.

:q1
echo Вопрос 1: Каков масштаб команды и нагрузка на каналы?
echo 1. До 20 человек, базовые каналы и быстрый старт
echo 2. 20-100 человек, распределённая команда с ростом нагрузки
echo 3. Более 100 человек или сложная структура с федерацией серверов
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 goto q1_opt3
if errorlevel 2 goto q1_opt2
if errorlevel 1 goto q1_opt1

:q1_opt1
set /a score_slack+=10
set /a score_mattermost+=5
goto q2

:q1_opt2
set /a score_mattermost+=15
set /a score_rocketchat+=10
goto q2

:q1_opt3
set /a score_rocketchat+=15
set /a score_mattermost+=10
goto q2

:q2
echo.
echo Вопрос 2: Какие требования к безопасности и хранению данных?
echo 1. Допустимо облачное SaaS-решение с корпоративным SLA
echo 2. Строго на собственных серверах (On-Premise), требования ИБ
echo 3. Максимальный контроль: открытый исходный код и E2E-шифрование
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 goto q2_opt3
if errorlevel 2 goto q2_opt2
if errorlevel 1 goto q2_opt1

:q2_opt1
set /a score_slack+=15
goto q3

:q2_opt2
set /a score_mattermost+=15
set /a score_rocketchat+=15
goto q3

:q2_opt3
set /a score_rocketchat+=15
set /a score_mattermost+=10
goto q3

:q3
echo.
echo Вопрос 3: Какой бюджет выделен на корпоративный мессенджер?
echo 1. Готовы оплачивать ежемесячную подписку за пользователя
echo 2. Минимальный бюджет: нужна бесплатная Self-Hosted версия
echo 3. Средний бюджет: готовы вкладываться в поддержку своего сервера
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 goto q3_opt3
if errorlevel 2 goto q3_opt2
if errorlevel 1 goto q3_opt1

:q3_opt1
set /a score_slack+=15
goto q4

:q3_opt2
set /a score_rocketchat+=15
set /a score_mattermost+=10
goto q4

:q3_opt3
set /a score_mattermost+=15
set /a score_rocketchat+=10
goto q4

:q4
echo.
echo Вопрос 4: Какие сроки запуска и квалификация команды?
echo 1. Запуск нужен немедленно, выделенного DevOps-инженера нет
echo 2. Есть системный администратор, запуск за 1-2 дня
echo 3. Есть сильная DevOps-команда для тонкой настройки и интеграций
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 goto q4_opt3
if errorlevel 2 goto q4_opt2
if errorlevel 1 goto q4_opt1

:q4_opt1
set /a score_slack+=15
goto result

:q4_opt2
set /a score_mattermost+=15
set /a score_rocketchat+=5
goto result

:q4_opt3
set /a score_rocketchat+=15
set /a score_mattermost+=10
goto result

:result
echo.
echo === Результаты профилирования проекта ===
echo Баллы Slack:       %score_slack%
echo Баллы Mattermost:  %score_mattermost%
echo Баллы Rocket.Chat: %score_rocketchat%
echo.

if %score_slack% geq %score_mattermost% if %score_slack% geq %score_rocketchat% (
    set rec_tech=Slack
    goto show_rec
)
if %score_mattermost% geq %score_slack% if %score_mattermost% geq %score_rocketchat% (
    set rec_tech=Mattermost
    goto show_rec
)
set rec_tech=Rocket.Chat

:show_rec
echo Рекомендация для вашего проекта: %rec_tech%
echo.
pause
