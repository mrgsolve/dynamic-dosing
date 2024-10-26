[ plugin ] evtools

[ set ] outvars = "CP"

[ param ] 

CL = 1
V = 22
KA = 1

COHORT = 0
DAYS = 14

[ pkmodel ]

cmt = "A1,A2"
depot = TRUE

[ event ] 

if(NEWIND > 1 || COHORT < 1 || COHORT > 5) return;

evt::ev dose = evt::infuse(50, 1, 50); 
evt::ii(dose, 24);
evt::addl(dose, DAYS-1);

if(COHORT == 1) {
  self.push(dose);
  return;
}

if(COHORT == 2) {
  evt::amt(dose, 75);
  self.push(dose);
  return;
}

if(COHORT == 3) {
  evt::amt(dose, 100); 
  self.push(dose);
  return;
}

if(COHORT == 4) {
  evt::amt(dose, 25); 
  evt::ii(dose, 12); 
  evt::addl(dose, 2*DAYS-1);
  self.push(dose);
  return;
}

if(COHORT == 5) {
  evt::ii(dose, 12); 
  evt::addl(dose, 3);
  self.push(dose);
  
  evt::amt(dose, 75);
  evt::retime(dose, 48);
  evt::ii(dose, 24); 
  evt::addl(dose, DAYS-3);
  self.push(dose);
  return;
}

[ error ] 

capture CP = A2/V;
