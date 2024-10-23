[ plugin ] evtools

[ set ] outvars = "A2"

[ param ] 

CL = 1
V = 32
KA = 0

[ pkmodel ]

cmt = "A1,A2"
depot = TRUE

[ pk ] 
A1_0 = 0; 
A2_0 = 1000;

[ event ] 

if(std::fmod(TIME,72)==0 || NEWIND <= 1) {  
  evt::reset(self);
}

[ error ] 

capture CP = A2/V;
