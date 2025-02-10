import * as THREE from "three";
import { getBoxGeometry } from "box";
import { convertGroupToSingleMesh } from "meshMerge";
import { buildWarehouseInterior } from "warehouseInterior";

export function buildWarehouseExterior(
  json,
  scene
) {
  let name = json.warehouseExterior.name;
  let width = json.warehouseExterior.width;
  let depth = json.warehouseExterior.depth;
  let wallThickness = json.warehouseExterior.wallThickness;
  let wallHeight = json.warehouseExterior.wallHeight;
  let position = new THREE.Vector3(json.warehouseExterior.position.x, json.warehouseExterior.position.y, json.warehouseExterior.position.z)

  var warehouseWalls = new THREE.Group();

  // Front Wall
  const frontWall = getBoxGeometry(width+wallThickness, wallHeight, wallThickness, 0x999999);
  frontWall.position.set(0, wallHeight / 2, depth / 2); // Position at back
  warehouseWalls.add(frontWall);

  // // Back Wall
  const backWall = getBoxGeometry(width+wallThickness, wallHeight, wallThickness, 0x999999);
  backWall.position.set(0, wallHeight / 2, -depth / 2); // Position at back
  warehouseWalls.add(backWall);

  // Left Wall
  const leftWall = getBoxGeometry(wallThickness, wallHeight, depth, 0x999999);
  leftWall.position.set(-width / 2, wallHeight / 2, 0); // Position on left
  warehouseWalls.add(leftWall);

  // Right Wall
  const rightWall = getBoxGeometry(wallThickness, wallHeight, depth, 0x999999);
  rightWall.position.set(width / 2, wallHeight / 2, 0); // Position on right
  warehouseWalls.add(rightWall);

  warehouseWalls = convertGroupToSingleMesh(warehouseWalls);
  warehouseWalls.position.set(position.x, position.y, position.z);

  warehouseWalls.name = name;

  scene.add(warehouseWalls);

  const warehouseCenter = new THREE.Vector3();
  warehouseWalls.updateMatrixWorld();
  warehouseWalls.getWorldPosition(warehouseCenter);

  buildWarehouseInterior(json, scene, warehouseCenter);
}

function buildFrontWall(width, depth, wallThickness, wallHeight) {
  const frontWallGroup = new THREE.Group();

  // Front Wall
  const frontWallLeft = getBoxGeometry(width / 3, wallHeight, wallThickness, 0x999999);
  frontWallLeft.position.set(-width / 3, wallHeight / 2, depth / 2); // Position at front
  frontWallGroup.add(frontWallLeft);

  const frontWallRight = getBoxGeometry(width / 3, wallHeight, wallThickness, 0x999999);
  frontWallRight.position.set(width / 3, wallHeight / 2, depth / 2); // Position at front
  frontWallGroup.add(frontWallRight);

  const frontWallMiddle = getBoxGeometry(width / 3, wallHeight, wallThickness, 0x999999);
  frontWallMiddle.position.set(0, wallHeight / 2, depth / 2 - depth / 8); // Position at front
  frontWallGroup.add(frontWallMiddle);

  const frontWallLeftTurn = getBoxGeometry(
    wallThickness,
    wallHeight,
    (depth * 125) / 1000 + wallThickness,
    0x999999
  );
  frontWallLeftTurn.position.set(
    -width / 6,
    wallHeight / 2,
    (depth * 875) / 2000
  ); // Position at front
  frontWallGroup.add(frontWallLeftTurn);

  const frontWallRightTurn = getBoxGeometry(
    wallThickness,
    wallHeight,
    (depth * 125) / 1000 + wallThickness,
    0x999999
  );
  frontWallRightTurn.position.set(
    width / 6,
    wallHeight / 2,
    (depth * 875) / 2000
  ); // Position at front
  frontWallGroup.add(frontWallRightTurn);

  return frontWallGroup;
}
