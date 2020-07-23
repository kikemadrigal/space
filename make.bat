
rem para desactivar los mensajes de los programas
rem @echo off
rem sjasm (http://www.xl2s.tk/) es un compilador de ensamblador z80 que puedo convertir tu código ensamblador en los archivos binarios.rom y .bin
rem necesitamos el .bin de la pantalla de carga y del reproductor de música
start /wait tools/sjasm/sjasm.exe src/scloader.asm
start /wait tools/sjasm/sjasm.exe src/rutinas.asm
rem start /wait tools/sjasm/sjasm.exe src/music.asm
move /Y scloader.bin ./src
move /Y rutinas.bin ./src
rem move /Y music.bin ./src
rem del /F src/scloader.lst
rem del /F src/music.lst


rem /*******borrando comentarios y añadir números de líneas*******/
rem para ejcutar este comando necesitas tener java jre instalado
start /wait java -jar tools/deletecomments/deletecomments.jar src/main-dev.bas



rem /************Diskmanager******************/
rem Añadiendo archivos al .dsk, tenemos que crear antes el archivo disco.dsk con el programa disk manager
rem para ver los comandos abrir archivo DISKMGR.chm
rem AUTOEXEC.BAS es un archivo basic con el comando bload que hará que se autoejecute el main.bas
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/AUTOEXEC.BAS 
rem añadimos el xbasic para que el código vaya más rápido https://www.konamiman.com/msx/msx2th/kunbasic.txt
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/xbasic.bin
rem main.bas contiene mi código fuente
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/main.bas
rem le metemos el archivo binario con la pantalla de carga
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/scloader.bin
rem rutinas para cargar sprites
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/rutinas.bin
rem le metemos el archivo binario con la música
rem start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/music.bin




rem pantalla1 page 0
start /wait tools/Disk-Manager/DISKMGR.exe -A -F -C bin/main.dsk src/SCR1P1.SC5




rem /***********Abriendo el emulador***********/
rem Abriendo con openmsx, presiona f9 al arrancar para que vaya rápido
start /wait emulators/openmsx/openmsx.exe -machine Philips_NMS_8255 -diska bin/main.dsk
rem Abriendo con FMSX https://fms.komkon.org/fMSX/fMSX.html
rem start /wait emulators/fMSX/fMSX.exe -diska main.dsk
rem copy bin\main.dsk emulators\blueMSX
rem start /wait emulators/BlueMSX/blueMSX.exe -diska main.dsk

