#!/bin/bash
#
#
# This script starts Elasticsearch and
# waits for it to run before starting
# Kibana. Enjoy!
#
# It's best to use OpenJDK instead of Oracle's Java
# 

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin;
#export PATH=$PATH:/home/user/logstash/jdk1.8.0_11/bin;   # It doesn't like this java version
#export PATH=$PATH:/home/user/logstash/jre1.8.0_45/bin;   # It doesn't like this one either




function elasticsearch-start(){ 
    if [ -a /usr/share/elasticsearch/bin/elasticsearch ];
    then until [ "$elasticsearch" == "Running" ];
	 do ps -ef | grep elasticsearch | grep java 2>/dev/null >/dev/null;
	    if [ $? -eq 0 ];
	    then while true;
		 do netstat -anltp | grep LISTEN | grep -P "(9200|9300)" | grep -P "java" 2>/dev/null >/dev/null;
		    if [ $? -eq 0 ];
		    then echo "";
			 echo "[*] Elasticsearch : running";
			 echo "";
			 elasticsearch=Running;
			 break;
		    fi
		 done;
	    fi;

	    /usr/share/elasticsearch/bin/elasticsearch > /dev/null 2> /dev/null &
	 done;

	 
    else echo "[ERROR] Elasticsearch not installed";
	 exit 1;
    fi;
};


function kibana-start(){
    if [ -a /home/user/logstash/kibana-4.0.2-linux-x64/bin/kibana ];
    then until [ "$kibana" == "Running" ];
	 do ps -ef | grep kibana | grep node 2>/dev/null >/dev/null;
	    if [ $? -eq 0 ];
	    then while true;
		 do netstat -anltp | grep LISTEN | grep 5601 | grep node 2>/dev/null >/dev/null;
		    if [ $? -eq 0 ];
		    then echo "";
			 echo "[*] Kibana : running";
			 echo "";
			 kibana=Running
			 break;
		    fi
		 done;
	    fi;

	    /home/user/logstash/kibana-4.0.2-linux-x64/bin/kibana &
	    #sh /var/www/kibana/bin/kibana &
	 done;

	 
    else echo "[ERROR] Kibana not found";
	 exit 1;
    fi;
};




if [ "$1" == "-k" ];
then kill -HUP `pidof java` 2>/dev/null;
     if [ $? -eq 2 ];
     then echo "[*] Elasticsearch : no processes found";
     else echo "[*] Elasticsearch : killed"; fi;
     
     kill -HUP `pidof node` 2>/dev/null;
     if [ $? -eq 2 ];
     then echo "[*] Kibana : no processes found";
     else echo "[*] Kibana : killed"; fi;
else 
    elasticsearch-start;
    kibana-start;
fi;
