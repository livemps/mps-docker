FROM debian
RUN apt update --yes && apt upgrade --yes
RUN apt install --yes git build-essential
RUN git clone https://github.com/livemps/mps-docker /mps
RUN cd /mps && git pull && make install
USER mps
WORKDIR /home/mps
#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/bin/bash"]
