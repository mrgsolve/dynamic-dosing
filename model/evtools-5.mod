[ plugin ] evtools

[ set ] outvars = "CP"

[ param ] 

CL = 1
V = 32
KA = 2

DOSE = 100
OVER = 2

[ pkmodel ]

cmt = "A1,A2"
depot = TRUE

[ event ] 

if(NEWIND > 1) return; 

evt::ev dose = evt::bolus(DOSE, 1); 
evt::rate(dose, DOSE/OVER);
evt::retime(dose, 120); 
evt::ss(dose, 1); 
evt::ii(dose, 24); 
evt::addl(dose, 5); 

self.push(dose);

[ error ] 

capture CP = A2/V;
