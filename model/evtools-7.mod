[ plugin ] evtools

[ set ] outvars = "CP"

[ param ] 

CL = 1
V = 32
KA = 1

[ pkmodel ]

cmt = "A1,A2"
depot = TRUE

[ event ] 

if(NEWIND <= 1) { 
  evt::ev dose = evt::bolus(50, 1);
  evt::ii(dose,12); 
  evt::addl(dose,22);
  self.push(dose);
}

if(evt::near(TIME,290)) {  
  evt::ev dose = evt::reset(100, 1);
  evt::ii(dose, 24); 
  evt::addl(dose,10);
  self.push(dose);
}

[ error ] 

capture CP = A2/V;
