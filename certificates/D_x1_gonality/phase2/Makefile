# Phase 2: the cover search, in C++ (needs a C++20 compiler and GMP).
CXX ?= g++
CXXFLAGS ?= -O3 -std=c++20 -pthread -Wall -Wextra
search: main.cpp include/ff_gonality.hpp $(wildcard include/ff/*.hpp)
	$(CXX) $(CXXFLAGS) $< -lgmpxx -lgmp -o $@
clean:
	rm -f search
