import * as THREE from "three";

window.buildRoad = async function (points) {
  globalThis.curve = createPath(points);

  const centerLineMaterial = new THREE.LineDashedMaterial({
    color: 0xffffff, // White color for dashed lines
    dashSize: 10, // Length of each dash
    gapSize: 10, // Space between dashes
    linewidth: 3,
  });

  const centerLinePoints = [];
  const divisions = 100; // Number of dashes
  for (let i = 0; i <= divisions; i++) {
    const t = i / divisions;
    const point = curve.getPoint(t);
    centerLinePoints.push(new THREE.Vector3(point.x, point.y + 0.05, point.z)); // Slightly raised
  }

  const centerLineGeometry = new THREE.BufferGeometry().setFromPoints(
    centerLinePoints
  );
  const centerLine = new THREE.Line(centerLineGeometry, centerLineMaterial);
  centerLine.computeLineDistances(); // Needed for dashed lines to work

  scene.add(centerLine);

  const shape = new THREE.Shape();
  shape.moveTo(-15, 0); // Half road width to the left
  shape.lineTo(15, 0); // Half road width to the right
  shape.lineTo(15, 0.1); // Small height (or 0 for perfectly flat)
  shape.lineTo(-15, 0.1); //
  shape.closePath();

  const extrudeSettings = {
    steps: 5000, // Number of segments along the curve
    depth: 1, // Set depth to 0 for a flat road
    extrudePath: curve,
    curveSegments: 100, // Smoothness
    bevelEnabled: false, // No beveling
  };

  const geometry = new THREE.ExtrudeGeometry(shape, extrudeSettings);

  geometry.computeVertexNormals();

  const material = new THREE.MeshLambertMaterial({
    color: 0x000000,
    roughness: 0.8, // Adjust for more realistic material properties
    metalness: 0.1, // Road is not metallic
  });
  material.needsUpdate = true;
  const road = new THREE.Mesh(geometry, material);
  road.receiveShadow = true;
  globalThis.road = road;
  scene.add(road);
};

window.createPath = function (points) {
  const curvePath = new THREE.CurvePath();

  for (let i = 1; i < points.length; i++) {
    const prevPoint = Object.values(points[i - 1])[0]; // Previous point
    const currentPoint = Object.values(points[i])[0]; // Current point
    const key = Object.keys(points[i])[0]; // Key (e.g., 'straight', 'right', 'left')
    const y = Object.values(points[0])[0].y;

    if (key === "straight") {
      // Add a straight line
      curvePath.add(new THREE.LineCurve3(prevPoint, currentPoint));
    } else if (key === "right") {
      // Add a right turn (quadratic Bezier curve)
      let controlPoint;
      if (
        (currentPoint.x < prevPoint.x && currentPoint.z > prevPoint.z) ||
        (currentPoint.x > prevPoint.x && currentPoint.z < prevPoint.z)
      ) {
        controlPoint = new THREE.Vector3(prevPoint.x, y, currentPoint.z);
      } else {
        controlPoint = new THREE.Vector3(currentPoint.x, y, prevPoint.z);
      }
      curvePath.add(
        new THREE.QuadraticBezierCurve3(prevPoint, controlPoint, currentPoint)
      );
    } else if (key === "left") {
      // Add a left turn (quadratic Bezier curve)
      let controlPoint;
      if (
        (currentPoint.x < prevPoint.x && currentPoint.z > prevPoint.z) ||
        (currentPoint.x > prevPoint.x && currentPoint.z < prevPoint.z)
      ) {
        controlPoint = new THREE.Vector3(currentPoint.x, y, prevPoint.z);
      } else {
        controlPoint = new THREE.Vector3(prevPoint.x, y, currentPoint.z);
      }
      curvePath.add(
        new THREE.QuadraticBezierCurve3(prevPoint, controlPoint, currentPoint)
      );
    }
  }

  return curvePath;
};
