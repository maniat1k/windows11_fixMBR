# Windows boot repair after removing Linux

Guía y utilidad conservadora para recuperar el arranque de Windows después de eliminar una instalación Linux en un equipo con arranque dual.

> **Importante:** no existe un único procedimiento válido para todos los equipos. Antes de modificar el arranque hay que distinguir **UEFI/GPT** de **Legacy BIOS/MBR**. Ejecutar comandos pensados para MBR sobre un sistema UEFI no es el procedimiento correcto.

## Antes de empezar

- Haz una copia de seguridad de los datos importantes.
- Ten disponible un medio de instalación o recuperación de Windows.
- No elimines particiones si no estás seguro de su función.
- **No elimines la EFI System Partition (ESP)** en equipos UEFI/GPT.
- Si Windows todavía inicia, confirma primero el modo de firmware y el estilo de partición.

### Identificar el escenario

En Windows puedes ejecutar `msinfo32` y revisar **Modo de BIOS**:

- `UEFI` -> normalmente corresponde a UEFI + GPT.
- `Heredado` / `Legacy` -> normalmente corresponde a BIOS + MBR.

También puedes comprobar el disco con PowerShell:

```powershell
Get-Disk | Select-Object Number, FriendlyName, PartitionStyle
```

No continúes hasta identificar correctamente el disco que contiene Windows.

## Escenario A: UEFI + GPT

Este es el escenario habitual en equipos modernos compatibles con Windows 11. **No uses `windows_mbr_fix.bat` para este caso.**

Si al eliminar Linux desapareció o quedó dañado Windows Boot Manager, utiliza el Entorno de recuperación de Windows (WinRE) o un medio de instalación de Windows.

Primero identifica la partición de Windows y la EFI System Partition. Las letras de unidad dentro de WinRE pueden ser diferentes de las usadas normalmente por Windows.

Ejemplo de inspección:

```text
diskpart
list disk
list vol
exit
```

Después de identificar correctamente ambas particiones, asigna temporalmente una letra a la ESP si fuera necesario y reconstruye los archivos de arranque con `bcdboot`. Por ejemplo, **solo si** Windows está realmente en `C:\Windows` y la ESP fue montada como `S:`:

```text
bcdboot C:\Windows /s S: /f UEFI
```

No copies ese ejemplo a ciegas: confirma las letras y particiones en tu propio entorno.

## Escenario B: Legacy BIOS + MBR

El archivo `windows_mbr_fix.bat` está destinado **exclusivamente** a este escenario.

El script:

1. exige privilegios de administrador;
2. muestra las condiciones de uso;
3. requiere confirmación explícita;
4. ejecuta `bootrec /fixmbr`, `bootrec /fixboot`, `bootrec /scanos` y `bootrec /rebuildbcd`;
5. se detiene e informa si un comando devuelve error.

Los comandos `bootrec` se utilizan normalmente desde WinRE. El script no convierte discos GPT a MBR, no elimina particiones y no debe utilizarse para intentar reparar un sistema UEFI/GPT.

## Eliminar Linux

La eliminación de particiones Linux es una operación separada de la reparación del cargador de arranque.

Desde Administración de discos (`diskmgmt.msc`) puedes identificar el espacio utilizado por Linux. **No elimines automáticamente particiones basándote únicamente en su posición o tamaño.** En particular, conserva las particiones de Windows, recuperación y la ESP.

Conviene reparar/verificar el arranque de Windows antes de reutilizar el espacio liberado.

## Validación segura

La forma preferida de validar este repositorio es una VM desechable.

### Matriz mínima

| Caso | Firmware | Disco | Resultado esperado |
| --- | --- | --- | --- |
| Legacy | BIOS | MBR | Windows vuelve a arrancar tras restaurar el boot code/BCD |
| Moderno | UEFI | GPT | El BAT no se utiliza; recuperación documentada mediante `bcdboot` |

Procedimiento sugerido:

1. crear una VM de prueba con snapshot;
2. instalar Windows con el firmware y esquema de partición del caso;
3. introducir un segundo cargador de arranque o alterar deliberadamente el arranque;
4. tomar snapshot antes de la recuperación;
5. ejecutar el procedimiento correspondiente desde WinRE;
6. reiniciar y verificar que Windows Boot Manager/Windows inicia correctamente;
7. restaurar el snapshot para repetir la prueba.

Este repositorio documenta el procedimiento, pero **no afirma una validación física o en VM que no haya sido realizada y registrada**.

## Limitaciones

Las letras de unidad, números de disco y particiones varían entre equipos y también pueden cambiar dentro de WinRE. Por ese motivo este proyecto no automatiza selección, borrado ni formateo de particiones.

BitLocker, configuraciones multi-disco y gestores de arranque personalizados requieren revisión adicional antes de modificar el arranque.

## Licencia

MIT. Consulta [LICENSE](LICENSE).
