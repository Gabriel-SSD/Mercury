from datetime import date, datetime, timedelta
from time import time
from pytz import timezone


def get_date():
    return date.today().strftime("%d/%m/%Y")


def timestamp(hours):
    return int((datetime.now() - timedelta(hours=hours)).timestamp() * 1000)


def current_timestamp():
    return int(time() * 1000)


def to_ms(date_str):
    return int(datetime.fromisoformat(date_str.replace('Z', '+00:00')).timestamp()) * 1000


def to_date(ms):
    return datetime.fromtimestamp(int(ms) / 1000).strftime("%d/%m %Hh%M")


def convert_to_datetime(date_str):
    dt = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
    return dt.astimezone(timezone('America/Sao_Paulo')).strftime("%Y-%m-%d %H:%M:%S")
