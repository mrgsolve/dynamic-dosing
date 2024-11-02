#ifndef MONITOR_H
#define MONITOR_H

#include <map>
#include <vector>
#include <math.h>  /* provides fmod() */

/* 
 Monitoring is done at clinicl visits on platelet values including RUV.
 
 Epochs out of Gr 4 TCP are negative integers representing the cumulative epoch 
 number out of a G4 episode for the individual. Epochs in a Gr 4 TCP episode are 
 positive integers also indicating cumulative epoch number.
 
 Strikes happen at the first monitoring instance when there is Gr4 TCP. This is 
 marked by incrementing `strike` . Epochs are marked by incrementing 
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
  monitor();
  void reset(const double dose_, const double base_, const int reduce_);
  bool restart_ok();
  void check(double dv_);
  
  int track_tcp();
  double dose();      // returns the current dose amount
  
  /* Public members */
  bool reduce;        // should doses be reduced? or not?
  bool hold;          // on hold
  bool start_holding; // just started holding
  bool stop_holding;  // just stopped holding
  bool term;          // true once the 4th TCP is hit
  int epoch;          // incremented when platelets (Y) return to 50 or base
  int strike;         // incremented when platelets (Y) drop below 25
  double dv;          // platelets (Y)
  double bdv;         // baseline platelets (Y)
  double dose1;       // starting dose (mg)
  double dose2;       // reduced dose 1 eg: 200 --> 150; this is dose1 - 50
  double dose3;       // reduced dose 2 eg: 150 --> 100; this is dose2 - 50
  bool g4;            // true once Y     < 25 and until recovered
};

void monitor::reset(const double dose_, const double base_, const int reduce_) {
  reduce = reduce_;    
  hold = false;
  start_holding = false;
  stop_holding = false;
  term = false;
  epoch = 1;
  strike = 0;
  dv = 0;
  bdv = base_;
  dose1 = dose_;
  dose2 = dose1 - 50;
  dose3 = dose2 - 50;
  g4 = false;
  if(reduce==0) {
    dose2 = dose1;
    dose3 = dose1;
  }
}

monitor::monitor() {
  reset(1,1,1);
}

double monitor::dose() {
  if(hold || term) return 0;
  if(strike < 2) {
    return dose1;
  }
  if(strike == 2) { 
    return dose2;
  }
  if(strike == 3) {
    return dose3;
  }
  return 0;
}

int monitor::track_tcp() {
  if(stop_holding || start_holding || hold) {
    stop_holding  = false; 
    start_holding = false;
    return strike;
  } 
  return -1*epoch;
}

void monitor::check(double dv_) {
  if(dv_ == 0 || term) return;
  dv = dv_;
  if(dv < 25 && !hold) { // go into holding pattern
    g4 = true;
    hold = true;
    start_holding = true;
    ++strike;
    if(strike == 4) {
      term = true;
    }
    return; 
  }
  if(hold && restart_ok()) {  
    stop_holding = true;
    hold = false;
    g4 = false;
    ++epoch;
  }
  return;
}

bool monitor::restart_ok() {
  if(term) return false;
  return dv >= 50 || abs(dv - bdv) < 0.01;
}

bool check_time(const double time, const int adjust, const double mmax) {
  if(adjust != 1 | time > mmax) return false;
  return time==168 || time==504 || fmod(time,336)==0;
}

#endif
