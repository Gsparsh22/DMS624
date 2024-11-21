def cheapest_path(graph, costs, start, end):
    # Costs graph should contain fare information
    priority_queue = [(0, start)]  # (cost, node)
    costs_from_start = {node: float('inf') for node in graph}
    costs_from_start[start] = 0
    previous_nodes = {node: None for node in graph}

    while priority_queue:
        current_cost, current_node = heapq.heappop(priority_queue)

        if current_node == end:
            break

        for neighbor, fare in costs[current_node].items():
            cost = current_cost + fare
            if cost < costs_from_start[neighbor]:
                costs_from_start[neighbor] = cost
                previous_nodes[neighbor] = current_node
                heapq.heappush(priority_queue, (cost, neighbor))

    # Reconstruct path
    path = []
    while end:
        path.append(end)
        end = previous_nodes[end]
    path.reverse()

    return path, costs_from_start[path[-1]]
