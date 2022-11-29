# umls-docker
A step-by-step guide and scripts to build a MySQL docker image with UMLS, UML-Interface and UMLS-Similarity.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![Docker](https://img.shields.io/badge/docker-v20.10.17+-blue.svg)
![MySQL](https://img.shields.io/badge/MySQL-v5.5-blue.svg)
![UMLS](https://img.shields.io/badge/UMLS-v2022-blue.svg)
[![License](https://img.shields.io/badge/license-Apache2-green.svg)](https://www.apache.org/licenses/LICENSE-2.0)


## Prepare the environment to create the Docker image:
1. Install [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/)
1. Clone this repo:
    ````
    git clone https://github.com/cbadenes/umls-docker.git
    ````
1. Move into the root directory:
    ````
    cd umls-docker
    ````
1. Download the [UMLS Metathesaurus Full Subset](https://www.nlm.nih.gov/research/umls/index.html) (File Size: compressed- 5GB, uncompressed-32.8GB) and extract the contents into this directory. You will probably have to use [Metamorphosys](https://www.nlm.nih.gov/research/umls/implementation_resources/metamorphosys/help.html) to generate the bbdd dumps. Move folders `META/` and `NET/` into this directory.
1. Download the [UMLS-Interface API](https://cpan.metacpan.org/authors/id/B/BT/BTMCINNES/UMLS-Interface-1.51.tar.gz ) and extract the contents into this directory. Folder `UMLS-Interface-1.51` is created.
1. Download the [UMLS-Similarity API](https://cpan.metacpan.org/authors/id/B/BT/BTMCINNES/UMLS-Similarity-1.47.tar.gz ) and extract the contents into this directory. Folder `UMLS-Similarity-1.47` is created.

## Create a Docker image with both the UMLS Knowledge and the related services:
1. With Docker Daemon running execute command:
	````
    docker build -t umls-mysql -f Dockerfile .
    ````
   If you have an ARM architecture (e.g. Mac M1), use the `dockerfile-arm` descriptor: 
    ````
    docker build -t umls-mysql -f Dockerfile-arm .
    ````
   It will take a few minutes to create the image.

## Load UMLS data and prepare interfaces
1. Deploy the image via docker compose:
    ````
    docker compose up -d
    `````
1. The UMLS database will not be available instantly. Once the container is running the database will load and MySQL will be restarted. To check if database is available you can search for the log trace `mysqld: ready for connections` by:
    ````
    docker compose logs
    ````` 
1. Edit the file `META/populate_mysql_db.sh` to replace corresponding lines with following: 
    ````
	- MYSQL_HOME=/usr 
	- user=root 
	- password= 
	- db_name=umls
	- In each lne starting with $MYSQL_HOME/bin/mysql replace  
        -vvv -u $user -p $password 
	with 
        -vvv --local-infile
    ```` 
1. Edit the file `NET/populate_netmysql_db.sh` to replace corresponding lines with following: 
    ````
	- MYSQL_HOME=/usr 
	- user=root 
	- password= 
	- db_name=umls
	- In each lne starting with $MYSQL_HOME/bin/mysql replace  
        -vvv -u $user -p $password 
	with 
        -vvv --local-infile
    ````
1. Once the file are updated you can connect to the container via:
    ````
    docker exec -it umlsdb /bin/bash
    `````
1. Edit the file `/etc/mysql/my.cnf` and add the following properties:
    ````
    [mysqld]
     key_buffer=600M
     table_cache=300
     query_cache_limit=3M
     query_cache_size=100M
     read_buffer_size=200M
     myisam_sort_buffer_size=200M
     bulk_insert_buffer_size=100M
     join_buffer_size=100M
    ````
1. Enables execution permissions for `/umls_init.sh` by means of:
    ````
    chmod +x umls_init.sh
    `````
1. And finally load the UMLS information via:
    ````
    ./umls_init.sh
    `````
    This process can take hours.


## Calculates similarities between UMLS terms

1. Enter the container by means of:
    ````
    docker exec -it umlsdb /bin/bash
    `````
1. Calculates the similarity between terms (e.g. `paracetamol` and `diarrhea`):
    ````
    ulms-similarity.pl paracetamol diarrhea
    `````
    it returns `0.0833<>paracetamol(C0000970)<>diarrhea(C0011991)`
1. Or calculate the similarity between CUI codes (e.g. `C0000970` and `C0011991`):
	````
    ulms-similarity.pl C0000970 C0011991
    `````
    it returns `0.0833<>C0000970(paracetamol)<>C0011991(Diarrhea NOS)`
