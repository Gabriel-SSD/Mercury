from etl import pd, pg, MetaData, create_engine, get_tracks_features, getenv


def load_historical_tracks_features():
    """
    Função para realizar o reprocessamento histórico, obtendo todos os ids existentes na dim_track, e utiliza esses ids
    na chamada a API, retornando um DataFrame com as análises associadas a um track_id, e esse DataFrame é gravado em
    uma tablea no stage.
    """
    metadata = MetaData(schema="stage")
    with pg.connect(host=getenv('HOST'), dbname=getenv('DB'), user=getenv('USER'), password=getenv('PW')) as conn:
        engine = create_engine('postgresql+psycopg2://', creator=lambda: conn)
        with conn.cursor() as cursor:
            cursor.execute("""SELECT DISTINCT id FROM stage.stg_dim_track""")
            resultado = cursor.fetchall()
            tids = [item[0] for item in resultado]
    # Limite do endpoint é de 100 ids, portanto separei em lotes de 100
    t_features = [tids[i:i + 100] for i in range(0, len(tids), 100)]
    audiof = pd.concat([get_tracks_features(trackid) for trackid in t_features])
    audiof.to_sql('stg_track_features', con=engine, if_exists='replace', index=False, schema=metadata.schema)


load_historical_tracks_features()
