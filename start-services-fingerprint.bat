@echo off
echo Menjalankan Presention Services...

cd c:\laragon\www\presention

:: Start Laravel Web Server utk presention
start "Presention Web Server" php artisan serve --host=0.0.0.0 --port=8000

echo Services berhasil dijalankan!
exit
