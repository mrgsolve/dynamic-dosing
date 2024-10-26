#ifndef MONITOR_H
#define MONITOR_H

#include <map>
#include <vector>
#include <math.h>  /* provides fmod() */

/* 
 Monitoring is done at clinicl visits on platelet values including RUV; but 
 we also monitor based on platelet IPRED to understand what the real time in and 
 out of Gr 4 TCP.
 
 Epochs out of Gr 4 TCP are negative integers representing the cumulative epoch 
 number out of a G4 episode for the individual. Epochs in a Gr 4 TCP episode are 
 positive integers also indicating cumulative epoch number.
 
 Strikes happen at the first monitoring instance when there is Gr4 TCP. This is 
 marked by incrementing `strike` or `istrike`. Epochs are marked by incrementing 
 `epoch`. Then, to get the current value for epoch, return either `strike` or 
 negative `epoch`. This is structured so that Gr 4 TCP epochs run from the 
 first TCP record through (and including) the record where the subject recovers 
 from Gr 4 TCP. 
 
 Clinical monitoring: weekly over first cycle and every two weeks after that.

 Recovery means that:
 - simulated platelets are back to 50x10^9/L or back to baseline
 - the baseline value depends on the type of simulation
 
 */

class monitor {
public: 
  // Constructor
  monitor();
  void reset(const double dose_, const double base_, const int reduce_);
  bool restart_ok();
  void check(double dv_);
  void icheck(double ipred, double ibase);
  
  int track_tcp();
  int track_itcp();
  double dose();      // returns the current dose amount
  
  /* Public members */
  bool reduce;        // should doses be reduced? or not?
  bool hold;          // on hold
  bool start_holding; // just started holding
  bool stop_holding;  // just stopped holding
  bool start_ig4;     // just crossed the true G4 TCP threshold
  bool stop_ig4;      // just recovered to the true 50 or base
  bool term;          // true once the 4th TCP is hit
  int epoch;          // incremented when platelets (Y) return to 50 or base
  int iepoch;         // incremented when platelets (IPRED) return to 50 or base
  int strike;         // incremented when platelets (Y) drop below 25
  int istrike;        // incremented when platelets (IPRED) drop below 25
  double dv;          // platelets (Y)
  double bdv;         // baseline platelets (Y)
  double dose1;       // starting dose (mg)
  double dose2;       // reduced dose 1 eg: 200 --> 150; this is dose1 - 50
  double dose3;       // reduced dose 2 eg: 150 --> 100; this is dose2 - 50
  bool g4;            // true once Y     < 25 and until recovered
  bool ig4;           // true once IPRED < 25 and until recovered
};

void monitor::reset(const double dose_, const double base_, const int reduce_) {
  reduce = reduce_;    
  hold = false;
  start_holding = false;
  stop_holding = false;
  start_ig4 = false;
  stop_ig4 = false;
  term = false;
  epoch = 1;
  iepoch = 1;
  strike = 0;
  istrike = 0;
  dv = 0;
  bdv = base_;
  dose1 = dose_;
  dose2 = dose1 - 50;
  dose3 = dose2 - 50;
  g4 = false;
  ig4 = false;
  if(reduce==0) {
    dose2 = dose1;
    dose3 = dose1;
  }
}

monitor::monitor() {
  reset(1,1,1);
}

double monitor::dose() {
  // holding or terminated: no dose
  if(hold || term) return 0;
  // return the original dose through the first G4 TCP 
  if(strike < 2) {
    return dose1;
  }
  // reduced dose at the second G4 TCP
  if(strike == 2) { 
    return dose2;
  }
  // further reduced at third G4 TCP
  if(strike == 3) {
    return dose3;
  }
  // Any strike greater than 3 means the subject is done, with zero dose
  return 0;
}

int monitor::track_tcp() {
  // Are we currently on hold? or did we just start or stop holding?
  if(stop_holding || start_holding || hold) {
    stop_holding  = false; 
    start_holding = false;
    return strike;
  } 
  return -1*epoch;
}

int monitor::track_itcp() {  
  // Are we currently on hold? or did we just start or stop holding?
  if(start_ig4 || stop_ig4 || ig4) {
    stop_ig4  = false; 
    start_ig4 = false;
    return istrike;
  } 
  return -1*iepoch;
}

void monitor::check(double dv_) {
  if(dv_ == 0 || term) return;
  dv = dv_;
  if(dv < 25 && !hold) { // Just entered G4 TCP
    // go into holding pattern
    g4 = true;
    // strike gets incremented when we start holding
    ++strike;
    hold = true;
    if(strike == 4) term = true;
    start_holding = true;
    return; 
  }
  if(hold && restart_ok()) {  
    stop_holding = true;
    hold = false;
    g4 = false;
    // epoch gets incremented when we stop holding
    ++epoch;
  }
  return;
}

void monitor::icheck(double ipred, double ibase) {
  if(ipred >= 25 && !ig4) return;
  if(ig4) {
    if(ipred >= 50 || abs(ipred - ibase) < 0.01) {
      ig4 = false;
      stop_ig4 = true;
      ++iepoch;
    }
    return;
  }
  if(ipred < 25 && !ig4) {
    ++istrike;
    ig4 = true;
    start_ig4 = true;
    return;
  }
  return;
}

bool monitor::restart_ok() {
  // If on hold we can restart if back to 
  // 50 or back to original baseline
  if(term) return false;
  return dv >= 50 || abs(dv - bdv) < 0.01;
}

bool check_time(const double time, const int adjust, const double mmax) {
  if(adjust != 1 | time > mmax) return false;
  // every two weeks or weekly over first cycle
  return time==168 || time==504 || fmod(time,336)==0;
}

#endif
