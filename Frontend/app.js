async function findShortestPath() {
    const start = document.getElementById("start").value;
    const end = document.getElementById("end").value;

    const response = await fetch('/shortest-path', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ start, end })
    });

    const data = await response.json();
    document.getElementById("output").innerHTML = `Shortest Path: ${data.path.join(' -> ')} (Distance: ${data.distance})`;
}

async function findCheapestPath() {
    const start = document.getElementById("start").value;
    const end = document.getElementById("end").value;

    const response = await fetch('/cheapest-path', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ start, end })
    });

    const data = await response.json();
    document.getElementById("output").innerHTML = `Cheapest Path: ${data.path.join(' -> ')} (Cost: ${data.cost})`;
}