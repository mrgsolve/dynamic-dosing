[ plugin ] evtools

[ set ] outvars = "CP"

[ param ] 

CL = 1
V = 32
KA = 2

DOSE = 100

[ pkmodel ]

cmt = "A1,A2"
depot = TRUE

[ event ] 

if(NEWIND > 1) return; 

evt::ev dose = evt::bolus(DOSE, 1); 
self.push(dose); 

[ error ] 

capture CP = A2/V;
