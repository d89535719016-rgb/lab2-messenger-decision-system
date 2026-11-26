# Лабораторная работа №2. Моделирование процесса принятия решений и формализация ревьюирования

## 1. Титульные данные

* **ФИО:** [Исаенко Д. М.]
* **Группа:** [3525П1ИН2]
* **Номер работы:** Лабораторная работа №2
* **Вариант:** Вариант 3 — Выбор мессенджера для корпоративной связи (Slack, Mattermost, Rocket.Chat; распределённая команда из 20 человек с требованиями к безопасности)

## 2. Ссылка на репозиторий GitHub

* **Репозиторий:** [lab2-messenger-decision-system](https://github.com/d89535719016-rgb/lab2-messenger-decision-system)
* **Прямая ссылка:** `https://github.com/d89535719016-rgb/lab2-messenger-decision-system`

## 3. Листинг модулей и комментарии к коду

### 3.1. Модуль выбора технологий (`chapter1.bat`)

Модуль реализует систему диалогов из 4 вопросов (масштаб команды, требования к безопасности и хранению данных, бюджет, сроки и квалификация DevOps). На основе ответов пользователя через `choice` и ветвление `if errorlevel ... goto` начисляются баллы переменным профиля проекта (`score_slack`, `score_mattermost`, `score_rocketchat`), после чего формируется итоговая рекомендация `rec_tech`.

```bat
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
```

**Ключевые участки кода:**

* `chcp 65001 >nul` — переключение кодовой страницы консоли в UTF-8 для корректного отображения кириллицы.
* `choice /c 123 /n` — считывание выбора пользователя без необходимости нажимать Enter.
* `if errorlevel N goto ...` — проверка выбранного пункта в порядке убывания (3, 2, 1) и переход к начислению баллов через `set /a`.

### 3.2. Модуль инспекции кода (`chapter2.bat`)

Модуль последовательно выводит 4 фрагмента кода на Python, связанные с разработкой ботов и интеграций для Slack, Mattermost и Rocket.Chat. За верный ответ начисляются `+10` очков и увеличивается счётчик `correct`, за ошибочный снимается `5` очков. В конце рассчитывается процент точности и присваивается уровень ревьюера (`Senior Reviewer`, `Middle Reviewer` или `Junior Reviewer`).

```bat
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
```

**Ключевые участки кода:**

* Фрагмент 1 проверяет умение находить утечку ресурса (недостижимый `conn.close()` после `return`).
* Фрагмент 2 проверяет поиск «магических чисел» (`16383`, `16380`).
* Фрагмент 3 проверяет отсутствие обработки сетевых ошибок (`try/except`).
* Фрагмент 4 проверяет поиск неинициализированной переменной (`total`).

### 3.3. Модуль сравнительного анализа альтернатив (`chapter3.bat`)

Модуль реализует метод взвешенной суммы (WSM). Пользователь задаёт веса трём критериям (с проверкой `if %total_weight% neq 100` и повторным вводом при ошибке) и оценивает каждого кандидата по шкале от 1 до 5. Далее рассчитываются суммы `S = Σ(W × X)`, выводится табличная матрица решений и определяется победитель `wsm_winner`.

```bat
@echo off
chcp 65001 >nul
set wsm_winner=Не определён

echo ==================================================
echo   Модуль сравнительного анализа мессенджеров (WSM)
echo   Кандидаты: Slack, Mattermost, Rocket.Chat
echo ==================================================
echo.

:input_weights
echo Назначьте веса критериям (сумма должна быть равна 100):
set /p w1="Вес критерия 1 (Безопасность и контроль данных): "
set /p w2="Вес критерия 2 (Стоимость владения): "
set /p w3="Вес критерия 3 (Удобство и интеграции): "

set /a total_weight=w1+w2+w3
if %total_weight% neq 100 (
    echo.
    echo Ошибка: сумма весов равна %total_weight%, а должна быть 100! Повторите ввод.
    echo.
    goto input_weights
)

echo.
echo Оцените альтернативы по каждому критерию по шкале от 1 до 5:

echo --- Slack ---
set /p s_1="Slack по критерию 1 (Безопасность): "
set /p s_2="Slack по критерию 2 (Стоимость): "
set /p s_3="Slack по критерию 3 (Удобство): "

echo --- Mattermost ---
set /p m_1="Mattermost по критерию 1 (Безопасность): "
set /p m_2="Mattermost по критерию 2 (Стоимость): "
set /p m_3="Mattermost по критерию 3 (Удобство): "

echo --- Rocket.Chat ---
set /p r_1="Rocket.Chat по критерию 1 (Безопасность): "
set /p r_2="Rocket.Chat по критерию 2 (Стоимость): "
set /p r_3="Rocket.Chat по критерию 3 (Удобство): "

set /a score_s=s_1*w1+s_2*w2+s_3*w3
set /a score_m=m_1*w1+m_2*w2+m_3*w3
set /a score_r=r_1*w1+r_2*w2+r_3*w3

echo.
echo === Матрица решений ===
echo Критерий     ^| Вес ^| Slack ^| Mattermost ^| Rocket.Chat
echo -------------+-----+-------+------------+------------
echo Безопасность ^| %w1%  ^|   %s_1%   ^|     %m_1%      ^|      %r_1%
echo Стоимость    ^| %w2%  ^|   %s_2%   ^|     %m_2%      ^|      %r_2%
echo Удобство     ^| %w3%  ^|   %s_3%   ^|     %m_3%      ^|      %r_3%
echo -------------+-----+-------+------------+------------
echo ИТОГО (S)    ^| 100 ^|  %score_s%  ^|    %score_m%     ^|     %score_r%
echo.

if %score_s% geq %score_m% if %score_s% geq %score_r% (
    set wsm_winner=Slack
    goto show_winner
)
if %score_m% geq %score_s% if %score_m% geq %score_r% (
    set wsm_winner=Mattermost
    goto show_winner
)
set wsm_winner=Rocket.Chat

:show_winner
echo Победитель сравнительного анализа: %wsm_winner%
echo.
pause
```

**Ключевые участки кода:**

* Цикл валидации `:input_weights` гарантирует, что сумма весов строго равна 100.
* Экранирование символа `^|` позволяет аккуратно вывести таблицу матрицы решений в консоли Windows.

### 3.4. Главный интегрирующий файл (`lab_system.bat`)

Файл объединяет все три модуля через команду `call "%~dp0chapterN.bat"`, предоставляет интерактивное меню из 5 пунктов и при выборе пункта 4 запускает все модули последовательно, после чего выводит агрегированный отчёт и сохраняет его в `report.txt`.

```bat
@echo off
chcp 65001 >nul
set rec_tech=Не пройдено
set reviewer_level=Не пройдено
set wsm_winner=Не пройдено

:menu
cls
echo ====================================================
echo   СИСТЕМА МОДЕЛИРОВАНИЯ ПРОЦЕССОВ РАЗРАБОТКИ ПО
echo   Вариант 3: Выбор корпоративного мессенджера
echo ====================================================
echo.
echo 1. Модуль выбора технологий
echo 2. Модуль инспекции кода
echo 3. Модуль сравнительного анализа
echo 4. Запустить все модули последовательно
echo 5. Выход
echo.
set choice=
set /p choice="Ваш выбор: "

if "%choice%"=="1" (
    call "%~dp0chapter1.bat"
    goto menu
)
if "%choice%"=="2" (
    call "%~dp0chapter2.bat"
    goto menu
)
if "%choice%"=="3" (
    call "%~dp0chapter3.bat"
    goto menu
)
if "%choice%"=="4" goto run_all
if "%choice%"=="5" exit /b 0
goto menu

:run_all
cls
call "%~dp0chapter1.bat"
cls
call "%~dp0chapter2.bat"
cls
call "%~dp0chapter3.bat"

cls
echo ====================================================
echo   Итоговый отчёт системы
echo ====================================================
echo Все модули пройдены.
echo.
echo Модуль 1 (Выбор технологий):         %rec_tech%
echo Модуль 2 (Уровень ревьюера):         %reviewer_level% (точность %percentage%%%, очки: %points%)
echo Модуль 3 (Победитель анализа WSM):    %wsm_winner%
echo.

(
echo === ИТОГОВЫЙ ОТЧЁТ СИСТЕМЫ ===
echo Вариант 3: Выбор мессенджера для корпоративной связи
echo.
echo Модуль 1 - Рекомендация по выбору технологии: %rec_tech%
echo   Баллы профиля: Slack=%score_slack%, Mattermost=%score_mattermost%, Rocket.Chat=%score_rocketchat%
echo Модуль 2 - Уровень ревьюера: %reviewer_level%
echo   Правильных ответов: %correct% из %total% ^(%percentage%%%%^), очки: %points%
echo Модуль 3 - Победитель сравнительного анализа ^(WSM^): %wsm_winner%
echo   Взвешенные баллы: Slack=%score_s%, Mattermost=%score_m%, Rocket.Chat=%score_r%
) > "%~dp0report.txt"

echo Результаты сохранены в файл report.txt
echo.
pause
goto menu
```

**Ключевые участки кода:**

* Использование `call` сохраняет общее окружение переменных, благодаря чему `lab_system.bat` получает значения `rec_tech`, `reviewer_level`, `percentage`, `points` и `wsm_winner` из дочерних скриптов.
* Блок перенаправления `( ... ) > "%~dp0report.txt"` записывает итоговый отчёт в ту же папку, где расположен `lab_system.bat`.

## 4. Скриншоты работы каждого модуля в отдельности

### Модуль 1 (`chapter1.bat`)
[chapter1.png]

### Модуль 2 (`chapter2.bat`)
[chapter2.png]

### Модуль 3 (`chapter3.bat`)
[chapter3.png]

## 5. Скриншот работы главного файла `lab_system.bat` (главное меню)
[lab_system_menu.png]


## 6. Скриншот прохождения всех трёх модулей последовательно (пункт 4)
[lab_system_report.png]


## 7. Описание работы интегрированной системы

* **Диалоги и вопросы в модулях:**
  * В `chapter1.bat` задавались 4 вопроса о масштабе команды (20–100 человек), хранении данных (On-Premise), бюджете и уровне DevOps-подготовки.
  * В `chapter2.bat` было предложено 4 фрагмента кода на Python с типичными дефектами при разработке корпоративных ботов и вебхуков.
  * В `chapter3.bat` пользователь распределял 100% веса между безопасностью, стоимостью владения и удобством, а затем оценивал Slack, Mattermost и Rocket.Chat по 5-балльной шкале.
* **Сформированные рекомендации:** для распределённой команды из 20 человек с высокими требованиями к безопасности и ограниченным бюджетом оптимальными вариантами выступают **Mattermost** или **Rocket.Chat** (Self-Hosted).
* **Итоговый отчёт системы:** после прохождения пункта 4 на экран вывелась сводка с рекомендацией из модуля 1, уровнем ревьюера и точностью из модуля 2, а также победителем WSM из модуля 3; эти же данные записались в `report.txt`.
* **Впечатления от работы с системой:** модульная архитектура на базе `.bat`-скриптов и команды `call` позволяет легко запускать как отдельные этапы принятия решений, так и полный цикл оценки с автоматическим сохранением результата.

## 8. Инструкция по запуску системы для другого пользователя

1. Скачайте или клонируйте репозиторий на компьютер под управлением **Windows 10 / 11**:

   ```bash
   git clone https://github.com/d89535719016-rgb/lab2-messenger-decision-system.git
   ```

2. Откройте папку проекта и убедитесь, что файлы `lab_system.bat`, `chapter1.bat`, `chapter2.bat` и `chapter3.bat` находятся в одном каталоге.
3. Запустите `lab_system.bat` двойным кликом левой кнопки мыши (или через командную строку `cmd.exe`).
4. Выберите пункт `4` для последовательного прохождения всех модулей и создания файла `report.txt`, либо запускайте модули по отдельности (пункты `1`–`3`).
