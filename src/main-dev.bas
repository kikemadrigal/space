
1 ' Program space - MSX Murcia 2020'
1 ' MSX Basic and ensambler Z80'

1 ' Si estás en visual stido code, pulsa Ctrl+f, pega la línea a buscar y pulsa f3 para siguiente'
1 ' Variables
1 '------------'
1 ' Screen: w, h, si, sc
1 ' Player: px py pw ph pd pv pe pc
1 ' Enemy: 
1 ' fire: 
1 ' solid objets: 
1 ' soft objets: 


1 ' Lines
1 '--------'
1 ' Selection Screen: 100
1 ' Winning Screen: 300
1 ' Game over: 500
1 ' Screen 1'
1 ' General rutines: '
1 '     Renderer: 2000 '
1 '     Check energy: 3000'
1 '     Input system: 4000'
1 '     Collision system: 5000: 
1 '         Collision enemy:'
1 '         Collision solid block'
1 '     HUD system 7000'
1 ' Pler rutines: 8000'
1 '     initialize player: 8000
1 '     update palyer: 8100
1 ' Enemy rutines: 9000'
1 '     Iniciliace enemy: 9000'
1 '     Update enemy: 9100'
1 ' Fire rutines: 9500'
1 '     Inicialize fires: 9500'
1 '     Update fires: 9700'
1 ' Solid objets rutines: 9900'
1 ' Screen 1 rutines: 10000'







1 '------------------------------------'
1 '     Pantalla de selección 
1 '------------------------------------'
100 screen 0:key off:color 15,1,1
110 locate 2,6: print "Presione espacio para empezar"
120 locate 12,7:print "MSX Murcia"
150 if not strig(0) then 150 else goto 1000 

1 '------------------------------------'
1 '     Pantalla Ganadora'
1 '------------------------------------'
1' Dibujamos el texto de la pantalla game over
300 screen 0
310 print "has ganado"
320 goto 100
1 ' Otra partida s/n,es posible borrar la interrogación con for i=0 to 7: vpoke base(2)+(63*8)+i,0: next i
330 input "¿Otra partida S/N ";a$
340 if inkey$="s" then 100
350 if inkey$="n" then print "adios": for i=0 to 500: next i:cls:end


1 '------------------------------------'
1 '     Pantalla final / Game over '
1 '------------------------------------'
1' Dibujamos el texto de la pantalla game over
500 screen 0
1 ' Otra partida s/n,es posible borrar la interrogación con for i=0 to 7: vpoke base(2)+(63*8)+i,0: next i
540 locate 0,10
550 print " Te han matado!!"
560 input "¿Otra partida S/N ";a$
340 if inkey$="s" then 100
350 if inkey$="n" then print "adios": for i=0 to 500: next i:cls:end


1 '------------------------------------'
1 '     Pantalla 1 / Screen 1 ' 
1 '------------------------------------'

1 ' borramos todas las variables,borramos la pantalla y quitamos las letras de las teclas de función'
1000 clear:screen 0:cls:key off
1 ' Color letras blancas, fondo azul oscuro'
1010 color 15,1,1: defint a-z
1020 locate 10,5
1030 print "Level 1"
1040 locate 0,10
1050 print "Llega hasta la nave central"
1 ' ponemos la pantalla buena'
1060 screen 5,2
1 ' Creamos un canal para poder escribir'
1070 open "grp:" for output as #1
1 ' Cargamos las pages de la pantalla 1'
1080 gosub 10220
1 ' Dibujamos la page 0 que es la que se muestra'
1090 gosub 10400
1 ' Le decimos que limpie la zona de los sprites para que no salga la franja sucia
1 ' donde se definen los sprites que va justo desde 212 px a 256px
1 ' La rutina 69 está defina en la bios ver: http://map.grauw.nl/resources/msxbios.php
1100 defusr=&H69:x=usr(0)
1 ' Le quitamos la parte sucia a la page 0'
1110 COPY(0,0)-(255,256-212),0 TO (0,212),0 
1 ' Cargamos todos los sprites de la pantalla 1'
1120 gosub 10300
1 ' Esto es solo para pruebas de velocidad'
1130 'gosub 33000
1 ' Inicializamos las variables de la pantalla 1'
1140 gosub 10000
1' Inicializamos el player
1150 gosub 8000
1' Inicializamos enemigos
1160 gosub 9000
1 'Inicializamos el disparo'
1170 gosub 9500
1180 strig(0) on
1 ' Enlazamos la interrupción de los disparos al plarer cuando se pulse el espacio'
1190 on strig gosub 9600
1 ' Enlazamos las interrupciones de la colision de los sprites
1200 'sprite on
1210 'on sprite gosub 8200
1 ' Vamos a meter algunos blques en la pantalla'
1220 gosub 9910
1 ' Sistema de renderer'
1230 gosub 2000


1 '-----------------------------------------------------------------'
1 '---------------------General rutines------------------------------'
1 '-----------------------------------------------------------------'

1 ' ----------------------'
1 '   Sistema de renderer / render system
1 ' ----------------------'
    1' Inicio blucle
        1 ' Hay que hacer esta paranoia de for con si=screen increment para mover la pantalla'
        2000 for si=255 to 0 step -1
            2010 VDP(24)=si
            1 ' Cargar bloques en la pantalla
            2020 gosub 10600
            1 ' Comprobar colosiones'
            2030 gosub 5000
            1 ' Comprobar vidas/energía /check live/energy '
            2040 gosub 3000
            1 '' Actualizar player'
            2050 gosub 8100
            1 ' Actualizar enemigos'
            2060 gosub 9100
            1 ' Actualizar disparos' 
            2070 gosub 9700 
            1 ' Sistema de input Cursores / joystick
            2080 gosub 4000 
            1 ' mostrar informacion'
            2090 'gosub 7000
        2100 next si
    2110 goto 2000
2120 return



1 ' Chequeo energia y capturas player' 
    1 ' Si se termina la energía vamos a la rutina de finalización pantalla 1'
    3000 if pe=0 then gosub 500
3040 return
1 ' ----------------------'
1 'Subrutina captura movimiento joystick / cursores y boton de disparo'
1 ' ----------------------'
    1 ' stick(0) devuelve el cursor pulsado: 1 Arriba, 2 arriba derecha, 3 derecha, 4 abajo derecha, 5 abajo, 6 abajo izquierda, 7 izquierda, 8 izquierda arriba
    4000 on stick(0) gosub 8500,4000,8300,4000,8600,4000, 8400
4010 return


1 ' ----------------------'
1 '   Sistema de colisiones
1 ' ----------------------'
    1 ' Colosión arriba - detección color gris'
    5000 IF POINT(px,py)=14 OR POINT(px+15,py)=14 THEN py=py+2
    1 ' arriba abajo - detección color gris'
    5020 IF POINT(px,py+16)=14 OR POINT(px+15,py+16)=14 then py=py-2
    1 ' Rutina colisiones disparo https://developer.mozilla.org/es/docs/Games/Techniques/2D_collision_detection''
    5040 if px < dx(1) + dw(1) and  px + pw > dx(1) and py < dy(1) + dh(1) and ph + py > dy(1) then play "t230o3d"
    5050 if ex < dx(0) + dw(0) and  ex + ew > dx(0) and ey < dy(0) + dh(0) and eh + ey > dy(0) then play "t230o4a"
5070 return








1 ' ----------------------' 
1 '   Barra de estado / HUD System (ver https://es.wikipedia.org/wiki/HUD_(inform%C3%A1tica))
1 ' ----------------------'
1 ' Mostraremos los sprites cargados en la page 2 que son los números que aparecen arriba con la información
    7000 'sprite 60,(),15,60
7050 return










































1 ' ------------------------------------------------------------------------------'
1 ' -------------------------Rutinas player --------------------------------------'
1 ' ------------------------------------------------------------------------------'
1 ' Inicializacion del personaje
    1 ' parámteros personaje
    1 ' px=posición ,py= posición eje y, pw=ancho del sprite, ph=alto
    1 ' pd=dirección arriba ^ 1, derecha > 3, abajo v 5, izquierda < 7
    1 ' pv=velocidad, pe=energia,  pc=caputras 
    8000 let px=100: let py=h-64: let pw=16: let ph=16: let pd=3: let pv=10: let pe=100: let pc=0
    1 ' variables para manejar los sprites:
    1 ' ps=payer sprite, lo cremaos con el spritedevtools 
    1 ' pp=para ponerle el mismo plano a otros sprites 
    8010 let ps=0: let pp=1
8020 return


1 '------------------------'
1 'Subrutina actualizar player - sistema de scroll'
1 '------------------------'
    1 ' Mi sprite está compuesto por 2 sprites que se mueve a la vez en las mismas coordenadas'
    8100 put sprite 0,(px,py+si),,0
    8110 put sprite 1,(px,py+si),,1
8160 return


1 '------------------------'
1 ' Cambiar sprite player explota
1 '------------------------'
    8200 'put sprite 0,(px,py),,2
    8210 beep 'PLAY"O6V9C32","O5V7C32"
    8220 pe=0
8220 return

1 '------------------------'
1 'Subrutinas mover '
1 '------------------------'
1 'pd=dirección arriba ^ 1, derecha > 3, abajo v 5, izquierda < 7
1 'Mover derecha
    1' 1 se suma a la posición x la velocidad del player
    8300 px=px+pv
    8310 if px>=w-pw then px=w-pw
8330 return
 1 ' Mover izquierda'
    8400 px=px-pv
    8410 if px<0 then px=0
8430 return
1 ' Mover arriba
    1 ' con pu le decimos que está saltando, al tocas la tierra volveremos a poner pu=0'
    8500 py=py-pv
    1 ' com esto evitamos que el player salga de la pantalla'
    8510 if py<=0 then py=0
8530 return
1 ' Mover abajo'
    8600 py=py+pv
    8610 if py>200 then py=200
8630 return

















1 ' ------------------------------------------------------------------------------'
1 ' -------------------------Rutinas enemy --------------------------------------'
1 ' ------------------------------------------------------------------------------'
1 ' Inicializacion del personaje
    1 ' ex= enemigo posición x, ey= enemigo posición y, ew=enemigo ancho, eh=enemigo alto'
    1 ' ev= enemigo velocidad'
    1 ' ec=enemigo contador, variable utilizada para que cada cierto tiempo dispare'
    9000 let ex=10: let ey=0: let ew=16: let eh=16: let ev=10: let ec=0
9010 return


1 '------------------------' 
1 'Subrutina actualizar enemy'
1 '------------------------'
    1 ' le vamos sumando la velocidd, la velocidd se invertirá cuando toque los extremos de la pantalla'
    9100 ex=ex+ev
    1 ' Si la ex es mayor que 200 o menor que 4 se invierte la velocidad y Le cambiamos la posición y'
    9120 if ex>200 or ex<4 then ev=-ev :ey=rnd(-time)*100
    1 ' pintamos al enemigo'
    9130 put sprite 2,(ex,(ey+si)),,2
9160 return






















1 ' ------------------------------------------------------------------------------'
1 ' -------------------------Rutinas disparos / fires --------------------------------------'
1 ' ------------------------------------------------------------------------------'
    1 ' Crearemos 2 disparos, el dx es el disparo del player, el dx es el del enemigo'
    1 ' dv es la velocidad de los disparos, da es si el disparo está activo'
    1 ' dc es una variable utilizada para que enemigo dispare de vez en cuando'
    9500 dn=1
    9510 dim dx(dn),dy(dn),dw(dn),dh(dn),dv(dn),da(dn),dc(dn)
    9520 for i=0 to dn
        9530 dx(dn)=-16:dy(dn)=-40:dw(dn)=16:dh(dn)=16:dv(dn)=10:da(dn)=0:dc(dn)=0
    9540 next i
9560 return

1 ' Asignar disparo player
    1 ' cuando se pulse la barra espaciador (declarada al principio), vendrá a la linea 960'
    1 ' Desactivamos el disparo para que no se pueda volver a pulsar la barra'
    9600 strig(0) off: beep
    1 ' Le ponemos que las corrdenadas del disparo sean las del personaje, el +8 es para que salga centrado'
    9610 dx(0)=px+8: dy(0)=py: da(0)=1
9620 return

1 ' Adignar disparo enemigo'
    1 ' Le ponemos a este disparo la posición del enemigo'
    1 ' da(0)=1, es para ayudarnos a no disparar otra vez, ver línea 9710
    9630 dx(1)=ex: dy(1)=ey: da(1)=1
9640 return 


1' actualizar disparo
    1 ' Icrementamos el contador del disparo'
    9700 dc(1)=dc(1)+1
    1 ' Si el resto de dividir contador entre 5 es 0 y el disparo está activo le asignamos rl disparo'
    9710 if dc(1) mod 5=0 and da(1) <> 1 then gosub 9630
    1 ' Si los disparos está actimos, le restamos la posición y al disparo del player y la restamos al enemigo'
    9720 if da(0)=1 then dy(0)=dy(0)-10
    9730 if da(1)=1 then dy(1)=dy(1)+dv(1)
    1 ' Controlando los límites'
    9740 if dy(0)>212 or dy(0)<-16 then dy(0)=-40: da(0)=0: strig(0) on
    9750 if dy(1)>212 or dy(1)<-16 then dy(1)=-40: da(1)=0
    1 ' Dibujando, el +si es para que no se mueva el sprite por la paranoia del scroll'
    9760 put sprite 3,(dx(0),(dy(0)+si)),15,3
    9770 put sprite 4,(dx(1),(dy(1)+si)),15,3
9780 return







1 '-----------------------------------------------------------------'
1 '---------------------Objetos sólidos------------------------------'
1 '-----------------------------------------------------------------'
    1 ' Este código se llamará desde el renderer->que llama a otra rutina que suma el screen counter
    1 ' si este screen counter llega a 250 (al final de la pantalla se vuelva a dibujar la page 1
    1 ' y pintamos unos lines'
    9900 COPY(0,0)-(255,212),1 TO (0,0),0
    9910 line (100,0)-(rnd(-time)*200,rnd(-time)*20),14,bf
    9920 line (10,0)-(rnd(-time)*200,rnd(-time)*20),14,bf
    9920 line (200,0)-(rnd(-time)*200,rnd(-time)*20),14,bf
    9930 line (250,0)-(256,rnd(-time)*20),14,bf
    9940 line (0,0)-(10,rnd(-time)*20),14,bf
9960 return







1 ' ---------------------------------------------------------------------------------------'
1 '                                   Pantalla 1
1 ' --------------------------------------------------------------------------------------'
1' Inicialización pantalla 1
    1 ' Parametros pantalla
    10000 let w=256: let h=212 
    1 ' si= screen incremento,variable para saber la posición de la pantalla que se mueve
    1 ' sc= screen count, variable utilizada para hacer copyes de dibujos bonitos de otras pages o lines '
    10010 let si=0: sc=0
    1 ' Contador de posición y scroll'
    10020 'let sy=255
10030 return

1 ' Carga del archivo scr1p1 para ponerloen la page 1 
    10220 BLOAD"SCR1P1.SC5",S,32768 
    10230 color=restore
10250 return

1 ' Carga de sprites'
    1 ' Cargamos los sprites con las rutinas que están en el archivo rutinas.asm->rutinas.bin'
    10300 bload "rutinas.bin"
    10310 defusr=50000
    10320 a=usr(0)
10330 return

1 ' Pintar pantalla page o'
10400 copy (0,0)-(255,211),1 to (0,0),0
10410 return

1 ' ----------------------'
1 '   2º  Sistema de scroll pantalla 1 - más lento
1 ' ----------------------'
    1 ' Inicia scroll
    10500 'if sy<=0 then sy=255
    10520 'sy=sy-1
    10560 'COPY(0,sy)-(256,212-30),1 TO (0,30),0
10580 return


1' Cargar bloque (que es un line) en pantalla si el screen contador es 255
    10600 sc=sc+1
    10610 if sc=250 then gosub 9900:sc=0
10620 return




























1 '-----------------------------------------------------'
1 'Esta sección está imutizada es solo para pruebas de velocidad
1 '-----------------------------------------------------'
    1 ' Si estás es visual studio code puedes pulsar Ctrl+Alt+d y con las flechas de los cursores hacer un multicursor '
    1' 1' 8 Es el número de sprites que tenemos dibujados 1
    1' 33000 s=base(29)
    1' 33005 for sp=0 to 3
    1'     33006 a$=""
    1'     33010 for i=0 to (32)-1
    1'         33020 read a
    1'         33030 'vpoke s+i,a
    1'         33035 a$=a$+chr$(a)
    1'     33040 next i
    1'     33045 sprite$(sp)=a$
    1' 33046 next sp
    1' 33050 DATA &H00,&H00,&H00,&H30,&H30,&H30,&H30,&H3F
    1' 33060 DATA &H30,&H30,&H30,&H3F,&H3F,&H1F,&H07,&H03
    1' 33070 DATA &H00,&H00,&H00,&H0C,&H0C,&H0C,&H0C,&HFC
    1' 33080 DATA &H0C,&H0C,&H0C,&HFC,&HFC,&HFC,&HF0,&HE0
    1' 33090 DATA &H30,&H30,&H70,&H91,&H91,&H91,&H93,&H9F
    1' 33100 DATA &H9F,&H9F,&H80,&HBF,&H8F,&H67,&H33,&H30
    1' 33110 DATA &H08,&H0C,&H0E,&H89,&H89,&H89,&HC9,&HF9
    1' 33120 DATA &HF9,&HF9,&H01,&HFD,&HF1,&HE6,&HCC,&H0C
    1' 33130 DATA &H00,&H00,&H18,&H08,&H0C,&H04,&H1D,&H02
    1' 33140 DATA &H0F,&H07,&H4B,&H18,&H13,&H0E,&H38,&H20
    1' 33150 DATA &H00,&H00,&H00,&H8C,&H98,&HB0,&H20,&H80
    1' 33160 DATA &H00,&H00,&H48,&H40,&HEC,&H36,&H12,&H00
    1' 33170 DATA &H80,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1' 33180 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1' 33190 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1' 33200 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1' 1' Rellenamos la tabla de colores del sprite 0 
1' 
    1' 33710 for sp=0 to 3
    1'     33720 a$=""
    1'     33800 for i=0 to (16)-1
    1'         33810 read a
    1'         33820 'vpoke &h7400+i, a
    1'         33825 a$=a$+chr$(a)
    1'     33830 next i
    1'     33835 color sprite$(sp)=a$
    1' 33836 next sp
    1' 33840 DATA &H07,&H07,&H07,&H07,&H07,&H07,&H07,&H07
    1' 33850 DATA &H07,&H07,&H07,&H07,&H07,&H08,&H08,&H0A
    1' 33860 DATA &H0E,&H0E,&H0E,&H0E,&H0E,&H0E,&H0E,&H0E
    1' 33870 DATA &H0E,&H0E,&H0E,&H0E,&H0E,&H0E,&H0E,&H0E
    1' 33880 DATA &H08,&H08,&H08,&H08,&H08,&H08,&H08,&H0B
    1' 33890 DATA &H0A,&H0A,&H08,&H08,&H08,&H08,&H08,&H08
    1' 33900 DATA &H0A,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    1' 33910 DATA &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
33921' 0 return
