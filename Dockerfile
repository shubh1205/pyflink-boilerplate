FROM flink:latest

# install python3: it has updated Python to 3.9 in Debian 11 and so install Python 3.7 from source
# it currently only supports Python 3.6, 3.7 and 3.8 in PyFlink officially.

ENV PYTHON_VERSION="3.9.9" 
ENV LOCALSTACK_HOST="host.docker.internal"
ENV DEFAULT_REGION="us-east-1"

RUN apt-get update -y && \
apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev awscli git libffi-dev && \
wget --no-check-certificate https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
tar -xvf Python-$PYTHON_VERSION.tgz && \
cd Python-$PYTHON_VERSION && \
./configure --without-tests --enable-shared && \
make -j6 && \
make install && \
ldconfig /usr/local/lib && \
cd .. && rm -f Python-$PYTHON_VERSION.tgz && rm -rf Python-$PYTHON_VERSION && \
ln -s /usr/local/bin/python3 /usr/local/bin/python && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# install PyFlink and other python packages
RUN pip3 install --upgrade pip
COPY requirements.txt "/tmp/"
RUN pip3 install -r /tmp/requirements.txt
ENTRYPOINT ["tail", "-f", "/dev/null"]