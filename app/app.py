from flask import Flask, jsonify, request
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)

# In-memory todo list
todos = []

@app.route('/')
def home():
    return "Welcome to Cloud City Todo API!"

@app.route('/todos', methods=['GET'])
def get_todos():
    return jsonify(todos)

@app.route('/todos', methods=['POST'])
def add_todo():
    task = request.form.get('task')
    if task:
        todos.append(task)
        return jsonify({"message": "Todo added"}), 201
    return jsonify({"error": "Task required"}), 400

@app.route('/todos/<int:index>', methods=['DELETE'])
def delete_todo(index):
    if 0 <= index < len(todos):
        del todos[index]
        return jsonify({"message": "Todo deleted"}), 200
    return jsonify({"error": "Invalid index"}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)