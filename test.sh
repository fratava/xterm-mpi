#!/bin/bash

cd mpi_code
mpicc hello_world.c -o hello_world
mpiexec --allow-run-as-root --use-hwthread-cpus -n 4 ./hello_world