import * as THREE from "three";

window.createNodes = function () {
  class Node {
    constructor(name, point) {
      this.name = name;
      this.point = point;
      this.adjacent = [];
    }
  }

  globalThis.truckNodes = [];
  globalThis.truckPoints = {};
  globalThis.truckPointsAdjacencyList = {};

  let initialPoint = new THREE.Vector3(760, 1, 200);

  for (let i = 0; i < 500; i++) {
    const key = "r" + (i + 1);
    truckPoints[key] = new THREE.Vector3(
      initialPoint.x - i,
      initialPoint.y,
      initialPoint.z
    );
  }

  const startPoint = truckPoints["r500"]; // Last point of first segment
  const endPoint = new THREE.Vector3(240, 1, 170); // First point of second segment
  const controlPoint = new THREE.Vector3(240, 1, 195); // Adjust this for smoother transition

  let nextIndex = generateBezierCurve(
    501,
    startPoint,
    controlPoint,
    endPoint,
    "r"
  );

  // Generate second straight segment, continuing from the Bézier curve
  initialPoint = truckPoints["r" + (nextIndex - 1)]; // Use last point from Bézier curve
  for (let i = nextIndex; i < nextIndex + 250; i++) {
    const key = "r" + i;
    truckPoints[key] = new THREE.Vector3(
      initialPoint.x,
      initialPoint.y,
      initialPoint.z - (i - nextIndex)
    );
  }

  const startPoint1 = truckPoints["r" + (nextIndex - 1 + 250)]; // Last point of first segment
  const endPoint1 = new THREE.Vector3(215, 1, -82); // First point of second segment
  const controlPoint1 = new THREE.Vector3(240, 1, -82); // Adjust this for smoother transition

  nextIndex = generateBezierCurve(
    nextIndex + 250,
    startPoint1,
    controlPoint1,
    endPoint1,
    "r"
  );

  const startPoint2 = new THREE.Vector3(240, 1, 167); // Last point of first segment
  const endPoint2 = new THREE.Vector3(215, 1, 149); // First point of second segment
  const controlPoint2 = new THREE.Vector3(240, 1, 149); // Adjust this for smoother transition

  let aNextIndex = generateBezierCurve(
    1,
    startPoint2,
    controlPoint2,
    endPoint2,
    "a"
  );

  initialPoint = new THREE.Vector3(214, 1, 149); // Use last point from Bézier curve
  for (let i = aNextIndex; i < aNextIndex + 300; i++) {
    const key = "a" + i;
    truckPoints[key] = new THREE.Vector3(
      initialPoint.x - (i - aNextIndex),
      initialPoint.y,
      initialPoint.z
    );
  }

  addTruckPointsToScene();

  // adjacency list
  truckPointsAdjacencyList["Node_r1"] = ["Node_r2"];
  for (let i = 2; i < 501; i++) {
    const node = "Node_r" + i;
    const rightNode = "Node_r" + (i - 1);
    const leftNode = "Node_r" + (i + 1);
    truckPointsAdjacencyList[node] = [rightNode, leftNode];
  }

  for (let i = 501; i < nextIndex; i++) {
    const node = "Node_r" + i;
    const rightNode = "Node_r" + (i - 1);
    const leftNode = "Node_r" + (i + 1);
    truckPointsAdjacencyList[node] = [rightNode, leftNode];
  }
  truckPointsAdjacencyList["Node_r800"] = ["Node_r799"];

  truckPointsAdjacencyList["Node_r567"].push("Node_a1");
  truckPointsAdjacencyList["Node_a1"] = ["Node_a2", "Node_r567"];
  for (let i = 2; i < aNextIndex + 300 - 1; i++) {
    const node = "Node_a" + i;
    const rightNode = "Node_a" + (i - 1);
    const leftNode = "Node_a" + (i + 1);
    truckPointsAdjacencyList[node] = [rightNode, leftNode];
  }
  truckPointsAdjacencyList["Node_a" + (aNextIndex + 300 - 1)] = [
    "Node_a" + (aNextIndex + 300 - 2),
  ];

  console.warn("last point " + "a" + (aNextIndex + 300));

  for (let truckPoint in truckPoints) {
    const point = truckPoints[truckPoint];
    const nodeName = `Node_${truckPoint}`;
    truckNodes.push(new Node(nodeName, point));
  }

  globalThis.nodeMap = new Map(truckNodes.map((node) => [node.name, node]));

  for (const [nodeName, adjacentNames] of Object.entries(
    truckPointsAdjacencyList
  )) {
    const node = nodeMap.get(nodeName);
    if (node) {
      node.adjacent = adjacentNames.map((adjName) => nodeMap.get(adjName));
    } else {
      console.error(`Node ${nodeName} is missing in nodeMap.`);
    }
  }
};

window.getShortestPath = function (points, agentGroup, lineColor) {
  let finalPath = [];
  let combinedPath = [];
  let pathLine = [];

  const checkpoints = setupCheckpoints(points);
  const nodesToVisit = findNodeNamesForPoints(checkpoints, truckNodes);

  console.warn("nodesToVisit", nodesToVisit);
  const { distMatrix, pathMatrix } = computeDistanceMatrix(
    nodesToVisit,
    nodeMap
  );
  const { minDist, path } = findShortestPath(
    nodesToVisit,
    distMatrix,
    nodesToVisit[0],
    nodesToVisit[nodesToVisit.length - 1]
  );
  console.warn("Shortest Path Distance:", minDist, path, pathMatrix);

  for (let i = 0; i < path.length - 1; i++) {
    let start = path[i];
    let end = path[i + 1];
    finalPath = [...finalPath, ...pathMatrix[start][end]];
  }

  visualizePath(finalPath.map((name) => nodeMap.get(name).point));

  if (finalPath != []) {
    combinedPath = [nodeMap.get(finalPath[0]).point];
    let start = finalPath[0];
    for (let i = 1; i < finalPath.length; i++) {
      if (start != finalPath[i]) {
        combinedPath.push(nodeMap.get(finalPath[i]).point);
      }
    }
    scene.add(agentGroup);
    agentGroup.position.set(
      combinedPath[0].x,
      combinedPath[0].y,
      combinedPath[0].z
    );
  }

  function findNodeNamesForPoints(randomPoints, nodes) {
    return randomPoints.map((point) => {
      return nodes.find((node) => {
        return (
          node.point.x === point.x &&
          node.point.y === point.y &&
          node.point.z === point.z
        );
      }).name;
    });
  }

  // breath-first-search is used to find the target node and its distance
  function bfs(startNode, targetNode) {
    const queue = [[startNode, [startNode.name]]]; // [currentNode, path] (path is an array of node names)
    const visited = new Set();

    while (queue.length > 0) {
      const [currentNode, path] = queue.shift(); // path will track the traversal sequence

      if (currentNode === targetNode)
        return { distance: path.length - 1, path }; // Return distance and the path

      if (visited.has(currentNode)) continue;

      visited.add(currentNode);

      for (const neighbor of currentNode.adjacent) {
        if (!visited.has(neighbor)) {
          queue.push([neighbor, [...path, neighbor.name]]);
        }
      }
    }

    return { distance: Infinity, path: [] }; // No path found
  }

  // calculates the distance between two nodes and maintains distnace and path matrices
  function computeDistanceMatrix(nodesToVisit, nodeMap) {
    const distMatrix = {};
    const pathMatrix = {}; // To store paths

    nodesToVisit.forEach((nodeName) => {
      distMatrix[nodeName] = {};
      pathMatrix[nodeName] = {}; // Initialize path for each node
      nodesToVisit.forEach((otherNodeName) => {
        if (nodeName !== otherNodeName) {
          const { distance, path } = bfs(
            nodeMap.get(nodeName),
            nodeMap.get(otherNodeName)
          );
          distMatrix[nodeName][otherNodeName] = distance;
          pathMatrix[nodeName][otherNodeName] = path;
        } else {
          distMatrix[nodeName][otherNodeName] = 0; // Distance to itself
          pathMatrix[nodeName][otherNodeName] = [nodeName]; // Path is just itself
        }
      });
    });

    return { distMatrix, pathMatrix };
  }

  function findShortestPath(nodesToVisit, distMatrix, startNode, endNode) {
    const n = nodesToVisit.length;
    const dp = Array(1 << n)
      .fill(null)
      .map(() => Array(n).fill(Infinity));
    const parent = Array(1 << n)
      .fill(null)
      .map(() => Array(n).fill(-1));
    const nodeIndex = nodesToVisit.reduce((map, name, index) => {
      map[name] = index;
      return map;
    }, {});

    // Ensure startNode and endNode are in nodesToVisit
    if (
      !nodeIndex.hasOwnProperty(startNode) ||
      !nodeIndex.hasOwnProperty(endNode)
    ) {
      throw new Error("Start or end node not found in nodesToVisit");
    }

    const startIdx = nodeIndex[startNode];
    const endIdx = nodeIndex[endNode];

    dp[1 << startIdx][startIdx] = 0; // Start at the fixed start node

    for (let mask = 1; mask < 1 << n; mask++) {
      for (let u = 0; u < n; u++) {
        if (!(mask & (1 << u))) continue; // Skip if `u` is not in the current mask

        for (let v = 0; v < n; v++) {
          if (u === v || !(mask & (1 << v))) continue; // Skip if `v` is not in the mask or same as `u`
          const prevMask = mask ^ (1 << u); // Remove `u` from the current mask
          const cost =
            dp[prevMask][v] + distMatrix[nodesToVisit[v]][nodesToVisit[u]];

          if (cost < dp[mask][u]) {
            dp[mask][u] = cost;
            parent[mask][u] = v; // Track parent for reconstruction
          }
        }
      }
    }

    // The ending point is fixed
    const mask = (1 << n) - 1; // All nodes visited
    const minDist = dp[mask][endIdx];

    // Reconstruct the path
    const finalPath = [];
    let lastNode = endIdx;
    let currentMask = mask;

    while (lastNode !== -1) {
      finalPath.unshift(nodesToVisit[lastNode]);
      const prevNode = parent[currentMask][lastNode];
      currentMask ^= 1 << lastNode; // Remove the last node from the mask
      lastNode = prevNode;
    }

    return { minDist, path: finalPath };
  }

  // mapping the points to the nodes
  function setupCheckpoints(points) {
    let targetPoints = [];
    for (let index in points) {
      targetPoints.push(truckPoints[points[index]]);
    }
    return targetPoints;
  }

  // Function to visualize the path
  function visualizePath(path) {
    for (let i = 0; i < path.length - 1; i++) {
      const start = path[i];
      const end = path[i + 1];

      // Calculate the distance and direction
      const direction = new THREE.Vector3().subVectors(end, start);
      const distance = direction.length();

      // Create a cylinder geometry for the tube
      const tubeGeometry = new THREE.CylinderGeometry(0.1, 0.1, distance, 32); // Adjust radius (0.1) for thickness
      const tubeMaterial = new THREE.MeshBasicMaterial({ color: lineColor });
      const segment = new THREE.Mesh(tubeGeometry, tubeMaterial);

      // Position the segment midpoint between start and end
      segment.position.copy(start.clone().add(end).multiplyScalar(0.5));

      // Align the segment with the direction vector
      segment.lookAt(end);

      // Adjust orientation to align with the correct axis (default cylinder points along Y-axis)
      segment.rotateX(Math.PI / 2);

      // Add to the scene
      // scene.add(segment);
      pathLine.push(segment);
    }
  }

  // moving the object from one to another
  async function move(delta) {
    if (!combinedPath || combinedPath.length <= 0) {
      // If no path is available, or if the path has been fully traversed, restart the animation
      console.warn("Path completed, restarting...");
      // Reset the combinedPath (or use the starting path)
      combinedPath = [nodeMap.get(finalPath[0]).point]; // Start from the beginning of the path
      let start = finalPath[0];
      for (let i = 1; i < finalPath.length; i++) {
        if (start !== finalPath[i]) {
          combinedPath.push(nodeMap.get(finalPath[i]).point);
        }
      }
      agentGroup.position.set(
        combinedPath[0].x,
        combinedPath[0].y,
        combinedPath[0].z
      ); // Reset agent position
    }

    if (combinedPath.length <= 0) {
      // Ensure there's still a path to traverse
      return;
    }

    const targetPosition = combinedPath[0];
    const direction = targetPosition.clone().sub(agentGroup.position);

    const distanceSq = direction.lengthSq();
    if (distanceSq > 0.05 * 0.05) {
      direction.normalize();
      // Calculate the target angle
      const targetAngle = Math.atan2(direction.x, direction.z);
      // Get current angle and calculate the shortest path
      let currentAngle = agentGroup.rotation.y;
      const angleDifference =
        THREE.MathUtils.euclideanModulo(
          targetAngle - currentAngle + Math.PI,
          Math.PI * 2
        ) - Math.PI;

      if (Math.abs(angleDifference) > 0.01) {
        currentAngle += angleDifference * delta * 20; // Smoothly interpolate rotation
        agentGroup.rotation.y = currentAngle;
      }
      const moveDistance = Math.min(delta * 50, Math.sqrt(distanceSq));
      agentGroup.position.add(direction.multiplyScalar(moveDistance));
    } else {
      agentGroup.position.copy(targetPosition);
      combinedPath.shift();
    }
  }

  // Game loop
  const clock = new THREE.Clock();
  const gameLoop = () => {
    move(clock.getDelta());
    requestAnimationFrame(gameLoop);
  };
  gameLoop();
  console.warn(clock);
};

// Function to generate Bézier curve points and update truckPoints
function generateBezierCurve(start, p0, p1, p2, prefix) {
  const totalLength = distance(p0, p2); // Approximate total curve length
  const stepCount = Math.max(2, Math.floor(totalLength)); // Ensure at least 2 steps
  const stepSize = 1 / stepCount;

  for (let t = 0; t <= 1; t += stepSize) {
    const x = (1 - t) * (1 - t) * p0.x + 2 * (1 - t) * t * p1.x + t * t * p2.x;
    const y = (1 - t) * (1 - t) * p0.y + 2 * (1 - t) * t * p1.y + t * t * p2.y;
    const z = (1 - t) * (1 - t) * p0.z + 2 * (1 - t) * t * p1.z + t * t * p2.z;

    const key = prefix + start; // Assign points in truckPoints correctly
    truckPoints[key] = new THREE.Vector3(x, y, z);

    start += 1;
  }

  return start; // Return the next available index
}

function distance(p1, p2) {
  return p1.distanceTo(p2);
}

function addTruckPointsToScene() {
  Object.entries(globalThis.truckPoints).forEach(([key, point]) => {
    // Create a small sphere for visualization
    const geometry = new THREE.SphereGeometry(0.2, 8, 8); // Radius = 1, smoothness = 8
    const material = new THREE.MeshBasicMaterial({ color: 0xff0000 }); // Red color
    const sphere = new THREE.Mesh(geometry, material);

    sphere.name = key; // Set name for identification

    // Position the sphere at the truck point location
    sphere.position.set(point.x, point.y, point.z);

    // Add to scene and store reference
    // scene.add(sphere);
  });
}
