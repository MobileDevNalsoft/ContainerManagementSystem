import * as THREE from "three";
import { getBoxGeometry } from "box";
import { ThreeDText } from "3dText";
import { convertGroupToSingleMesh } from "meshMerge";

export async function buildStorageArea(json, scene, warehouseCenter) {
  const name = json.warehouseInterior.storageArea.name;
  const width = json.warehouseInterior.storageArea.width;
  const depth = json.warehouseInterior.storageArea.depth;
  const position = new THREE.Vector3(
    warehouseCenter.x + json.warehouseInterior.storageArea.position.x,
    warehouseCenter.y + json.warehouseInterior.storageArea.position.y,
    warehouseCenter.z + json.warehouseInterior.storageArea.position.z
  );

  const storageArea = getBoxGeometry(width, 0.1, depth, 0x999999);

  storageArea.name = name;

  storageArea.position.set(position.x, position.y, position.z);

  scene.add(storageArea);

  const storageAreaCenter = new THREE.Vector3();
  storageArea.updateMatrixWorld();
  storageArea.getWorldPosition(storageAreaCenter);

  const title = await ThreeDText(toCamelCase(name), 1, 0.1);
  title.position.set(
    storageAreaCenter.x - 5,
    storageAreaCenter.y + 0.5,
    storageAreaCenter.z + 6.5
  );
  scene.add(title);

  const sARackPosRef = new THREE.Vector3(
    storageAreaCenter.x - width / 2,
    storageAreaCenter.y,
    storageAreaCenter.z
  );

  buildRacks(json, scene, sARackPosRef);
}

function buildRacks(json, scene, sARackPosRef) {
  const start = 4;
  const gap = 6.6;
  for (let i = 0; i < json.warehouseInterior.storageArea.numberOfRacks; i++) {
    // Create the rack with border and shelves
    const rackL = createRack("rack"+(i+1)+"L", json.warehouseInterior.storageArea.rackType.rows, json.warehouseInterior.storageArea.rackType.columns, facing.SIDE);
    const rackR = createRack("rack"+(i+1)+"R", json.warehouseInterior.storageArea.rackType.rows, json.warehouseInterior.storageArea.rackType.columns, facing.SIDE);
    rackL.scale.set(0.7, 0.7, 0.7);
    rackL.position.set(
      sARackPosRef.x + start + gap * i,
      sARackPosRef.y + 0.05,
      sARackPosRef.z
    );
    rackR.scale.set(0.7, 0.7, 0.7);
    rackR.position.set(
      sARackPosRef.x + start + gap * i + 1.3,
      sARackPosRef.y + 0.05,
      sARackPosRef.z
    );
    scene.add(rackL);
    scene.add(rackR);
  }
}

const facing = {
  FRONT: "front",
  SIDE: "side",
};

// Function to create the full border with rods (top, bottom, front, and back)
function createRack(name, rows, columns, facing) {
  const rackGroup = new THREE.Group(); // Group to hold the rack parts

  // Material for the rack (metal or wood appearance)
  const metalMaterial = new THREE.MeshStandardMaterial({
    color: 0xe6e6e6,
    roughness: 0.7,
  });

  // Rack Dimensions (in meters)
  const rackWidth = columns * 1.49; // Width of the rack
  const rackDepth = 1.5; // Depth of the rack
  const rackHeight = rows * 1.6; // Height of the rack

  const groundClearance = 0.2;

  // Shelf Dimensions
  const shelfHeight = 0.1; // Thickness of each shelf
  const shelfSpacing = rackHeight / rows; // Vertical distance between shelves

  // Function to create a single vertical support beam
  function createVerticalSupport() {
    const geometry = new THREE.BoxGeometry(0.1, rackHeight, 0.1); // Small, thin box
    const verticalSupport = new THREE.Mesh(geometry, metalMaterial);
    return verticalSupport;
  }

  function createHorizontalSupport() {
    const geometry = new THREE.BoxGeometry(0.1, 0.1, rackDepth + 0.1); // Small, thin box
    const horizontalSupport = new THREE.Mesh(geometry, metalMaterial);
    return horizontalSupport;
  }

  // Function to create a horizontal beam (shelf)
  function createHorizontalBeam() {
    const geometry = new THREE.BoxGeometry(rackWidth, shelfHeight, rackDepth); // Wide, flat shelf
    const horizontalBeam = new THREE.Mesh(geometry, metalMaterial);
    return horizontalBeam;
  }

  // Function to create a cross beam (rod to support front and back of the rack)
  function createCrossBeam() {
    const geometry = new THREE.BoxGeometry(rackWidth, shelfHeight, 0.1); // Thin, long cross beam (rod)
    const crossBeam = new THREE.Mesh(geometry, metalMaterial);
    return crossBeam;
  }

  // Create the vertical supports
  const leftSupportBack = createVerticalSupport();
  leftSupportBack.position.set(-rackWidth / 2, rackHeight / 2, -rackDepth / 2);
  const leftSupportFront = createVerticalSupport();
  leftSupportFront.position.set(-rackWidth / 2, rackHeight / 2, rackDepth / 2);
  const rightSupportBack = createVerticalSupport();
  rightSupportBack.position.set(rackWidth / 2, rackHeight / 2, -rackDepth / 2);
  const rightSupportFront = createVerticalSupport();
  rightSupportFront.position.set(rackWidth / 2, rackHeight / 2, rackDepth / 2);
  rackGroup.add(leftSupportBack);
  rackGroup.add(leftSupportFront);
  rackGroup.add(rightSupportBack);
  rackGroup.add(rightSupportFront);

  const leftSupportTop = createHorizontalSupport();
  leftSupportTop.position.set(-rackWidth / 2, rackHeight, 0);
  const rightSupportTop = createHorizontalSupport();
  rightSupportTop.position.set(rackWidth / 2, rackHeight, 0);
  rackGroup.add(leftSupportTop);
  rackGroup.add(rightSupportTop);

  // Create cross beams (front and back rods at top and bottom)
  const topCrossBeamFront = createCrossBeam();
  topCrossBeamFront.position.set(0, rackHeight, rackDepth / 2); // Front top cross beam
  const topCrossBeamBack = createCrossBeam();
  topCrossBeamBack.position.set(0, rackHeight, -rackDepth / 2); // Back top cross beam

  rackGroup.add(topCrossBeamFront);
  rackGroup.add(topCrossBeamBack);

  for (let i = 0; i < rows; i++) {
    const shelf = createHorizontalBeam();
    shelf.position.set(0, groundClearance + i * shelfSpacing, 0);
    rackGroup.add(shelf);
  }

  const rack = convertGroupToSingleMesh(rackGroup);

  rack.name = name;

  const start = 0.95;
  const gap = 0.2;
  for (let j = 0; j < rows; j++) {
    for (let i = 0; i < columns; i++) {
      const box = createBox("box" + i);
      // Compute the bounding box
      const boundingBox = new THREE.Box3().setFromObject(box);

      // Get the dimensions of the box
      const size = new THREE.Vector3();
      boundingBox.getSize(size);
      box.position.set(
        -rackWidth / 2 + i * size.x + start + i * gap,
        groundClearance + 0.14 + j * shelfSpacing,
        0
      );
      rack.add(box);
    }
  }

  // Return the whole rack with border and shelves
  if (facing == "side") {
    rack.rotation.y = Math.PI / 2;
  }
  return rack;
}

function createBox(name) {
  // Material for the pallet
  const woodMaterial = new THREE.MeshStandardMaterial({
    color: 0x8b5a2b,
    roughness: 0.7,
  });

  // Box with pallet creation
  const boxWithPallet = new THREE.Group();

  // Pallet Creation
  const pallet = new THREE.Group();
  // Adjusted Dimensions for the Pallet (converted to meters)
  const palletWidth = 1.2; // 120 cm = 1.2 meters
  const palletDepth = 1; // 100 cm = 1 meter
  const palletHeight = 0.14; // 14 cm = 0.14 meters

  const slatHeight = 0.02; // 2 cm = 0.02 meters

  // Base slats (3 horizontal beams at the bottom)
  const slatGeometry = new THREE.BoxGeometry(palletWidth, slatHeight, 0.1); // Depth = 10 cm (0.1 meters)
  const baseSlats = new THREE.Group();
  for (let i = -1; i <= 1; i++) {
    const slat = new THREE.Mesh(slatGeometry, woodMaterial);
    slat.position.z = i * 0.4; // Spaced evenly along depth (40 cm = 0.4 meters)
    slat.position.y = -palletHeight / 2 + slatHeight / 2; // Positioned at the bottom
    baseSlats.add(slat);
  }
  boxWithPallet.add(baseSlats);

  // Top slats (5 horizontal beams at the top)
  const topSlatGeometry = new THREE.BoxGeometry(0.2, slatHeight, palletDepth); // Width = 20 cm = 0.2 meters
  const topSlats = new THREE.Group();
  for (let i = -2; i <= 2; i++) {
    const slat = new THREE.Mesh(topSlatGeometry, woodMaterial);
    slat.position.x = i * 0.25; // Spaced evenly along width (25 cm = 0.25 meters)
    slat.position.y = palletHeight / 2 - slatHeight / 2; // Positioned at the top
    topSlats.add(slat);
  }
  pallet.add(topSlats);

  // Vertical supports (blocks connecting top and bottom)
  const supportGeometry = new THREE.BoxGeometry(0.1, palletHeight, 0.1); // 10 cm = 0.1 meters
  const supports = new THREE.Group();
  for (let i = -1; i <= 1; i++) {
    for (let j = -1; j <= 1; j++) {
      const support = new THREE.Mesh(supportGeometry, woodMaterial);
      support.position.x = i * 0.5; // Spaced along width (50 cm = 0.5 meters)
      support.position.z = j * 0.4; // Spaced along depth (40 cm = 0.4 meters)
      supports.add(support);
    }
  }
  pallet.add(supports);

  // Forklift holes (spaces created by strategically leaving gaps)
  const forkSlats = new THREE.Group();
  const forkSlatGeometry = new THREE.BoxGeometry(palletWidth - 0.2, 0.06, 0.1); // 6 cm = 0.06 meters
  for (let i = -1; i <= 1; i++) {
    const forkSlat = new THREE.Mesh(forkSlatGeometry, woodMaterial);
    forkSlat.position.y = -0.02; // Position just above the bottom slats
    forkSlat.position.z = i * 0.4; // Align with bottom slats
    forkSlats.add(forkSlat);
  }
  pallet.add(forkSlats);
  pallet.rotation.set(0, Math.PI / 2, 0);

  // Box Dimensions (in meters)
  const boxWidth = 1; // Slightly smaller than the pallet to fit on top
  const boxDepth = 1;
  const boxHeight = 1;

  // Box Geometry
  const boxGeometry = new THREE.BoxGeometry(boxWidth, boxHeight, boxDepth);
  const boxMaterial = new THREE.MeshStandardMaterial({
    color: 0xdeb887,
    roughness: 0.7,
  });
  const box = new THREE.Mesh(boxGeometry, boxMaterial);
  box.name = name;

  // Calculate the top position of the pallet and place the box on top
  const palletTopPositionY = boxWithPallet.position.y + 0.14 / 2; // Pallet height / 2
  box.position.set(
    boxWithPallet.position.x,
    palletTopPositionY + boxHeight / 2,
    boxWithPallet.position.z
  ); // Place the box on top of the pallet
  boxWithPallet.add(box);
  boxWithPallet.add(pallet);

  return boxWithPallet;
}
