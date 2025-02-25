# Meshtainers - Work in Progress

Experiments with using containers to simplifiy the building of nodes in an SDE data mesh.

All of these processes keep data within the container image. If you wish to store data outside of the container you can mount a docker volume or bind a local folder. [Instructions to follow].

N.B You do not need to build these images if you are a node in the KMS SDE, you will be provided with a pre-built image configured to load, process, and serve your specific data products.

## Data and Pipeline Containers

The Docker Bake file empty-omop-bake.hcl can be used to create containerised Postgres databases to hold OMOP data. The file specifies three targets as detialed below. The default target builds all three.

### vocabs target
This build processes takes a vocabulary zip file as downloaded from Athena and processes it to produce a new vocabulary zip file suitable for use within the SDE. Currently this process just applies transformation of the CPT4 concepts as described in the readme text file included in the Athena zip file.

To use this image:
* Get a ULMS API Key and save it to a file call ulms_api_key in the root folder of this project.
* Download your chosen vocabularies from Athena, rename the zip file to vocabs.zip, and place it in the pipeline_containers/prep_vocabs folder.
* Run `docker buildx bake -f empty-omop-bake.hcl vocabs`
* An image called meshtainer/kms_vocabs will be built.
* A zipfile called prepped_vocabs.zip will be created and copied to the /vocabs folder of the image. You can mount this folder before building if you want the zipped file to be created outside of the container.

### cdm target
This target builds a postgres database with the OMOP CDM tables created under a schema called cdm in a database called omop54. A username of omop is created to administer this database. No constraints are added to the database and no vocabularies are loaded. The DDL to create the tables will be downloaded from the OHDSI Github repository.

To use this image:
* Generate a postgres admin password and place it in a file called postgres_password in the root folder of this project.
* Run `docker buildx bake -f empty-omop-bake.hcl cdm`.
* An image called meshtainer/cdm_postgres will be created.
* The Postgres data files will be created in the \data folder of the image. Mount this folder before build if you want the data files to be created outside of the container image.

### omop target
This target uses the meshtainer/kms_vocabs image and the meshtainer/cdm_postgres image to create an image with a postgres OMOP database with the vocabularies loaded but without any constraints added i.e. an OMOP database ready for data to be loaded.
This image is intended to be used as the base image for omop nodes in the SDE Mesh.

To use this image:
* Ensure that the vocabs and cdm targets are built or ready to be built i.e. You have a vocabulary zip file from Athena, you have set up your ULMS API Key and Postgres password files.
* Run `docker buildx bake -f empty-omop-bake.hcl omop`.
* An image called meshtainers/omop_postgres will be built.
* The Postgres data files will be created in the \data folder of the image. Mount this folder before build if you want the data files to be created outside of the container image.


## Service Containers

### TODO. 
This container will use serviced to run Postgres, Bunny and a Trino Node in a single container built from a previosuly created data container base image.