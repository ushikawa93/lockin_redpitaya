from flask import Flask

app = Flask(__name__)

@app.route('/')
def bienvenida():
    return "¡Bienvenido a mi aplicación Flask!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
