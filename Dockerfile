FROM flink:latest

# install python3: it has updated Python to 3.9 in Debian 11 and so install Python 3.7 from source
# it currently only supports Python 3.6, 3.7 and 3.8 in PyFlink officially.

ENV PYTHON_VERSION="3.8" 
ENV LOCALSTACK_HOST="host.docker.internal"
ENV DEFAULT_REGION="us-east-1"

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

RUN apt-get install -y awscli git software-properties-common

RUN touch /etc/apt/apt.conf.d/99verify-peer.conf \
&& echo >>/etc/apt/apt.conf.d/99verify-peer.conf "Acquire { https::Verify-Peer false }"

RUN apt update -y
RUN apt install default-jdk -y
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install python3.8 python3.8-dev python3.8-distutils python3.8-venv -y

# install PyFlink and other python packages in virtual environment
COPY requirements.txt "/tmp/"
RUN python3.8 -m venv /opt/virtualenv
RUN . /opt/virtualenv/bin/activate && pip install -r /tmp/requirements.txt
ENTRYPOINT ["tail", "-f", "/dev/null"]