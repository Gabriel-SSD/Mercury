from etl import pd, pg, MetaData, date, create_engine, getenv
import holidays


def generate_dim_hora():
    horas = pd.date_range(start='00:00', end='23:00', freq='H').strftime('%H:%M')
    dim_hora = pd.DataFrame({'hora': horas,
                             'periodo': ['Madrugada' if (int(h[:2]) < 5 or int(h[:2]) >= 23) else 'Manhã' if int(
                                 h[:2]) < 12 else 'Tarde' if int(h[:2]) < 18 else 'Noite' if int(h[:2]) < 23 else 'Dia'
                                                for h in horas]
                             })
    return dim_hora


def generate_dim_tempo():
    datas = pd.date_range(start='2023-07-11', end='2023-12-31')
    feriados = holidays.country_holidays(country='BR', state='RJ', years=2023)
    dim_tempo = pd.DataFrame({'date': datas,
                              'year': datas.year,
                              'month': datas.month,
                              'day': datas.day,
                              'weekday': datas.day_name(),
                              'workday': ~(datas.day_name().isin(['Saturday', 'Sunday'])),
                              'holiday': [date(d.year, d.month, d.day) in feriados for d in datas],
                              'holiday_name': [feriados.get(d.strftime('%Y-%m-%d')) if d.strftime(
                                  '%Y-%m-%d') in feriados else '' for d in datas]
                              })
    return dim_tempo


def load_dim_tempo_stage(dim_tempo, dim_hora):
    metadata = MetaData(schema="stage")
    with pg.connect(host=getenv('HOST'), dbname=getenv('DB'), user=getenv('USER'),password=getenv('PW')) as conn:
        engine = create_engine('postgresql+psycopg2://', creator=lambda: conn)
        dim_tempo.to_sql('stg_dim_tempo', con=engine, if_exists='replace', index=False, schema=metadata.schema)
        dim_hora.to_sql('stg_dim_hora', con=engine, if_exists='replace', index=False, schema=metadata.schema)


load_dim_tempo_stage(generate_dim_tempo(), generate_dim_hora())
