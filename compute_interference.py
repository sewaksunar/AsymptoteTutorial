import math

phi=20*math.pi/180
m=10 # mm
N2=13
N3=50
Pd=25.4/m
R2=N2/(2*Pd)
R3=N3/(2*Pd)
rb2=R2*math.cos(phi)
rb3=R3*math.cos(phi)
a=1/Pd
print('Pd',Pd,'R2',R2,'R3',R3,'rb2',rb2,'rb3',rb3,'a',a)
loa=(math.sin(phi), math.cos(phi))
Ra2=R2+a
O2=(-R2,0)
aq=loa[0]**2 + loa[1]**2
bq=2*loa[0]*R2
cq=R2**2 - Ra2**2
disc=bq**2 - 4*aq*cq
sol=[(-bq+math.sqrt(disc))/(2*aq),(-bq-math.sqrt(disc))/(2*aq)]
print('t solutions',sol)
O3=(R3,0)
for tv in sol:
    pt=(loa[0]*tv, loa[1]*tv)
    dist=math.hypot(pt[0]-O3[0], pt[1]-O3[1])
    print('t',tv,'pt',pt,'dist from gear centre',dist,'rb3',rb3)
