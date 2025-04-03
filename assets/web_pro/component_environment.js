import * as THREE from "three";

window.loadEnvironment = async function (topLeftCorner) {

  const gltf = await loadModel("../glbs/office1.glb");
  const model = gltf.scene;
  scene.add(model);
  await addSkyDome();
  createLand();
  // await loadSurroundings();
  // await loadHysterStacker();
  // await loadTruck();
  // await addParkingArea();
  // addClouds();
  // addFencing();
  // await createCustomRoad();
};

function createLand() {
  // 🌱 Load Ground Textures
  const textureLoader = new THREE.TextureLoader();
  const groundTexture = textureLoader.load("ground.jpg"); // Replace with your texture path
  groundTexture.wrapS = groundTexture.wrapT = THREE.RepeatWrapping;
  groundTexture.repeat.set(10, 10);

  const displacementTexture = textureLoader.load("ground_disp.jpg");
  displacementTexture.wrapS = displacementTexture.wrapT = THREE.RepeatWrapping;
  displacementTexture.repeat.set(10, 10);

  const groundAoMap = textureLoader.load("ground_ao.jpg");
  groundAoMap.wrapS = groundAoMap.wrapT = THREE.RepeatWrapping;
  groundAoMap.repeat.set(10, 10);

  // 🌾 Create Realistic Ground
  const groundGeometry = new THREE.PlaneGeometry(1800, 1800, 100, 100);
  const groundMaterial = new THREE.MeshStandardMaterial({
    map: groundTexture,
    displacementMap: displacementTexture,
    displacementScale: 20, // Adjust terrain bumpiness
    aoMap: groundAoMap,
    aoMapIntensity: 1,
    roughness: 0.8,
    metalness: 0.2,
    fog: true
  });

  const ground = new THREE.Mesh(groundGeometry, groundMaterial);
  ground.rotation.x = -Math.PI / 2; // Lay flat
  ground.position.y = -14.5;
  scene.add(ground);
}

async function loadSurroundings(){
  const gltf = await loadModel("../glbs/surroundings.glb");
  const model = gltf.scene;
  model.position.set(0,10,0);
  scene.add(model);
}

async function loadHysterStacker(){
  const gltf = await loadModel("../glbs/hyster_stacker.glb");
  const model = gltf.scene;
  model.position.set(150, 0, 200);
  model.rotateY(Math.PI/4);
  scene.add(model);
}

async function loadTruck(){
  const truck = new THREE.Group();
  const gltf = await loadModel("../glbs/truck1.glb");
  const model = gltf.scene;
  truck.add(model);
  const conGltf = await loadModel("../glbs/white_container.glb");
  const container = conGltf.scene;
  container.position.set(0,6,6);
  truck.add(container);
  globalThis.containerTruck = truck;
}

function getTruck(containerColor){
  const truck = containerTruck.clone();

  // Change container color for this specific truck
  truck.traverse((child) => {
    if (child.isMesh && child.parent === truck.children[1]) { // Target container (second child)
      child.material = child.material.clone();
      if (containerColor) {
        child.material.color.set(containerColor); // Set color only if provided
      }
      child.material.needsUpdate = true;
    }
  });

  return truck;
}

async function addParkingArea(){

  const geometry = new THREE.BoxGeometry(1, 1, 126); // Adjust width/height for thickness
  const material = new THREE.MeshBasicMaterial({ color: 0x000000 });
  const lineMesh = new THREE.Mesh(geometry, material);
  lineMesh.position.set(280, 0, 210.5);
  scene.add(lineMesh);

  for(let i = 0; i < 6; i++){
    const geometry1 = new THREE.BoxGeometry(30, 1, 1); // Adjust width/height for thickness
    const material1 = new THREE.MeshBasicMaterial({ color: 0x000000 });
    const lotLine1 = new THREE.Mesh(geometry1, material1);
    lotLine1.position.set(267, 0, 155.5 + i*25);
    lotLine1.rotateY(Math.PI/6);
    scene.add(lotLine1);
  }

  const truck1 = getTruck()
  truck1.position.set(260,0,170);
  truck1.rotateY(-Math.PI/3);
  scene.add(truck1);

  const truck2 = getTruck(0xff0000)
  truck2.position.set(260,0,195);
  truck2.rotateY(-Math.PI/3);
  scene.add(truck2);

  const truck3 = getTruck(0x6484f3)
  truck3.position.set(260,0,245);
  truck3.rotateY(-Math.PI/3);
  scene.add(truck3);
}

async function createCustomRoad() {
  const barrierGltf = await loadModel("../glbs/automatic_boom_barriers.glb");
  const barrierModel = barrierGltf.scene;
  barrierModel.position.set(128, 0, 326);
  scene.add(barrierModel);

  const roadPoints = [
    { straight: new THREE.Vector3(865, -0.3, 400) },
    { straight: new THREE.Vector3(128, -0.3, 400) },
    { right: new THREE.Vector3(84, -0.3, 360) },
    { straight: new THREE.Vector3(84, -0.3, 326) },
  ];

  await buildRoad(roadPoints);

  const gltf = await loadModel("../glbs/street_lamp.glb");
  const streetLamp = gltf.scene;

  streetLamp.scale.set(4, 4, 4);

  for (let i = 0; i < 7; i++) {
    const streetLampClone = streetLamp.clone();
    streetLampClone.position.set(180 + i * 80, -5, roadPoints[0].straight.z - 15);
    streetLampClone.rotateY(-Math.PI / 2);
    scene.add(streetLampClone);
  }
}

async function addFencing() {
  const gltf = await loadModel("../glbs/fence.glb");
  const fence = gltf.scene;
  fence.scale.set(2.15, 3, 2.15);

  const fenceBoundingBox = new THREE.Box3().setFromObject(fence);
  const fenceSize = new THREE.Vector3();
  fenceBoundingBox.getSize(fenceSize);

  // back
  let initialPoint = new THREE.Vector3(-280, 0, -325);
  for (let i = 0; i < 19; i++) {
    const fenceClone = fence.clone();
    fenceClone.position.copy(initialPoint);
    fenceClone.position.x += i * (fenceSize.x * 0.65);
    scene.add(fenceClone);
  }

  // right
  initialPoint = new THREE.Vector3(292, 0, -310);

  for (let i = 0; i < 21; i++) {
    
      const fenceClone = fence.clone();
      fenceClone.rotation.y = Math.PI / 2;
      fenceClone.position.copy(initialPoint);
      fenceClone.position.z += i * (fenceSize.x * 0.65);
      scene.add(fenceClone);
  }

  // front
  initialPoint = new THREE.Vector3(-280, 0, 325);
  for (let i = 0; i < 19; i++) {
    if (i != 11 && i != 12 && i != 13) {
      const fenceClone = fence.clone();
      fenceClone.position.copy(initialPoint);
      fenceClone.position.x += i * (fenceSize.x * 0.65);
      scene.add(fenceClone);
    }
  }

  // left
  initialPoint = new THREE.Vector3(-297, 0, -310);

  for (let i = 0; i < 21; i++) {
    const fenceClone = fence.clone();
    fenceClone.rotation.y = Math.PI / 2;
    fenceClone.position.copy(initialPoint);
    fenceClone.position.z += i * (fenceSize.x * 0.65);
    scene.add(fenceClone);
  }
}

function addClouds() {
  const cloudGroup = new THREE.Group();

  const cloudTexture = new THREE.TextureLoader().load("cloud.png");

  for (let i = 0; i < 50; i++) {
    const cloudMaterial = new THREE.SpriteMaterial({
      map: cloudTexture,
      transparent: true,
      opacity: Math.random() * 0.5 + 0.5, // Random transparency
    });

    const cloud = new THREE.Sprite(cloudMaterial);
    cloud.scale.set(300 + Math.random() * 100, 100 + Math.random() * 50, 1);

    // Random positions
    let x, z;
    do {
      x = (Math.random() - 0.5) * 1800;
      z = (Math.random() - 0.5) * 1800;
    } while (Math.abs(x) < 350 && Math.abs(z) < 350);
    const y = Math.random() * 200 + 500; // Above ground
    cloud.position.set(x, y, z);

    cloudGroup.add(cloud);
  }

  scene.add(cloudGroup);
}

