🔧 Reparar el Cargador de Arranque de Windows tras Eliminar Ubuntu
Este proyecto proporciona un sencillo script en Batch para reparar el MBR (Master Boot Record) de Windows después de desinstalar Ubuntu. Sigue esta guía para eliminar completamente Ubuntu de tu equipo y asegurarte de que tu sistema arranque solo con Windows.

🚀 **Pasos para Eliminar Ubuntu y Reparar el MBR**

1️⃣ **Eliminar las particiones de Ubuntu**
Antes de ejecutar el script, **elimina manualmente las particiones de Ubuntu**:

Abre la herramienta Administración de discos en Windows:
Presiona Win + R, escribe diskmgmt.msc, y presiona Enter.
Identifica las particiones asociadas a Ubuntu (generalmente, una partición EXT4 y una partición de intercambio "swap").
Haz clic derecho en cada partición de Ubuntu y selecciona Eliminar volumen.
(Opcional) Fusiona el espacio no asignado con otras particiones de Windows.

2️⃣ **Ejecutar el script para reparar el MBR**
Descarga el archivo repair_windows_mbr.bat desde este repositorio.
Haz clic derecho en el archivo descargado y selecciona Ejecutar como administrador.
Sigue las instrucciones que aparecen en la ventana de comandos.
El script ejecutará los siguientes comandos esenciales para reparar el MBR de Windows:

bootrec /fixmbr - Repara el MBR.
bootrec /fixboot - Crea un nuevo sector de arranque.
bootrec /scanos - Escanea sistemas operativos instalados.
bootrec /rebuildbcd - Reconstruye el almacén de datos de configuración de arranque (BCD).

3️⃣ **Verifica que el sistema arranca correctamente**
Reinicia tu computadora y asegúrate de que Windows se inicie sin problemas. Si todo está en orden, ¡Ubuntu ha sido eliminado exitosamente y tu cargador de arranque está reparado! 🎉

🛠️ **Detalles del Script**

```shell
@echo off
echo Este script reparará el cargador de arranque de Windows.
echo Asegúrate de haber eliminado las particiones de Ubuntu manualmente desde la Administración de discos.
pause

echo Ejecutando comandos de reparación del MBR...

powershell -Command "Start-Process cmd -ArgumentList '/c bootrec /fixmbr && bootrec /fixboot && bootrec /scanos && bootrec /rebuildbcd' -Verb RunAs"

echo El cargador de arranque de Windows ha sido reparado exitosamente.
pause
```

⚠️ **Precauciones**
Realiza un respaldo: Asegúrate de respaldar tus datos importantes antes de eliminar particiones o ejecutar este script.
Usa permisos de administrador: El script requiere privilegios de administrador para ejecutar los comandos correctamente.
Confirma las particiones: Elimina solo las particiones relacionadas con Ubuntu.

🛡️ **Soporte**
Si tienes problemas o dudas, abre un Issue en este repositorio y estaré encantado de ayudarte.
