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

if(evt::near(TIME, 48)) {  
  evt::infuse(self, 300, 1, 3);
}

if(evt::near(TIME, 150)) {  
  evt::replace(self, 10, 2);
}

[ error ] 

capture CP = A2/V;
