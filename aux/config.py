from os import environ


def load_env():
    try:
        # Define credenciais de conexão com o banco de dados
        environ['HOST'] = "localhost"
        environ['DB'] = "MercuryDW"
        environ['USER'] = "PyCharm"
        environ['PW'] = "password"

        # Define credenciais da API do Spotify
        environ['SPOTIPY_CLIENT_ID'] = 'your_client_id'
        environ['SPOTIPY_CLIENT_SECRET'] = 'your_client_secret'
        environ['SPOTIPY_REDIRECT_URI'] = 'http://localhost:1234/'

    except Exception as e:
        print(f"Erro ao definir variáveis de ambiente: {e}")
