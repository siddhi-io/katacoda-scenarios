export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

echo "Download siddhi-tooling-5.1.2.zip"
wget  -q --show-progress https://github.com/siddhi-io/distribution/releases/download/v5.1.2/siddhi-tooling-5.1.2.zip

echo "Unzip siddhi-tooling-5.1.2.zip"
unzip siddhi-tooling-5.1.2.zip | awk 'BEGIN {ORS=" "} {if(NR%20==0)print "."}'

echo "Start Siddhi Editor"
./siddhi-tooling-5.1.2/bin/tooling.sh
