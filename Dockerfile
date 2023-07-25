FROM python:3-slim
RUN apt-get update && apt-get -y install cron vim
COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt
EXPOSE 1234
COPY etl.py config.py util.py /app/
WORKDIR /app
CMD ["cron", "-f"]
