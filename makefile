INCDIRS:=/Users/dmielke/Documents/oopl/trees/googletest/googletest/include
LIBDIRS:=/Users/dmielke/Documents/oopl/trees/googletest/googletest/make

FILES :=                                \
    .travis.yml                         \
    dijkstra-tests/EID-RunLongPath.in   \
    dijkstra-tests/EID-RunLongPath.out  \
    dijkstra-tests/EID-TestLongPath.c++ \
    dijkstra-tests/EID-TestLongPath.out \
    LongPath.c++                        \
    LongPath.h                          \
    LongPath.log                        \
    html                                \
    RunLongPath.c++                     \
    RunLongPath.in                      \
    RunLongPath.out                     \
    TestLongPath.c++                    \
    TestLongPath.out                    \
    LongPathBundle.c++

# Call gcc and gcov differently on Darwin
ifeq ($(shell uname), Darwin)
  CXX      := g++
  GCOV     := gcov
  VALGRIND := echo Valgrind not available on Darwin
else
  CXX      := g++-4.8
  GCOV     := gcov-4.8
  VALGRIND := valgrind
endif

CXXFLAGS   := -pedantic -std=c++11 -Wall -I$(INCDIRS)
LDFLAGS    := -lgtest -lgtest_main -pthread -L$(LIBDIRS)
GCOVFLAGS  := -fprofile-arcs -ftest-coverage
GPROF      := gprof
GPROFFLAGS := -pg

clean:
	rm -f *.gcda
	rm -f *.gcno
	rm -f *.gcov
	rm -f RunLongPath
	rm -f RunLongPath.tmp
	rm -f TestLongPath
	rm -f TestLongPath.tmp
	rm -f LongPathBundle

config:
	git config -l

bundle:
	cat LongPath.h LongPath.c++ RunLongPath.c++ | sed -e "s/#include \"LongPath.h\"//g" > LongPathBundle.c++
	$(CXX) $(CXXFLAGS) $(GCOVFLAGS) LongPathBundle.c++ -o LongPathBundle

scrub:
	make  clean
	rm -f  LongPath.log
	rm -rf dijkstra-tests
	rm -rf html
	rm -rf latex

status:
	make clean
	@echo
	git branch
	git remote -v
	git status

test: RunLongPath.tmp TestLongPath.tmp

RunLongPath: LongPath.h LongPath.c++ RunLongPath.c++
	$(CXX) $(CXXFLAGS) $(GCOVFLAGS) LongPath.c++ RunLongPath.c++ -o RunLongPath

RunLongPath.tmp: RunLongPath
	./RunLongPath < RunLongPath.in > RunLongPath.tmp
	diff RunLongPath.tmp RunLongPath.out

TestLongPath: LongPath.h LongPath.c++ TestLongPath.c++
	$(CXX) $(CXXFLAGS) $(GCOVFLAGS) LongPath.c++ TestLongPath.c++ -o TestLongPath $(LDFLAGS)

TestLongPath.tmp: TestLongPath
	./TestLongPath                                                     >  TestLongPath.tmp 2>&1
	$(VALGRIND) ./TestLongPath                                         >> TestLongPath.tmp
	$(GCOV) -b LongPath.c++     | grep -A 5 "File 'LongPath.c++'"     >> TestLongPath.tmp
	$(GCOV) -b TestLongPath.c++ | grep -A 5 "File 'TestLongPath.c++'" >> TestLongPath.tmp
	cat TestLongPath.tmp
