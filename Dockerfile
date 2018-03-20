FROM ubuntu:17.10

LABEL maintainer="Stefano Piazza"

# Set working directory in /
WORKDIR /app

# Install pip
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y curl apt-utils zip && \
    apt-get install -y python3-pip && \
    pip3 --no-cache-dir install --upgrade pip && \
    ln -s /usr/bin/python3 /usr/bin/python

# Add and install requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip3 --no-cache-dir install -r /tmp/requirements.txt

# Keras configuration
RUN mkdir /root/.keras
COPY keras.json /root/.keras

# PyTorch
RUN pip3 install http://download.pytorch.org/whl/cpu/torch-0.3.1-cp35-cp35m-linux_x86_64.whl
RUN pip3 install torchvision

# For Jupyterlab extensions
RUN apt-get -y install nodejs npm && \
    pip3 install ipywidgets && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Install other utilities I use often
RUN apt-get -y install locate vim fish less wget nodejs

EXPOSE 8888

VOLUME /app

CMD ["jupyter", "lab", "--ip='*'", "--port=8888", "--no-browser", \
    "--allow-root"]