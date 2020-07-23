        output "rutinas.bin"

    db   #fe               ; ID archivo binario, siempre hay que poner el mismo 0FEh
    dw   INICIO            ; dirección de inicio
    dw   FINAL - 1         ; dirección final
    dw   INICIO             ; dircción del programa de ejecución (para cuando pongas r en bload"nombre_programa", r)

    org 50000 ; o #f230, org se utiliza para decirle al z80 en que posición de memoria RAM empieza nuestro programa en ensamblador

CHGMOD equ #005F   ; Cambia el modo de screen pero previamente necesita que se le asigne el modo en el registro a
LDIRVM equ #005C   ;Tansfiere bloques de la RAM a la VRAM, es la más importante, necesita previamente asignar valor al registro bc con la longitud, dc con la dirección de inicio de la VRAM y hl con la dirección de inicio de la RAM:
GTSTCK equ #00D5   ;si le pasas al registro a un 0 detectará los cursores,un 1 para el joystick 1 y 2 para el joystick 2
                   ;devuelve en a 1 arriba, 2 diagonal arriba derecha,3 derecha, asi hasta 7

INICIO:
    call volcar_sprites_de_disco_a_vram
    call volcar_colores_sprites_de_disco_a_vram
    ret



volcar_sprites_de_disco_a_vram:
    ld hl, sprites ; la rutina LDIRVM necesita haber cargado previamente la dirección de inicio de la RAM, para saber porqué he puesto 0000 fíjate este dibujo https://sites.google.com/site/multivac7/files-images/TMS9918_VRAMmap_G2_300dpi.png ,así es como está formado el VDP en screen 2
    ld de, #7800 ; la rutina necesita haber cargado previamente con de la dirección de inicio de la VRAM          
    ld bc, 32*4; 
    call  LDIRVM ; Mira arriba, pone la explicación
    ret
volcar_colores_sprites_de_disco_a_vram:
    ld hl, color_sprites ; la rutina LDIRVM necesita haber cargado previamente la dirección de inicio de la RAM, para saber porqué he puesto 0000 fíjate este dibujo https://sites.google.com/site/multivac7/files-images/TMS9918_VRAMmap_G2_300dpi.png ,así es como está formado el VDP en screen 2
    ld de, #7400 ; la rutina necesita haber cargado previamente con de la dirección de inicio de la VRAM          
    ld bc, 16*4; 
    call  LDIRVM ; Mira arriba, pone la explicación
    ret
 


sprites:
    ;incbin "./src/SPR.BIN"
    ; 0-
    db #00,#00,#00,#30,#30,#30,#30,#3F
    db #30,#30,#30,#3F,#3F,#1F,#07,#03
    db #00,#00,#00,#0C,#0C,#0C,#0C,#FC
    db #0C,#0C,#0C,#FC,#FC,#FC,#F0,#E0
    ; 1-
    db #30,#30,#70,#91,#91,#91,#93,#9F
    db #9F,#9F,#80,#BF,#8F,#67,#33,#30
    db #08,#0C,#0E,#89,#89,#89,#C9,#F9
    db #F9,#F9,#01,#FD,#F1,#E6,#CC,#0C
    ; 2-player explota
    db #00,#00,#18,#08,#0C,#04,#1D,#02
    db #0F,#07,#4B,#18,#13,#0E,#38,#20
    db #00,#00,#00,#8C,#98,#B0,#20,#80
    db #00,#00,#48,#40,#EC,#36,#12,#00
    ; 3-
    db #E0,#E0,#E0,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00

color_sprites:
    ;incbin "./src/CLRSPR.BIN"
    ; 0-
    db #07,#07,#07,#07,#07,#07,#07,#07
    db #07,#07,#07,#07,#07,#08,#08,#0A
    ; 1-
    db #0E,#0E,#0E,#0E,#0E,#0E,#0E,#0E
    db #0E,#0E,#0E,#0E,#0E,#0E,#0E,#0E
    ; 2-
    db #08,#08,#08,#08,#08,#08,#08,#0B
    db #0A,#0A,#08,#08,#08,#08,#08,#08
    ; 3-
    db #08,#08,#08,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00

FINAL:
