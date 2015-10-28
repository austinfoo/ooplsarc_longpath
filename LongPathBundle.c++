
#ifndef LongPath_h
#define LongPath_h

// --------
// includes
// --------

#include <iostream>
#include <string>
#include <vector>

// ------------
// longpath_eval
// ------------

int longpath_eval (const int num_rooms, const std::vector<int>& taken_rooms);

// -------------
// longpath_print
// -------------

void longpath_print (std::ostream& w, int num_portals);

// -------------
// longpath_solve
// -------------

void longpath_solve (std::istream& r, std::ostream& w);

#endif

// ----------------------------
// projects/twobuttons/Twobuttons.c++
// Copyright (C) 2015
// Glenn P. Downing
// ----------------------------

// --------
// includes
// --------

#include <cassert>  // assert
#include <iostream> // endl, istream, ostream
#include <sstream>  // istringstream
#include <string>   // getline, string
#include <utility>
#include <cstdint>
#include <algorithm>
#include <vector>
#include <list>
#include <limits>



// ------------
// longpath_eval
// ------------

int longpath_eval (const int num_rooms, const std::vector<int>& taken_rooms)
{
  std::vector<uint64_t> num_portals (num_rooms+1);
  num_portals[1] = 2;

  for (int i = 2; i <= num_rooms; ++i) {
    ++num_portals[i];
    for (int j = taken_rooms[i]; j < i; ++j) {
      num_portals[i] += num_portals[j];
    }
    ++num_portals[i];
  }

  return num_portals[num_rooms];
}

// -------------
// longpath_print
// -------------

void longpath_print (std::ostream& w, int num_portals) {
  w << num_portals << std::endl;
}

// -------------
// longpath_solve
// -------------

void longpath_solve (std::istream& r, std::ostream& w) 
{
  std::string s;

  // Get the number of rooms
  int num_rooms = 0;
  if (std::getline(r, s)) {
    std::istringstream sin(s);
    sin >> num_rooms;
  }

  // Get the taken rooms
  std::vector<int> taken_rooms (num_rooms+1);
  for (int i = 1; i <= num_rooms; ++i) {
    if (std::getline(r, s)) {
      std::istringstream sin(s);
      sin >> taken_rooms[i];
    }
  }

  // Determine the number of pieces
  int num_portals = longpath_eval(num_rooms, taken_rooms);

  // Print the result
  longpath_print(w, num_portals);
}

#include <iostream>



// ----
// main
// ----

int main () {
    using namespace std;
    longpath_solve(cin, cout);
    return 0;
}
