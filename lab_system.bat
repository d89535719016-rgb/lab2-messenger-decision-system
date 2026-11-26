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
