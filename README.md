# OpenMolcas_container

This is a Dockerfile based on `Ubuntu22.04` for OpenMolcas with the DMRG (Density Matrix Renormalization Group) option activated

**Version v1.0.0** of the Dockerfile corresponds to **OpenMolcas 24.02** with **GSL 2.7.1**, **MKL 2024.1.0**, **GA 5.8.2**, **OpemMPI 4.1.2** and **GCC 11.4.0**


## Option A- Build the container yourself

1. Build the Docker image using `docker build --progress=plain -t openmolcas_dmrg_mkl -f Dockerfile .`

2. Save the image `docker save openmolcas_dmrg_mkl -o openmolcas_dmrg_mkl.tar`

3. Convert it to Singularity Image File `apptainer build openmolcas_dmrg_mkl.sif docker-archive://openmolcas_dmrg_mkl.tar`

## Option B- Pull the latest pre-build image 

Prebuild images are made available from https://quay.io/repository/jeani/openmolcas_dmrg

1. with Docker: `docker pull quay.io/jeani/openmolcas_dmrg:latest`

2. with Apptainer (or Singulalrity): `apptainer pull docker://quay.io/jeani/openmolcas_dmrg:latest`
