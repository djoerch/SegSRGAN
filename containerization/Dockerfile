FROM tensorflow/tensorflow:1.13.1-gpu-py3

ARG username=user
ARG userid=1000

# install dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y build-essential \
    && apt-get install -y git

RUN apt-get install -y nano

# setup user account
RUN useradd -u ${userid} -ms /bin/bash ${username}

USER ${username}

WORKDIR /home/${username}
