[ plugin ] evtools

[ set ] outvars = "CP"

[ global ]
evt::regimen reg; 

[ param ] 

CL = 1
V = 32
KA = 1

INTERVAL = 24
UNTIL = 480
DOSE = 100
OVER  = 2

[ pkmodel ]

cmt = "A1,A2"
depot = TRUE

[ event ] 

if(NEWIND <= 1) reg.init(self);

reg.ii(INTERVAL);
reg.amt(DOSE);
reg.rate(reg.amt() / OVER);
reg.until(UNTIL);

reg.execute();

[ error ] 

capture CP = A2/V;
