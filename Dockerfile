### Build and install packages
FROM python:3.7 as build-python

# Install Python dependencies
COPY requirements.txt /app/
WORKDIR /app
RUN pip3 install virtualenv
RUN virtualenv /opt/venv --python=python3
RUN . /opt/venv/bin/activate && pip install -r requirements.txt
COPY . /app

### Final image
FROM nginx/unit:1.18.0-python3.7
COPY --from=build-python /opt/venv /opt/venv
COPY --from=build-python /app /app

WORKDIR /app

ENV PYTHONUNBUFFERED 1
ENV PATH="/opt/venv/bin:$PATH" 
COPY hellodjango/unit/config.json /docker-entrypoint.d/

