
1 ' Program The birds - MSX Murcia 2020'
1 ' MSX Basic and ensambler Z80'

1 ' Variables
1 '------------'
1 ' Screen: w, h, g: ancho, alto y gravedad'
1 ' Player: px,py,pw,ph,pd,ps,pp,pv,pe,pc
1 ' Enemy: ee, en, ex(en),ey(en),ew(en),eh(en),es(en),ep(en),ev(en),ec(en) '
1 ' fire: dn, dx(dn), dy(dn), dw(dn), dh(dn), da(dn), ds(dn)
1 ' solid objets: sx(sn), sy(sn),sw(sn),sh(sn)'
1 ' liquid objets: fx(num), fy(num), fw(num), fh(num)

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
1 '     Keyboard capture system'
1 '------------------------------------'
1 '     Pantalla de selección 
1 '------------------------------------'



1 '------------------------------------'
1 '     Pantalla 1 / Screen 1 ' 
1 '------------------------------------'

1 ' borramos la pantalla y quitamos las letras de las teclas de función'
80 screen 0:cls:key off
1 ' Color letras blancas, fondo azul oscuro'
90 color 15,4,4
100 locate 10,5
110 print "Level 1"
120 locate 0,10
130 print "Un pajaro lanza una caca que te mata, al otro le tienes que coger 10 veces la caca roja"
160 locate 0,21
1 ' Esto es un peueño retraso para mostrar la información de lo que va la pantalla 1'
170 for i=0 to 2000: next i

1 ' 1 necesitamos ddecirle que es screen 5 y algunas cosas más'
180 gosub 31000
1 ' Inicializcacion del personje
190 gosub 10000
1 ' Inicialización enemigos'
200 gosub 20000
1 ' inicialización disparos'
210 gosub 21500
1 ' Inicializar objetos sólidos sx(num_object), sy(num_object),sw(num_object), sh(num_object)'
220 gosub 22000
1 ' Pintar objetos sólidos'
230 gosub 23000
1 ' Volcado de datos del archivo binario a la page 1 VRAM'
240 gosub 32000
1 ' Copys de la page 1 a la page o par apintar los objetos sólidos de la pantalla level 1'
250 gosub 23000
1 ' Copys de la page 1 a la page 0 para pintar el fondo de la pantalla level 1
260 gosub 32100
1 ' Cargamos todos los sprites de la pantalla 1'
270 gosub 33000
1 ' Creamos un flujo para poder pintar en la pantalla, esto afectará a los input y print que tenga #numero'
280 open "grp:" for output as #1
1 ' Como habíamos activados las interrupciones de los intervalos de tiempo, en la pantalla 1 podemos poner que salga 1 pájaro de vez en cuando por la derecha
290 'on interval=120 gosub 21100
1 ' Subrutina mostrar información del juego'
300 gosub 7000
1 ' Cunado haya una colision de 2 sprites ve a la línea vamos a la subrutina de la línea..'
310 'on sprite gosub 5200: sprite on
1 ' Cuando se pulse la barra espaciadora ve a la línea..'
320 on strig gosub 5200
1 ' con el 0 le decimos que es la barra espaciadora y no los botones de los joystick'
330 strig(0) on
1 ' Sistema de renderer'
340 gosub 2000



1 '------------------------------------'
1 '     Pantalla Ganadora'
1 '------------------------------------'
1' Dibujamos el texto de la pantalla game over
700 screen 0
1 ' Borramos todos los arrays'
710 erase ex,ey,ew,eh,es,ep,ev,ec,ed
720 erase dx, dy, dw, dh, da, ds
730 erase sx, sy,sw,sh
1 ' Subrrutina que muestra la 1 pantalla y hace un efecto de cambio de color en cada letra'    
    740 COLOR 1,1,1:SCREEN 3
    750 OPEN "GRP:"AS#1
    760 FOR I=1 TO 10
        770 M$="Ganaste!"
        1 ' Est posicionará las letras MSX en el eje x 48 e y 24'
        780 Y=24:X=0
        790 FOR K=1 TO 2
            800 FOR J=1 TO LEN(M$)
                810 COLOR RND(1)*14+2
                812 PRESET(X,Y)
                813 PRINT#1,MID$(M$,J,1)
                814 X=X+32
            815 NEXT J
        820 M$="":Y=120:X=4
    830 NEXT K,I
    835 close #1
840 screen 0: cls: color 15,1,1
1 ' Otra partida s/n,es posible borrar la interrogación con for i=0 to 7: vpoke base(2)+(63*8)+i,0: next i
850 input "¿Otra partida S/N ";a$
860 if a$="s" or a$="S" then :goto 80
870 if a$="n" or a$="N" then print "adios": for i=0 to 500: next i:cls:end
880 goto 875


1 '------------------------------------'
1 '     Pantalla final / Game over '
1 '------------------------------------'
1' Dibujamos el texto de la pantalla game over
900 screen 0
910 erase ex,ey,ew,eh,es,ep,ev,ec,ed
920 erase dx, dy, dw, dh, da, ds
930 erase sx, sy,sw,sh
1 ' Otra partida s/n,es posible borrar la interrogación con for i=0 to 7: vpoke base(2)+(63*8)+i,0: next i
940 locate 0,10
960 print " Te han matado!!"
970 input "¿Otra partida S/N ";a$
875 close #1
980 if a$="s" or a$="S" then goto 80
990 if a$="n" or a$="N" then print "adios":for i=0 to 500: next i:cls:end
995 goto 980


990 end



























   





 
1 '-----------------------------------------------------------------'
1 '---------------------General rutines------------------------------'
1 '-----------------------------------------------------------------'

1 ' ----------------------'
1 '   Sistema de renderer
1 ' ----------------------'
    1' Inicio blucle
        1 ' Comprobar vidas/energía /check live/energy '
        2000 gosub 3000
        1 ' Actualizar player'
        2020 gosub 10500
        1 ' Actualizar enemigos'
        2030 gosub 21000
        1 ' Actualizar disparos' 
        2040 gosub 21700 
        1 ' Cursores / joystick
        2050 gosub 6000 
        1 ' Sistema de gravedad '
        2060 gosub 5100
        1 ' Comprobar colosiones'
        2070 gosub 5000
    1 ' El goto es como una especie de while para que vuelva  capturar el teclado y dibujar'
    2080 goto 2000
2090 return


1 ' Chequeo energia y capturas player'
    1 ' Si se termina la energía vamos a la rutina de finalización pantalla 1'
    3000 if pe=0 then interval off: close: gosub 900
    3010 if pc=10 then interval off: close: gosub 700
3040 return

1 ' ----------------------'
1 '   Sistema de colisiones
1 ' ----------------------'

1 'Rutina comprobar colisiones https://developer.mozilla.org/es/docs/Games/Techniques/2D_collision_detection'
    1 ' Rutina colisión disparo con player'
    5000 if dx(0) < px + pw and  dx(0) + dw(0) > px and dy(0) < py + ph and dh(0) + dy(0) > py then gosub 5200
    1 ' si el disparo es el 1 ese es la caca que hay que coger'
    5010 if dx(1) < px + pw and  dx(1) + dw(1) > px and dy(1) < py + ph and dh(1) + dy(1) > py then gosub 5300
    1 ' Rutina colision enemigo 2 con player'
    5020 if zx < px + pw and  zx + zw > px and zy < py + ph and zh+ zy > py then gosub 5200
5070 return
1 ' ----------------------'
1 '   Sistema de gravedad / Colisiones con objetos sólidos
1 ' ----------------------'
    5100 if ph + py < sy(0) then py=py+g: pu=1 else pu=0
5110 return



1 ' ----------------------'
1 '   Rutina de colisión con el enemigo que te persigue
1 ' ----------------------'
    1 ' Le ponemos 1 sonido'
    5200 ' nada'
    1 ' Le quitamos la vida/ energía al personaje'
    5210 pe=pe-10
    5220 beep
    1 ' mostramos la información por pantalla'
    5250 gosub 7000
5260 return





1 ' ----------------------'
1 '   Rutina de colisión con caca que hay que coger
1 ' ----------------------'
    5300 pc=pc+1
    1 ' mostramos la información por pantalla'
    5350 gosub 7000
5360 return







1 ' ----------------------'
1 'Subrutina captura movimiento joystick / cursores y boton de disparo'
1 ' ----------------------'
1 ' stick(0) devuelve el cursor pulsado: 1 Arriba, 2 arriba derecha, 3 derecha, 4 abajo derecha, 5 abajo, 6 abajo izquierda, 7 izquierda, 8 izquierda arriba
1 ' on stick(0) gosub 11130,6000,11050,6000,11170,6000, 11090: sprite on'
6000 on stick(0) gosub 11130,6000,11050,6000,11170,6000, 11090
6010 return

1 ' ----------------------' 
1 '   Mostrar información
1 ' ----------------------'
1 ' Pintamos un rectangulo en la parte superior de la pantalla', color 14 gris claro, bf es un rectangulo relleno y mostramos las caputras
    7000 'line (0,0)-(w, 10), 14, bf
    7010 preset (20,10)
    7020 print #1,  chr$(205)" "pe", capturas: "pc
    7030 'preset (120,10)
    7040 'print #1, "z: x"zx", y" zy
7050 return
























1 ' ------------------------------------------------------------------------------'
1 ' -------------------------Rutinas player --------------------------------------'
1 ' ------------------------------------------------------------------------------'
1 ' Inicializacion del personaje
    1 ' parámteros personaje, posición px=x,py= posición eje y, pw=ancho del sprite ph=alto
    1 ' pd=dirección arriba ^ 1, derecha > 3, abajo v 5, izquierda < 7
    1 ' pu=player up/salto'
    1 ' pv=velocidad, pe=energia,  pc=caputras 
    10000 let px=100: let py=h-64: let pw=16: let ph=16: let pd=3: let pu=0: let pv=10: let pe=100: let pc=0
    1 ' variables para manejar los sprites, 
    1 ' ps=payer sprite, lo cremaos con el spritedevtools en desdde 1 al 9, para cambiarle el sprite según la tecla que pulsemos
    1 ' pp=player plano; para cambiarlo en el plano osprite paraq ue de la sención de movimento
    10010 let ps=0: let pp=1
10040 return


1 '------------------------'
1 'Subrutina actualizar player'
1 '------------------------'
    10500 put sprite ps,(px,py),,pp
10990 return


1 '------------------------'
11040 'Subrutinas mover '
1 '------------------------'
1 'pd=dirección arriba ^ 1, derecha > 3, abajo v 5, izquierda < 7
1 'Mover derecha
    1' 1 se suma a la posición x la velocidad del player
    11050 px=px+pv
    1 ' Le ponemos como plano el 0'
    11060 pp=1
    1 '  Para conseguir un movimeinto tenemos que crear la variable ms=número de sprite que será 1 o 2'
    11065  'nada'
    11070 'if pc>0 then pp=pp+1 else pc=0
    11071 'if pp=ps then pp=ps+1 else pp=ps
    1 ' Si la posición en x del player es mayor que el ancho de la pantalla la dejamos en esa posición para que no salga de la pantalla'
    11075 if px>=w-pw then px=w-pw
    11076 'gosub 7000
11080 return
 1 ' Mover izquierda'
    11090 px=px-pv
    11100 pp=3
    11105 'pc=pc+1
    11110  'if pc>0 then pp=pp+1 else pc=0
    11111 'if pp=ps then pp=ps+1 else pp=ps
    11115 if px<0 then px=0
    11116 'gosub 7000
11120 return
1 ' Mover arriba
    1 ' con pu le decimos que está saltando, al tocas la tierra volveremos a poner pu=0'
    11130 if pu<>1 then py=py-35
    11140 pp=7
    11145 'if pc=0 then pp=pp+1 else pc=0
    11150' pc=pc+1

    1 ' com esto evitamos que el player salga de la pantalla'
    11155 if py<=30 then py=30
    11156 if py>200 then py=200
    11157 'gosub 7000
11160 return
1 ' Mover abajo'
    11170 'py=py+pv
    11180 'pp=5
    11182 'ps=ps+1
    11185 'if ps>1 then pp=pp+1: ps=0
    11187 'if py >=212-ph then py=212-ph
    11188 'pe=pe-1
    1 ' Le ponemos al player la dirección abajo'
    11189 'pd=5
    1 ' Mostramos la vida'
    11190 'gosub 7100
11200 return



































1 ' ------------------------------------------------------------------------------'
1 ' ----------------Rutinas enemigos --------------------------------------'
1 ' ------------------------------------------------------------------------------'
1 ' Inicialización de variables enemigos
    1 ' ee=enemigo elegido, variable utilizada para cambiarle los valores cuando se salga de la pantalla'
    1 ' en=es el número de enemigos, tenemos dibujados 4 pájaros por eso ponemos 3'
    20000 ee=0: en=1
    1 ' Inicialización de enemigo a capturar, ex: posición eje x, ey posición eje y ew anchura, ey altura
    1 ' es= enemigo sprite asignado, ep es el plano del enemigo para hacer una animación, 
    1 ' ev es la velocidad de desplazamiento x, 
    1 ' ec es el contador de pasos para cuando llegue a 20 paso se cague'
    1 ' ed es la direcciín 3 derecha, 7 izquierda'
    20010 dim ex(en),ey(en),ew(en),eh(en),es(en),ep(en),ev(en),ec(en),ed(en)
    1 ' Enemigo 2
    20020 zx=0:zy=w-90:zw=16:zh=16:zs=18:zs=17:zp=17:zv=10:zc=0   
    20030 for i=0 to en
        1 ' le ponemos una altua aleatoria'
        20040 ey(i)=rnd(1)*100
        1 ' Si la altura es menor que 40 la volvemos a tomar'
        20050 if ey(i)<30 then goto 20030
        1' le asignamos la dirección rnd(1)*10
        20060 ed(i)=7
        20070 if ed(i)>5 then ed(i)=3 else ed(i)=7
        20080 ex(i)=-20*i: ew(i)=16: eh(i)=16: es(i)=(2*i)+9: ep(i)=(2*i)+9: ev(i)=10: ec(i)=0
    20090 next i
20100 return




1 '------------------------'
1 'Subrutinas actualizar sprites enemigos'
1 '------------------------'
    1 ' le aumentamos a todos los pájaros la velocidad ev(numero_pajaro) es su posición x ex(numero_pajaro)'
    21000 for i=0 to en
        1 ' Si la dirección es la derecha le sumamos la x'
        21010 if ed(i)=3 then ex(i)=ex(i)+ev(i) 
        1 '  si la dirección es la izquierda le restamos la x'
        21020 if ed(i)=7 then ex(i)=ex(i)-ev(i) 
        1 ' reseteamos los valores si se salen de la pantalla'
        21030 'if ex(i)>256 then ex(i)=-17
        21040 if ey(i)>212 then ey(i)=-17
        1 ' Cuando se salga de la pantalla le cambiaremos los parámetros al pájaro enemigo elegido (ee)
        21050 if ex(i)>255 then ee=i: gosub 21300
        1 ' Cuando se salga de la pantalla por la derecha le cambiamos los pará metros'
        21060 'if ex(i)<0 then ee=i: gosub 21400
        1 ' Tambien le aumentamos su contador de pasos interno'
        21070 ec(i)=ec(i)+1 
        1 ' si el contador de pasos es 10 o 15 o 20 entonces se caga, mostramos cacas de pájaros'
        21080 if ec(i)=10 and i=0 then ec(i)=0: dx(0)=ex(i)-pv(i): dy(0)=ey(i)+5: da(0)=1: ex(i)=ex(i)-ev(i): gosub 50000
        21090 if ec(i)=17 and i=1 then ec(i)=0: dx(1)=ex(i)-pv(i): dy(1)=ey(i): da(1)=1: ex(i)=ex(i)-ev(i): play "t230o4c#"
        21100 'if ec(i)=23 and i=2 then ec(i)=0: dx(2)=ex(i)-pv(i): dy(2)=ey(i): da(2)=1: ex(i)=ex(i)-ev(i): play "t230o3bg#"
        21110 'if ec(i)=25 and i=2 then ec(i)=0: dx(3)=ex(i)-pv(i): dy(3)=ey(i): da(3)=1: ex(i)=ex(i)-ev(i): play "t230o4e"
        1 ' Dibujamos los pájaros
        21120 put sprite es(i),(ex(i),ey(i)),,ep(i)
        1 ' le cambiamos el plano a los pájaros para que dé la sensación de movimiento' 
        21130 if ep(i)=es(i) then ep(i)=es(i)+1 else ep(i)=es(i)
    21140 next i
    1 ' Movimiento enemigo 2'
    21150 zx=zx+zv
    21160 if zx>256 then zx=0
    1 ' Hacemos la animación de sprite el enemigo 2'
    21170 'if zp=zs then zp=zs+1 else zp=zs
    21180 put sprite zp,(zx,zy),,zs
21190 return

1 'Rutina cambiar parámetrosa pájaro cuando se salga de la pantalla por la derecha'
    1 ' cambiamos la posición x para que se salga de la pantalla por la izquierda'
    21300 ex(ee)=32
    1' Cambiamos la posición y para que cambie la altura
    21330 ey(ee)=rnd(1)*100
    1 ' Si la altura es menor que 40 la volvemos a tomar'
    21340 if ey(ee)<20 then goto 21330
    1 ' Le cambiamos la velocidad
    21350 ev(ee)=rnd(1)*10
21360 return

1 'Rutina cambiar parámetros pájaro cuando se salga de la pantalla por la izquierda'
    1 ' cambiamos la posición x para que se salga de la pantalla por la derecha'
    21400 ex(ee)=220
    1' Cambiamos la posición y para que cambie la altura
    21430 ey(ee)=rnd(1)*100
    1 ' Si la altura es menor que 40 la volvemos a tomar'
    21440 if ey(ee)<20 then goto 21430
    1 ' Le cambiamos la velocidad
    21450 ev(ee)=rnd(1)*10
21460 return















1 ' ------------------------------------------------------------------------------'
1 ' ----------------Rutinas disparo --------------------------------------'
1 ' ------------------------------------------------------------------------------'
1 ' Inicializar disparo
    1 ' dx=Posicion fuego x, dy= posicion fuego y da= fuego activo, ds=fuego sprite, ds=velocidad'
    1' Vamos  crear tantos disparos como número de pájaros
    21500 let dn=en
    21510 dim dx(dn), dy(dn), dw(dn), dh(dn), da(dn), ds(dn)
    1 ' Rellenamos los disparos'
    21520 for i=0 to dn
        21530 dx(i)=20*i: dy(i)=-16: dw(i)=16: dh(i)=16: da(i)=0: ds(i)=0: dv(i)=10
    21550 next i
21560 return

1 ' Subrutina actualiza disparo'
    21700 for i=0 to dn
        1 ' Si el disparo está activo le aumentamos la y y lo mostramos'
        21710 if da(i)=1 then dy(i)=dy(i)+dv(i)
        21720 if dy(i)>=200 then dy(i)=-16: da(i)=0
        21730 if i=0 then put sprite 25,(dx(i),dy(i)),,25
        21740 if i=1 then put sprite 26,(dx(i),dy(i)),,26
        21750 if i=2 then put sprite 27,(dx(i),dy(i)),,27
        21760 if i=1 then put sprite 28,(dx(i),dy(i)),,28
    21770 next i    
21780 return



























1 ' ------------------------------------------------------------------------------'
1 ' ----------------Rutinas Obtjetos pantalla------------------------------'
1 ' ------------------------------------------------------------------------------'

1 '------------------------'
1 ' Inicializar objetos sólidos
1 '------------------------'
        1' sn=número de objetos sólidos
        22000 sn=20
        1 ' Inicializamos el array si no se inicializara crearía un array de tamaño 10 elementos'
        22010 dim sx(sn), sy(sn),sw(sn),sh(sn)
        22020 for i=0 to sn
            1 ' Inicializamos todos los objetos sólidos, para la posició y hay que restarle 2 objetos de 16px
            22030 sx(i)=16*i: sy(i)=212-32: sw(i)=16: sh(i)=16
        22040 next i
    22050 return

    
 

1 '------------------------'
1 ' Inicializar y pintar objetos sólidos en pantalla
1 '------------------------'             
        23000 for i=0 to sn
            23050 copy (4*16,0)-((4*16)+sw(1),0+sh(1)),1 to (sx(i), sy(i)),0
        23060 next i
    23070 return




































1 ' ------------------------------------------------------------------------------'
1 ' ----------------Pantallas / Niveles --------------------------------------'
1 ' ------------------------------------------------------------------------------'









1 ' ---------------------------------------------------------------------------------------'
1 '                                   Pantalla 1
1 ' --------------------------------------------------------------------------------------'
1' Inicialización pantalla 1
    1 ' Borramos la pantalla' 
    31000 cls
    1 ' Lo 1 es definir el color de caracteres 15 blanco, el fondo 7 azul claro y margen
    31120 'color 15,1,1
    1 ' Lo 2 es comfigurar la pantalla con screen modo_video, tamaño_sprites'
    1 ' el tamaño_sprite puede ser 0 (8x8px), 1 (8x8px ampliado), 2 (16x16 x), 3 (16x16px) ampliado'
    31130 screen 5,2
    1 ' Desactivamos el sonido de las teclas
    31140 key off
    1' Defimos a basic que haga que las variables de empiezan desde la a a la z sean enteras de 16 bits, en lugar de las de 32 que asigna por defecto
    31150 defint a-z
    1 ' Activamos las interrupciones de los sintervalos de tiempo para que haga algo cuando se cumplan los 60 segundos, cambie la posición del enemigo
    31160 interval on
    1 ' Parametros pantalla
    31170 let w=256: let h=212 
    1 ' La gravedad será compartida por el player y los enemigos'
    31180 let g=4
31190 return







1' Cargamos la pantalla que está alacenada de un archivo binario a la página 1 dirección 32768
    32000 restore 32000
    32010 'DATA 0,0,0,3,1,1,2,2,2,1,4,0,4,2,1,5,1,1,3,5,0,4,4,2
    32020 'DATA 3,6,0,7,0,0,6,4,2,7,3,3,4,7,2,2,4,7,6,6,4,2,7,7
    32030 'FOR C=0 TO 15:READ R,G,B:COLOR=(C,R,G,B):NEXT
    1 ' quí están los bloques, suelo, etc'
    32040 BLOAD"SCR1P1.SC5",S,32768 
    32060 color=restore
    32070 'color 15,4,4
32080 return



1 'Pintar en pantalla el fondo'
1' pintamos los bloques que forman el marco de arriba y de abajo, fx=objeto fondo posición x, y=posición y, h=altura, w=anchura
    32100 fx(0)=0: fy(0)=0: fw(0)=16: fh(0)=16
    32105 for i=0 to w-fw(0) step fw(0)
        1' 48 y 66 es la x e y de la page 0 del bloque elegido, 20 es el espacion del titulo de arroba
        32110 copy (0,0)-(0+fw(0),0+fh(0)),1 to (i, 10),0
        32120 copy (2*16,0)-((2*16)+fw(0),0+fh(0)),1 to (i, h-fh(0)),0
    32130 next i
    1' pintamos los bloque blancos de izquierda y derecha
    32140 'for i=0 to h-fh(0) step fh(0)
        32150 'copy (3*16,0)-((3*16)+fw(0),0+fh(0)),1 to (0, i),0
        32160 'copy (1*16,0)-((1*16)+fw(0),0+fh(0)),1 to (w-fw(0), i),0
    32170 'next i
    1 ' Copiamos las nubes'
    32180 'copy (32,32)-(256,120),1 to (16,28),0
32190 return








 


1 '-----------------------------------------------------'
1 'Subrutina cargar sprites y colores sprites pantalla 1'
1 '-----------------------------------------------------'
    33000 bload "rutinas.bin"
    33010 defusr=50000
    33020 a=usr(0)
33990 return









1 ' ---------------------------------------------------------------------------------------'
1 '                                  Final Pantalla 1
1 ' --------------------------------------------------------------------------------------'





























1 ' ---------------------------------------------------------------------------------------'
1 '                                  Sonidos
1 ' --------------------------------------------------------------------------------------'
1 ' Sonido 1'
50000 SOUND 0,0:SOUND 7,198:SOUND 8,16:SOUND 12,2:SOUND 13,3
50010 return
1 ' Sonido 2
50100 play "t230o3e"
50110 return