[ plugin ] nm-vars evtools

[ include ] monitor.h

[ input ] @covariates
WT     = 63
STUDY  = 201
SEQ    = 1
AAG    = 87
SEX    = 0
RACE   = 1
POP    = 1
HEPAT  = 0
ALB    = 3.9
CLCR   = 70
BLPAT  = 200
ECOGBL = 0

[ param ] @tag platlets
THETA1   =  134
THETA2   =  0.144
THETA3   =  81.5
THETA4   =  115
THETA5   =  0.436
THETA6   =  0
THETA7   =  43.6
THETA8   =  197
THETA9   =  0.846
THETA10  =  2
THETA11  =  0.913
THETA12  =  1.07

[ param ] @tag pkmodel
TH1   =  6.11
TH2   =  4.57
TH3   =  3.56
TH4   =  8.15
TH5   = -0.524
TH6   = -0.271
TH7   =  4.8
TH8   =  8.41
TH9   = -0.4
TH10  =  5.34
TH11  =  7.7
TH12  = -1.19
TH13  =  0.952
TH14  =  0.75
TH15  =  0
TH16  =  0
TH17  =  0.191
TH18  = -0.0219
TH19  =  0.0487
TH20  = -0.132
TH21  =  1
TH22  =  0
TH23  =  0
TH24  =  0.54
TH25  =  0.252
TH26  = -0.306

[ param ] 
ADJUST = 1
REDUCE = 1
BMAX   = 200
MONMAX = 168*52-1
GAMMAX = 0.3
DOSE   = 200
UNTIL  = 168*10

[ omega ] @block // platelets
 0.182
 0.0664  0.863
-0.0651 -0.332  0.334

[ omega ] //pk
@labels ECL EKA ERM EF1 ED1
0.0395
0.850
0.0445
0.343
1.41

[ sigma ] // platelets
0.0408

[ cmt ] 
DEPOT CENT PERIPH PERIPH2
platelet
prolif1
prolif2
transit1
transit2
transit3
transit

[ global ] 
double emx(const double x, const double ec50, const double gam) {   
  if(x==0.0) return 0.0;
  return  pow(x,gam)/(pow(x,gam) + pow(ec50,gam));
}

monitor plt;
evt::regimen reg;

[ pk ] 

if(NEWIND <=1) {
  reg.init(self);
  reg.cmt(1);
  reg.ii(24);
  reg.until(UNTIL);  
}

double FL106    = STUDY==106 ? 1 : 0;
double FL101    = STUDY==101 ? 1 : 0;
double PAT      = POP==1 ? 1 : 0;
double HLTH     = 1-PAT;
double ASIAN    = RACE==1 ? 1 : 0;
double NONASIAN = 1-ASIAN;
double HEP      = HEPAT >= 1 ? 1 : 0;
double FEMALE   = SEX;
double REFWT    = 63;
double REFALB   = 3.9;
double REFRF    = 73.0;
double REFAAG   = 87.0;
double ECOG1P   = ECOGBL;

// baseline platelets
double TVBASE = THETA(8) * pow(THETA(11),NONASIAN) * pow(THETA(12),ECOG1P);
double MU_1 = LOG(TVBASE); 
double BASE = EXP(MU_1 + ETA(1));

double MU_3 = LOG(THETA(2));
double GAMP = EXP(MU_3 + ETA(3));

while(BASE > BMAX || BASE <= 68 || GAMP > GAMMAX) {
  simeta(); 
  BASE = EXP(MU_1 + ETA(1));
  GAMP = EXP(MU_3 + ETA(3));
}

if(NEWIND <= 1) {
  plt.reset(DOSE, BASE, REDUCE); 
}

double WTCL  = TH14*LOG(WT/REFWT);
double ALBCL = TH15*LOG(ALB/REFALB);
double RFCL  = TH16*LOG(CLCR/REFRF);
double DZCL  = TH17*HLTH;
double NASCL = TH18*NONASIAN;
double SXCL  = TH19*FEMALE;
double HPCL  = TH20*HEP;
double AAGCL = TH24*LOG(AAG/REFAAG);
double U6CL  = TH26*FL106;

double WTV  = TH21*LOG(WT/REFWT);
double ALBV = TH22*LOG(ALB/REFALB);
double AAGV = TH23*LOG(AAG/REFAAG);
double UV6  = TH25*FL106;

double TVCL = TH1+WTCL+ALBCL+RFCL+DZCL+NASCL+SXCL+HPCL+AAGCL+U6CL;
double CL   = EXP(TVCL + ECL);
double V2   = EXP(TH2 + UV6);
double Q3   = EXP(TH3);
double TVV3 = TH4+WTV+ALBV+AAGV+UV6;
double V3   = EXP(TVV3);
double Q4   = EXP(TH10);
double V4   = EXP(TH11+WTV+UV6);
double KA   = EXP(TH5 + EKA);

double TVD1 = TH6*(1-FL106) + TH12*FL106;
D1   = EXP(TVD1 + ED1);
F1   = EXP(AAGCL + EF1); 

double KSS    = EXP(TH7); 
double TVRMAX = TH8 + TH13*LOG(AAG/REFAAG);
double RMAX   = EXP(TVRMAX + ERM);

D_DEPOT = D1;
F_DEPOT = F1;

double S2  = V2/1000.0;
double K20 = CL/V2;
double K23 = Q3/V2;
double K32 = Q3/V3;
double K24 = Q4/V2;
double K42 = Q4/V4;

double MMTP  = THETA(1);
double NT    = 3.0;
double KTRP  = (NT+1)/MMTP;
double KELP  = KTRP;
double KPROL = KTRP;

double EC501 = THETA(3);

double MU_2  = LOG(THETA(4));
double EC502 = EXP(MU_2 + ETA(2));

double GAM1 = THETA9;
double GAM2 = THETA10;

double TVLGT = LOG(THETA(5)/(1-THETA(5)));
double LGT   = TVLGT;
double RATIO = 1.0/(1.0 + EXP(-LGT));

A_0(1) = 0; 
A_0(2) = 0;
A_0(3) = 0;
A_0(4) = 0;
A_0(5) = BASE;

A_0(6)  = (KELP*BASE*(1-RATIO))/KTRP;
A_0(7)  = (KELP*BASE*RATIO)/KTRP;
A_0(8)  = (KELP*BASE)/KTRP;
A_0(9)  = (KELP*BASE)/KTRP;
A_0(10) = (KELP*BASE)/KTRP;
A_0(11) = 0;

double KEQ = LOG(2.0)/THETA(7);

[ des ] 
double XX = CENT/S2;
double CF = 0.5*(XX-RMAX-KSS)+0.5*SQRT(pow(XX-RMAX-KSS,2.0)+4*KSS*XX);
double AC = CF * S2;

double CPPEC = A(11);

double E1 = 0;
double E2 = 0;
if(CPPEC > 0) E1 = emx(CPPEC, EC501, GAM1);
if(CF   > 0)  E2 = emx(CF,    EC502, GAM2);

double FBPP = pow(BASE/0.00001, GAMP);
if(A(5) > 0.00001) FBPP = pow(BASE/A(5), GAMP);

DADT(1)  = -KA*A(1);
DADT(2)  =  KA*A(1) + K32*A(3) + K42*A(4) - (K20+K23+K24)*AC;
DADT(3)  =  K23*AC  - K32*A(3);
DADT(4)  =  K24*AC  - K42*A(4);
DADT(5)  =  KTRP*A(10) - KELP*A(5);              // Circulating platelets
DADT(6)  =  KPROL*A(6)*(1-E1)*FBPP - KTRP*A(6) ; // PP1
DADT(7)  =  KPROL*A(7)*(1-E2)*FBPP - KTRP*A(7) ; // PP2
DADT(8)  =  KTRP*(A(6) + A(7)) - KTRP*A(8) ;     // Transit 1
DADT(9)  =  KTRP*A(8) - KTRP*A(9);               // Transit 2
DADT(10) =  KTRP*A(9) - KTRP*A(10);              // Transit 3
DADT(11) =  KEQ*CF - KEQ*A(11);                  // Effect compartment

[ error ] 
double CTOT = A(2)/S2;
double CFREE = 0.5*(CTOT-RMAX-KSS)+0.5*SQRT(pow(CTOT-RMAX-KSS,2.0)+4*KSS*CTOT);

double PLT = std::max(0.00001, A(5));

double IPRED = PLT;
capture Y = IPRED*(1+EPS(1));

while(NEWIND <= 1 && (Y <= 50 || Y > 500)) {
  simeps(); 
  Y = IPRED*(1+EPS(1));
}
while(Y < 0) {
  simeps(); 
  Y = IPRED*(1+EPS(1));
}

bool visit = check_time(TIME, ADJUST, MONMAX);
if(EVID==0) { 
  if(visit) plt.check(Y);
  plt.icheck(IPRED,BASE);
}

reg.amt(plt.dose()); 
reg.execute();

capture current_dose = plt.dose();
capture epoch = plt.track_tcp();
capture iepoch = plt.track_itcp();
capture hold = plt.hold;

[ capture ] UNBOUND = CFREE, PLATELET = IPRED, visit
