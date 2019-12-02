export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

echo "Download siddhi-tooling-5.1.1.zip"
wget https://github.com/suhothayan/distribution/releases/download/5.2.0-v4/siddhi-tooling-5.2.0-SNAPSHOT.zip

echo "Unzip siddhi-tooling-5.2.0-SNAPSHOT.zip"
unzip siddhi-tooling-5.2.0-SNAPSHOT.zip

echo "Start Siddhi Editor"
./siddhi-tooling-5.2.0-SNAPSHOT/bin/tooling.sh
