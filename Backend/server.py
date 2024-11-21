from flask import Flask, request, jsonify
from dijkstra import dijkstra
from cheapest_path import cheapest_path

app = Flask(__name__)

# Sample graph data
graph = {
    'A': {'B': 10, 'C': 3},
    'B': {'C': 1, 'D': 2},
    'C': {'B': 4, 'D': 8, 'E': 2},
    'D': {'E': 7},
    'E': {'D': 9}
}

costs = {  # For cheapest path
    'A': {'B': 2, 'C': 1},
    'B': {'C': 3, 'D': 6},
    'C': {'B': 1, 'D': 2, 'E': 1},
    'D': {'E': 4},
    'E': {'D': 3}
}

@app.route('/shortest-path', methods=['POST'])
def shortest_path():
    data = request.json
    start = data['start']
    end = data['end']
    path, distance = dijkstra(graph, start, end)
    return jsonify({"path": path, "distance": distance})

@app.route('/cheapest-path', methods=['POST'])
def cheapest_path_route():
    data = request.json
    start = data['start']
    end = data['end']
    path, cost = cheapest_path(graph, costs, start, end)
    return jsonify({"path": path, "cost": cost})

if __name__ == "__main__":
    app.run(debug=True)
