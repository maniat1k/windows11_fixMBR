@echo off
echo Este script reparará el cargador de arranque de Windows.
echo Asegúrate de haber eliminado las particiones de Ubuntu manualmente desde la Administración de discos.
pause

echo Ejecutando comandos de reparación del MBR...

powershell -Command "Start-Process cmd -ArgumentList '/c bootrec /fixmbr && bootrec /fixboot && bootrec /scanos && bootrec /rebuildbcd' -Verb RunAs"

echo El cargador de arranque de Windows ha sido reparado exitosamente.
pause
