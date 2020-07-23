



























20 'clear 500
30 goto 1000 



100 screen 0:key off:color 15,1,1
110 locate 2,6: print "Presione espacio para empezar"
120 locate 12,7:print "MSX Murcia"
150 if not strig(0) then 150 else goto 1000 





300 screen 0
310 print "has ganado"
320 goto 100

330 input "¿Otra partida S/N ";a$
340 if inkey$="s" then 100
350 if inkey$="n" then print "adios": for i=0 to 500: next i:cls:end






500 screen 0

540 locate 0,10
550 print " Te han matado!!"
560 input "¿Otra partida S/N ";a$
340 if inkey$="s" then 100
350 if inkey$="n" then print "adios": for i=0 to 500: next i:cls:end







1000 screen 0:cls:key off

1010 color 15,1,1: defint a-z
1020 locate 10,5
1030 print "Level 1"
1040 locate 0,10
1050 print "Llega hasta la nave central"

1060 screen 5,2

1070 open "grp:" for output as #1

1080 gosub 10220

1090 gosub 10400



1100 defusr=&H69:x=usr(0)

1110 COPY(0,0)-(255,256-212),0 TO (0,212),0 

1115 'COPY(0,0)-(255,212),0 TO (0,0),1

1120 gosub 10300

1130 'gosub 33000

1140 gosub 10000

1150 gosub 8000

1160 gosub 9000

1170 gosub 9500
1180 strig(0) on

1190 on strig gosub 9600

1200 'sprite on
1210 'on sprite gosub 8200

1220 gosub 9910

1230 gosub 2000











        2000 for si=255 to 0 step -1
            2005 'if si mod 5=0 then gosub 9900
            2010 VDP(24)=si

            2020 gosub 10600

            2030 gosub 5000

            2040 gosub 3000

            2050 gosub 8100

            2060 gosub 9100

            2070 gosub 9700 

            2080 gosub 4000 

            2090 'gosub 7000
        2100 next si
    2110 goto 2000
2120 return





    3000 if pe=0 then gosub 500
    3010 'if pc=10 then interval off: close: gosub 700
3040 return




    4000 on stick(0) gosub 8500,4000,8300,4000,8600,4000, 8400
4010 return









    5000 IF POINT(px,py)=14 OR POINT(px+15,py)=14 THEN py=py+2

    5020 IF POINT(px,py+16)=14 OR POINT(px+15,py+16)=14 then py=py-2

    5040 if px < dx(1) + dw(1) and  px + pw > dx(1) and py < dy(1) + dh(1) and ph + py > dy(1) then play "t230o3d"
    5050 if ex < dx(0) + dw(0) and  ex + ew > dx(0) and ey < dy(0) + dh(0) and eh + ey > dy(0) then play "t230o4a"
5070 return












    7000 'sprite 60,(),15,60
7050 return


















































    8000 let px=100: let py=h-64: let pw=16: let ph=16: let pd=3: let pu=0: let pv=10: let pe=100: let pc=0




    8010 let ps=0: let pp=1
8020 return





    8100 put sprite 0,(px,py+si),,0
    8110 put sprite 1,(px,py+si),,1
8160 return





    8200 'put sprite 0,(px,py),,2
    8210 beep 'PLAY"O6V9C32","O5V7C32"
    8220 pe=0
8220 return







    8300 px=px+pv
    8310 if px>=w-pw then px=w-pw
    8320 'gosub 7000
8330 return

    8400 px=px-pv
    8410 if px<0 then px=0
    8420 'gosub 7000
8430 return


    8500 py=py-pv

    8510 if py<=0 then py=0
    8520 'gosub 7000
8530 return

    8600 py=py+pv
    8610 if py>200 then py=200
    8620 'gosub 7000
8630 return






















    9000 let ex=10: let ey=0: let ew=16: let eh=16: let ev=10: let ec=0
9010 return





    9100 ex=ex+ev

    9120 if ex>200 or ex<4 then ev=-ev :ey=rnd(-time)*100
    9130 put sprite 2,(ex,(ey+si)),,2
9160 return

























    9500 dn=1
    9510 dim dx(dn),dy(dn),dw(dn),dh(dn),dv(dn),da(dn),dc(dn)
    9520 for i=0 to dn
        9530 dx(dn)=-16:dy(dn)=-40:dw(dn)=16:dh(dn)=16:dv(dn)=10:da(dn)=0:dc(dn)=0
    9540 next i
    9550 'put sprite 3,(-10,-10),,3
9560 return


    9600 strig(0) off: beep
    9610 dx(0)=px+8: dy(0)=py: da(0)=1
9620 return

    9630 dx(1)=ex: dy(1)=ey: da(1)=1
9640 return 



    9700 dc(1)=dc(1)+1
    9710 if dc(1) mod 5=0 and da(1) <> 1 then gosub 9630
    9720 if da(0)=1 then dy(0)=dy(0)-10
    9730 if da(1)=1 then dy(1)=dy(1)+dv(1)
    9740 if dy(0)>212 or dy(0)<-16 then dy(0)=-40: da(0)=0: strig(0) on
    9750 if dy(1)>212 or dy(1)<-16 then dy(1)=-40: da(1)=0
    9760 put sprite 3,(dx(0),(dy(0)+si)),15,3
    9770 put sprite 4,(dx(1),(dy(1)+si)),15,3
9780 return










    9900 COPY(0,0)-(255,212),1 TO (0,0),0
    9910 line (100,0)-(rnd(-time)*200,rnd(-time)*20),14,bf
    9920 line (10,0)-(rnd(-time)*200,rnd(-time)*20),14,bf
    9920 line (200,0)-(rnd(-time)*200,rnd(-time)*20),14,bf
    9930 line (250,0)-(256,rnd(-time)*20),14,bf
    9940 line (0,0)-(10,rnd(-time)*20),14,bf
9960 return












    10000 let w=256: let h=212 

    10010 let si=0

    10020 let sy=255:sc=0
10030 return


    10220 BLOAD"SCR1P1.SC5",S,32768 
    10230 color=restore
10250 return


    10300 bload "rutinas.bin"
    10310 defusr=50000
    10320 a=usr(0)
10330 return


10400 copy (0,0)-(255,211),1 to (0,0),0
10410 return





    10500 '_turbo on(sy)
    10510 if sy<=0 then sy=255
    10520 sy=sy-1
    10560 COPY(0,sy)-(256,212-30),1 TO (0,30),0
    10570 '_turbo off
10580 return



    10600 sc=sc+1
    10610 if sc=256 then gosub 9900:sc=0
10620 return































    33000 s=base(29)

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
