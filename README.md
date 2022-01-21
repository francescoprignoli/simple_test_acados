# simple_test_acados

This repo contains a simple test to reproduce the different behavior of the two acados Matlab interfaces as described [here](https://discourse.acados.org/t/different-behavior-in-acados-ocp-and-code-generation/639).


## Usage

 - Set your acados installation path in env.sh
 - Open a terminal in this repo, source env.sh and run Matlab from the same terminal
 - Open and run main.m
 
 Depending on whether you create the solver via the native MEX interface or template based interface, the closed loop simulation produces different results in terms of number of solver failures (37 vs 0 in my case*).

\
\
\*Tested on macOS 11.6.1 and Ubuntu 20.04
