import * as THREE from "three";

window.loadEnvironment = async function (topLeftCorner) {
  const gltf = await loadModel("../glbs/industry.glb");
  const model = gltf.scene;
  const modelBoundingBox = new THREE.Box3().setFromObject(model);
  const modelSize = new THREE.Vector3();
  modelBoundingBox.getSize(modelSize);
  model.position.set(
    topLeftCorner.x + modelSize.z / 2 - 25,
    0,
    topLeftCorner.z + modelSize.x / 2 - 20
  );
  scene.add(model);
  addSkyDome();
  createWaterEffect();
  createLand();
  await createCustomRoad();
};

function createLand() {
  // Create land geometry
  const landGeometry = new THREE.BoxGeometry(1200, 1800, 50, 100, 100); // Adjust size & resolution

  // Load textures
  const textureLoader = new THREE.TextureLoader();
  const landTexture = textureLoader.load("./land.jpg");

  // Configure texture properties
  landTexture.wrapS = landTexture.wrapT = THREE.RepeatWrapping;
  landTexture.repeat.set(10, 10); // Adjust for tiling effect

  // Create material with displacement for a natural terrain look
  const landMaterial = new THREE.MeshStandardMaterial({
    map: landTexture, // Color texture
    displacementScale: 20, // Adjust elevation strength
    roughness: 0.8, // Make it less reflective
    metalness: 0.1, // Slight metallic feel
  });

  // Create land mesh
  const land = new THREE.Mesh(landGeometry, landMaterial);
  land.rotation.x = -Math.PI / 2; // Make it horizontal
  land.position.set(299, -26, 0); // Position it slightly above water

  // Add to scene
  globalThis.land = land;
  scene.add(land);
}

async function createCustomRoad() {

  const barrierGltf = await loadModel("../glbs/automatic_boom_barriers.glb");
  const barrierModel = barrierGltf.scene;
  barrierModel.scale.set(2, 2, 2);
  barrierModel.position.set(270, 5, 222);
  scene.add(barrierModel);

  const points = [
    new THREE.Vector3(300, 1, 230),
    new THREE.Vector3(-170, 1, 230), // turn
    new THREE.Vector3(-200, 1, 200), // turn
    new THREE.Vector3(-200, 1, -52),
    new THREE.Vector3(-170, 1, -82),
    new THREE.Vector3(210, 1, -82),
    new THREE.Vector3(240, 1, -52),
    new THREE.Vector3(240, 1, 230),
  ];

  const curvePath = new THREE.CurvePath();
  curvePath.add(new THREE.LineCurve3(points[0], points[1]));
  curvePath.add(
    new THREE.QuadraticBezierCurve3(points[1], new THREE.Vector3(points[2].x, 1, points[1].z), points[2])
  );
  curvePath.add(new THREE.LineCurve3(points[2], points[3]));
  curvePath.add(
    new THREE.QuadraticBezierCurve3(points[3], new THREE.Vector3(points[3].x, 1, points[4].z), points[4])
  );
  curvePath.add(new THREE.LineCurve3(points[4], points[5]));
  curvePath.add(
    new THREE.QuadraticBezierCurve3(points[5], new THREE.Vector3(points[6].x, 1, points[5].z), points[6])
  );
  curvePath.add(new THREE.LineCurve3(points[6], points[7]));
  globalThis.curve = curvePath;

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
  
  const centerLineGeometry = new THREE.BufferGeometry().setFromPoints(centerLinePoints);
  const centerLine = new THREE.Line(centerLineGeometry, centerLineMaterial);
  centerLine.computeLineDistances(); // Needed for dashed lines to work
  
  scene.add(centerLine);

  const shape = new THREE.Shape();
  shape.moveTo(-8, 0); // Half road width to the left
  shape.lineTo(8, 0); // Half road width to the right
  shape.lineTo(8, 0.1); // Small height (or 0 for perfectly flat)
  shape.lineTo(-8, 0.1); //
  shape.closePath();

  const extrudeSettings = {
    steps: 5000, // Number of segments along the curve
    depth: 0, // Set depth to 0 for a flat road
    extrudePath: curve,
  };

  const geometry = new THREE.ExtrudeGeometry(shape, extrudeSettings);
  
  const material = new THREE.MeshLambertMaterial({ color: 0x000000 });
  material.needsUpdate = true;
  const road = new THREE.Mesh(geometry, material);
  globalThis.road = road;
  scene.add(road);
}
