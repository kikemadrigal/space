
1 ' Program space - MSX Murcia 2020'
1 ' MSX Basic and ensambler Z80'

1 ' Variables
1 '------------'
1 ' Screen: 
1 ' Player: px py pw ph pd pu pv pe pc
1 ' Enemy: 
1 ' fire: 
1 ' solid objets: 
1 ' soft objets: 

1 ' Lines
1 '--------'
1 ' Splash screen: 40'
1 ' Screen 1: 80'
1 ' Game over: 900'
1 ' General rutines: '
1 '     Renderer: 2000 '
1 '     Collision system: 
1 '         Collision enemy:'
1 '         Collision solid block'
1 '     Input capture system'
1 '------------------------------------'
1 '     Pantalla de selección 
1 '------------------------------------'

20 'clear 500
30 goto 1000 
1 '-----------------------------------------------------'
1 'Subrutina cargar sprites y colores sprites pantallas'
1 '-----------------------------------------------------'
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

1 ' borramos la pantalla y quitamos las letras de las teclas de función'
1000 screen 0:cls:key off
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
1 ' Le decimos que limpie la zona de los sprites para que no salga la franja
1 ' donde se definen los sprites que justa va desde 212 px a 256px
1 ' La rutina 69 está defina en la bios ver: http://map.grauw.nl/resources/msxbios.php
1100 defusr=&H69:x=usr(0)
1 ' Le quitamos la parte sucia a la page 0'
1110 COPY(0,0)-(255,256-212),0 TO (0,212),0 
1 ' y la copiamos a la page 1'
1115 'COPY(0,0)-(255,212),0 TO (0,0),1
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
1 '   Sistema de renderer
1 ' ----------------------'
    1' Inicio blucle
        1 ' hay que hacer esta paranoia de for con si=screen increment para mover la pantalla'
        2000 for si=255 to 0 step -1
            2005 'if si mod 5=0 then gosub 9900
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
    3010 'if pc=10 then interval off: close: gosub 700
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

1 'Rutina comprobar colisiones https://developer.mozilla.org/es/docs/Games/Techniques/2D_collision_detection'
    1 ' Rutina colisión disparo con player'
    1 ' colosión arriba'
    5000 IF POINT(px,py)=14 OR POINT(px+15,py)=14 THEN py=py+2
    1 ' arriba a la izquierda'
    5020 IF POINT(px,py+16)=14 OR POINT(px+15,py+16)=14 then py=py-2
    1 ' Rutina colisiones disparo'
    5040 if px < dx(1) + dw(1) and  px + pw > dx(1) and py < dy(1) + dh(1) and ph + py > dy(1) then play "t230o3d"
    5050 if ex < dx(0) + dw(0) and  ex + ew > dx(0) and ey < dy(0) + dh(0) and eh + ey > dy(0) then play "t230o4a"
5070 return








1 ' ----------------------' 
1 '   Mostrar información
1 ' ----------------------'
1 ' Pintamos un rectangulo en la parte superior de la pantalla', color 14 gris claro, bf es un rectangulo relleno y mostramos las caputras
    7000 'sprite 60,(),15,60
7050 return










































1 ' ------------------------------------------------------------------------------'
1 ' -------------------------Rutinas player --------------------------------------'
1 ' ------------------------------------------------------------------------------'
1 ' Inicializacion del personaje
    1 ' parámteros personaje, posición px=x,py= posición eje y, pw=ancho del sprite ph=alto
    1 ' pd=dirección arriba ^ 1, derecha > 3, abajo v 5, izquierda < 7
    1 ' pu=player up/salto'
    1 ' pv=velocidad, pe=energia,  pc=caputras 
    8000 let px=100: let py=h-64: let pw=16: let ph=16: let pd=3: let pu=0: let pv=10: let pe=100: let pc=0
    1 ' variables para manejar los sprites, 
    1 ' ps=payer sprite, lo cremaos con el spritedevtools en desdde 1 al 9, para cambiarle el sprite según la tecla que pulsemos
    1 ' pp=player plano; para cambiarlo en el plano osprite paraq ue de la sención de movimento
    1 ' player incremento, hay que sumarle eto a la posición y del player para que no le afecte el scroll'
    8010 let ps=0: let pp=1
8020 return


1 '------------------------'
1 'Subrutina actualizar player - sistema de scroll'
1 '------------------------'
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
    8320 'gosub 7000
8330 return
 1 ' Mover izquierda'
    8400 px=px-pv
    8410 if px<0 then px=0
    8420 'gosub 7000
8430 return
1 ' Mover arriba
    1 ' con pu le decimos que está saltando, al tocas la tierra volveremos a poner pu=0'
    8500 py=py-pv
    1 ' com esto evitamos que el player salga de la pantalla'
    8510 if py<=0 then py=0
    8520 'gosub 7000
8530 return
1 ' Mover abajo'
    8600 py=py+pv
    8610 if py>200 then py=200
    8620 'gosub 7000
8630 return

















1 ' ------------------------------------------------------------------------------'
1 ' -------------------------Rutinas enemy --------------------------------------'
1 ' ------------------------------------------------------------------------------'
1 ' Inicializacion del personaje
    1 ' ec=enemigo contador, variable utilizada para que cada cierto tiempo dispare'
    9000 let ex=10: let ey=0: let ew=16: let eh=16: let ev=10: let ec=0
9010 return


1 '------------------------' 
1 'Subrutina actualizar enemy'
1 '------------------------'
    9100 ex=ex+ev
    1 ' Si la ex es mayor que 200 o menor que 4 se invierte la velocidad y Le cambiamos la posición y'
    9120 if ex>200 or ex<4 then ev=-ev :ey=rnd(-time)*100
    9130 put sprite 2,(ex,(ey+si)),,2
9160 return






















1 ' ------------------------------------------------------------------------------'
1 ' -------------------------Rutinas disparos / fire --------------------------------------'
1 ' ------------------------------------------------------------------------------'
    9500 dn=1
    9510 dim dx(dn),dy(dn),dw(dn),dh(dn),dv(dn),da(dn),dc(dn)
    9520 for i=0 to dn
        9530 dx(dn)=-16:dy(dn)=-40:dw(dn)=16:dh(dn)=16:dv(dn)=10:da(dn)=0:dc(dn)=0
    9540 next i
    9550 'put sprite 3,(-10,-10),,3
9560 return

1 ' Asignar disparo player
    9600 strig(0) off: beep
    9610 dx(0)=px+8: dy(0)=py: da(0)=1
9620 return
1 ' Adignar disparo enemigo'
    9630 dx(1)=ex: dy(1)=ey: da(1)=1
9640 return 


1' actualizar disparo
    9700 dc(1)=dc(1)+1
    9710 if dc(1) mod 5=0 and da(1) <> 1 then gosub 9630
    9720 if da(0)=1 then dy(0)=dy(0)-10
    9730 if da(1)=1 then dy(1)=dy(1)+dv(1)
    9740 if dy(0)>212 or dy(0)<-16 then dy(0)=-40: da(0)=0: strig(0) on
    9750 if dy(1)>212 or dy(1)<-16 then dy(1)=-40: da(1)=0
    9760 put sprite 3,(dx(0),(dy(0)+si)),15,3
    9770 put sprite 4,(dx(1),(dy(1)+si)),15,3
9780 return







1 '-----------------------------------------------------------------'
1 '---------------------Objetos sólidos------------------------------'
1 '-----------------------------------------------------------------'
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
    10010 let si=0
    1 ' contador de posición y scroll'
    10020 let sy=255:sc=0
10030 return

1 ' carga de las pages de la pantalla 1'
    10220 BLOAD"SCR1P1.SC5",S,32768 
    10230 color=restore
10250 return

1 ' Carga de sprites'
    10300 bload "rutinas.bin"
    10310 defusr=50000
    10320 a=usr(0)
10330 return

1 ' Pintar pantalla page o'
10400 copy (0,0)-(255,211),1 to (0,0),0
10410 return

1 ' ----------------------'
1 '   Sistema de scroll pantalla 1
1 ' ----------------------'
    1 ' Inicia scroll
    10500 '_turbo on(sy)
    10510 if sy<=0 then sy=255
    10520 sy=sy-1
    10560 COPY(0,sy)-(256,212-30),1 TO (0,30),0
    10570 '_turbo off
10580 return


1' Catgar bloque en pantalla si el screen contador es 255
    10600 sc=sc+1
    10610 if sc=256 then gosub 9900:sc=0
10620 return




























1 '-----------------------------------------------------'
1 'Esta sección está imutizada es solo para pruebas de velocidad
1 '-----------------------------------------------------'
    33000 s=base(29)
    1' 8 Es el número de sprites que tenemos dibujados
    33005 for sp=0 to 3
        33006 a$=""
        33010 for i=0 to (32)-1
            33020 read a
            33030 'vpoke s+i,a
            33035 a$=a$+chr$(a)
        33040 next i
        33045 sprite$(sp)=a$
    33046 next sp
    33050 DATA &H00,&H00,&H00,&H30,&H30,&H30,&H30,&H3F
    33060 DATA &H30,&H30,&H30,&H3F,&H3F,&H1F,&H07,&H03
    33070 DATA &H00,&H00,&H00,&H0C,&H0C,&H0C,&H0C,&HFC
    33080 DATA &H0C,&H0C,&H0C,&HFC,&HFC,&HFC,&HF0,&HE0
    33090 DATA &H30,&H30,&H70,&H91,&H91,&H91,&H93,&H9F
    33100 DATA &H9F,&H9F,&H80,&HBF,&H8F,&H67,&H33,&H30
    33110 DATA &H08,&H0C,&H0E,&H89,&H89,&H89,&HC9,&HF9
    33120 DATA &HF9,&HF9,&H01,&HFD,&HF1,&HE6,&HCC,&H0C
    33130 DATA &H00,&H00,&H18,&H08,&H0C,&H04,&H1D,&H02
    33140 DATA &H0F,&H07,&H4B,&H18,&H13,&H0E,&H38,&H20
    33150 DATA &H00,&H00,&H00,&H8C,&H98,&HB0,&H20,&H80
    33160 DATA &H00,&H00,&H48,&H40,&HEC,&H36,&H12,&H00
    33170 DATA &H80,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    33180 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    33190 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    33200 DATA &H00,&H00,&H00,&H00,&H00,&H00,&H00,&H00
    1' Rellenamos la tabla de colores del sprite 0 

    33710 for sp=0 to 3
        33720 a$=""
        33800 for i=0 to (16)-1
            33810 read a
            33820 'vpoke &h7400+i, a
            33825 a$=a$+chr$(a)
        33830 next i
        33835 color sprite$(sp)=a$
    33836 next sp
    33840 DATA &H07,&H07,&H07,&H07,&H07,&H07,&H07,&H07
    33850 DATA &H07,&H07,&H07,&H07,&H07,&H08,&H08,&H0A
    33860 DATA &H0E,&H0E,&H0E,&H0E,&H0E,&H0E,&H0E,&H0E
    33870 DATA &H0E,&H0E,&H0E,&H0E,&H0E,&H0E,&H0E,&H0E
    33880 DATA &H08,&H08,&H08,&H08,&H08,&H08,&H08,&H0B
    33890 DATA &H0A,&H0A,&H08,&H08,&H08,&H08,&H08,&H08
    33900 DATA &H0A,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
    33910 DATA &H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F,&H0F
33920 return
