FROM ubuntu:24.04
 
# Authors Jean Iaquinta
# Contact jeani@uio.no
# ORCID-0000-0002-8763-1643
# Version v1.0.1
#
# This is a definition file to illustrate the use of an Ubuntu24.04 container for OpenMolcas24.02 with the DMRG (Density Matrix Renormalization Group) option

# Update system and install basic packages
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates cmake g++ gcc gfortran git libboost-all-dev libgsl-dev libhdf5-serial-dev libopenmpi-dev make ncurses-term python3 python3-pip vim wget && \
    pip install pyparsing==2.3.1 && \
    rm -rf /var/lib/apt/lists/*

# GA version 5.8.2
RUN wget -q -nc --no-check-certificate -P /var/tmp https://github.com/GlobalArrays/ga/releases/download/v5.8.2/ga-5.8.2.tar.gz && \
    tar -x -f /var/tmp/ga-5.8.2.tar.gz -C /var/tmp -z && \
    cd /var/tmp/ga-5.8.2 && \
    CC=mpicc CXX=mpicxx FC=mpifort ./configure --enable-i8 --with-blas8 --with-lapack8 --with-scalapack8 --prefix=/usr/local/ga && \
    make -j$(nproc) && make -j$(nproc) install && \
    rm -rf /var/tmp/ga-5.8.2 /var/tmp/ga-5.8.2.tar.gz
ENV GAROOT=/usr/local/ga \
    LD_LIBRARY_PATH=/usr/local/ga/lib:$LD_LIBRARY_PATH \
    LIBRARY_PATH=/usr/local/ga/lib:$LIBRARY_PATH \
    CPATH=/usr/local/ga/include:$CPATH \
    PATH=/usr/local/ga/bin:$PATH

# MKL version 2024.1.0
RUN wget -q -nc --no-check-certificate -P /var/tmp https://registrationcenter-download.intel.com/akdlm/IRC_NAS/2f3a5785-1c41-4f65-a2f9-ddf9e0db3ea0/l_onemkl_p_2024.1.0.695_offline.sh && \
    sh /var/tmp/l_onemkl_p_2024.1.0.695_offline.sh -a --silent --eula accept && \
    rm /var/tmp/l_onemkl_p_2024.1.0.695_offline.sh
ENV MKLROOT=/opt/intel/oneapi/mkl/2024.1

# GSL version 2.7.1
RUN wget -q -nc --no-check-certificate -P /var/tmp https://ftp.gnu.org/gnu/gsl/gsl-2.7.1.tar.gz && \
    tar -x -f /var/tmp/gsl-2.7.1.tar.gz -C /var/tmp -z && \
    cd /var/tmp/gsl-2.7.1 && CC=gcc CXX=g++ FC=gfortran ./configure --prefix=/usr/local/gsl && \
    make -j$(nproc) && make -j$(nproc) install && \
    rm -rf /var/tmp/gsl-2.7.1 /var/tmp/gsl-2.7.1.tar.gz
ENV PATH=/usr/local/gsl/bin:$PATH \
    CPATH=/usr/local/gsl/include:$CPATH \
    LIBRARY_PATH=/usr/local/gsl/lib:$LIBRARY_PATH \
    LD_LIBRARY_PATH=/usr/local/gsl/lib:$LD_LIBRARY_PATH \
    GSL_INCLUDE_DIR=/usr/local/gsl/include \
    GSL_LIBRARY=/usr/local/gsl/lib


# OpenMolcas version 24.02
RUN wget -q -nc --no-check-certificate -P /var/tmp https://gitlab.com/Molcas/OpenMolcas/-/archive/v24.02/OpenMolcas-v24.02.tar.gz && \
    tar -x -f /var/tmp/OpenMolcas-v24.02.tar.gz -C /var/tmp -z && \
    cd /var/tmp/OpenMolcas-v24.02 && \
    mkdir build && cd build && \
    CC=mpicc CXX=mpicxx FC=mpifort cmake -DCMAKE_INSTALL_PREFIX=/usr/local/openmolcas -DDMRG=ON -DMPI=ON -DGA=ON -DHDF5=ON -DLINALG=MKL -DOPENMP=ON ../ && \
    make -j$(nproc) && make -j$(nproc) install && \
    rm -rf /var/tmp/OpenMolcas-v24.02 /var/tmp/OpenMolcas-v24.02.tar.gz
ENV LD_LIBRARY_PATH=/usr/local/openmolcas/lib:$LD_LIBRARY_PATH \
    LIBRARY_PATH=/usr/local/openmolcas/lib:$LIBRARY_PATH \
    PATH=/usr/local/openmolcas:/usr/local/openmolcas/bin:/usr/local/openmolcas/sbin:$PATH \
    OPENMOCLASROOT=/usr/local/openmolcas

ENV OMPI_ALLOW_RUN_AS_ROOT=1 \
    OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
