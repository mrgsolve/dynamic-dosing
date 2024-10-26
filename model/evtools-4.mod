[ plugin ] evtools

[ set ] outvars = "CP"

[ param ] 

CL = 1
V = 32
KA = 2

DOSE = 100
INTERVAL = 24
OVER = 2
END = 240

[ pkmodel ]

cmt = "A1,A2"
depot = TRUE

[ event ] 

if(TIME > END) return;

if(NEWIND <=1) { 
  double nextdose = 0;
}

if(evt::near(TIME, nextdose)) {
  evt::infuse(self, DOSE, 1, DOSE/OVER); 
  nextdose = nextdose + INTERVAL;
}

[ error ] 

capture CP = A2/V;
