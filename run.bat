@echo off
title Server Es Teh Solo - Online Ordering System
color 0A

echo ========================================================
echo   MENJALANKAN SERVER ES TEH SOLO
echo ========================================================
echo Mempersiapkan Java JDK 21 dan Apache Maven...

set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot"
set "PATH=%JAVA_HOME%\bin;D:\maven\apache-maven-3.9.9\bin;%PATH%"

echo.
echo Membuka server di http://localhost:8080/
echo Akun Admin : admin@estehsolo.com / password: admin123
echo Akun User  : budi@gmail.com     / password: user123
echo.
echo Tekan Ctrl+C di terminal ini jika ingin menghentikan server.
echo ========================================================
echo.

start http://localhost:8080/

call "D:\maven\apache-maven-3.9.9\bin\mvn.cmd" exec:java
pause
