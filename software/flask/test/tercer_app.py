from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def multiplicar():
    resultado = None
    if request.method == 'POST':
        try:
            # Obtener el número del formulario
            numero = float(request.form['numero'])
            # Multiplicar por 3
            resultado = numero * 3
        except ValueError:
            resultado = "¡Error! Ingresa un número válido."
    # Renderizar la plantilla con el resultado
    return render_template('index2.html', resultado=resultado)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)