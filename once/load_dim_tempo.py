from etl import pd, pg, MetaData, date, create_engine, getenv, load_env
import holidays


def load_dim_hora():
    """
    Gera a dim_hora, um DataFrame com os horários e o nome do período
    :return: DataFrame
    """
    horas = pd.date_range(start='00:00', end='23:00', freq='H').strftime('%H:%M')
    dim_hora = pd.DataFrame({'hora': horas,
                             'periodo':
                                 ['Madrugada' if (int(h[:2]) < 5 or int(h[:2]) >= 23) else 'Manhã'
                                 if int(h[:2]) < 12 else 'Tarde' if int(h[:2]) < 18 else 'Noite'
                                 if int(h[:2]) < 23 else 'Dia' for h in horas]
                             })
    return dim_hora


# 2023-07-11 data inicial
def load_dim_data():
    """
    Gera a dim_data, um DataFrame com todos os dia, mês, ano, dia útil, não útil, feriado e nome do feriado.
    :return: DataFrame
    """
    datas = pd.date_range(start='2021-01-01', end='2021-12-31')
    feriados = holidays.country_holidays(country='BR', state='RJ', years=2022)
    dim_data = pd.DataFrame({'date': datas,
                             'year': datas.year,
                             'month': datas.month,
                             'day': datas.day,
                             'weekday': datas.day_name(),
                             'workday': ~(datas.day_name().isin(['Saturday', 'Sunday'])),
                             'holiday': [date(d.year, d.month, d.day) in feriados for d in datas],
                             'holiday_name': [feriados.get(d.strftime('%Y-%m-%d')) if d.strftime(
                                 '%Y-%m-%d') in feriados else '' for d in datas]
                             })
    return dim_data


def load_dim_tempo_stage(dim_data, dim_hora):
    """
    Realiza a carga no Stage das dimensões criadas
    :param dim_data: DataFrame
    :param dim_hora: DataFrame
    :return: None
    """
    metadata = MetaData(schema="stage")
    with pg.connect(host=getenv('HOST'), dbname=getenv('DB'), user=getenv('USER'), password=getenv('PW')) as conn:
        engine = create_engine('postgresql+psycopg2://', creator=lambda: conn)
        dim_data.to_sql('stg_dim_tempo', con=engine, if_exists='replace', index=False, schema=metadata.schema)
        dim_hora.to_sql('stg_dim_hora', con=engine, if_exists='replace', index=False, schema=metadata.schema)


load_env()
load_dim_tempo_stage(load_dim_data(), load_dim_hora())
