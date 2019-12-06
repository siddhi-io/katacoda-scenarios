export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

echo "Download siddhi-tooling-5.1.2-rc1.zip"
wget https://github.com/siddhi-io/distribution/releases/download/v5.1.2-rc1/siddhi-tooling-5.1.2-rc1.zip

echo "Unzip siddhi-tooling-5.1.2-rc1.zip"
unzip siddhi-tooling-5.1.2-rc1.zip

echo "Start Siddhi Editor"
./siddhi-tooling-5.1.2/bin/tooling.sh
