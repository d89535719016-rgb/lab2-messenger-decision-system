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
