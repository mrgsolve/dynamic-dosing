[ plugin ] evtools

[ set ] outvars = "CP"

[ param ] 

CL = 1
V = 32
KA = 2

DOSE = 100
INTERVAL = 24
OVER = 2

[ pkmodel ]

cmt = "A1,A2"
depot = TRUE

[ event ] 

if(std::fmod(TIME,INTERVAL) == 0) {
  evt::infuse(self, DOSE, 1, DOSE/OVER); 
}

[ error ] 

capture CP = A2/V;
