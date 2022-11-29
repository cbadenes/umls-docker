echo "Creating database.."
/usr/bin/mysql -vvv --local-infile umls < create_database.sql >> mysql.log 2>&1

echo "Creating META tables.."
cd /META
chmod +x populate_mysql_db.sh
./populate_mysql_db.sh

echo "Creating NET tables.."
cd /NET
chmod +x populate_net_mysql_db.sh
./populate_net_mysql_db.sh

echo "Installing UMLS-Interface.."
cd /UMLS-Interface-1.51 
echo “Running perl Makefile.PL”
perl Makefile.PL 
echo “Running make”
make 
echo “Running make test”
make test
echo “Running sudo make install”
make install

echo "Installing UMLS-Similarity.."
cd /UMLS-Similarity-1.47 
echo “Running perl Makefile.PL”
perl Makefile.PL 
echo “Running make”
make 
echo “Running make test”
make test
echo “Running sudo make install”
make install


