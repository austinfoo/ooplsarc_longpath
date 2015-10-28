
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
