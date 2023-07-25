# Note: This Dockerfile isn't productive, only works if you COPY .cache with the Spotify Token

FROM python:3.10-slim
RUN apt-get update && apt-get -y install cron vim
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
EXPOSE 1234
# Uncomment this line if you have a .cache file
# COPY .cache /app/
COPY etl.py config.py util.py /app/
WORKDIR /app
CMD ["cron","-f"]
