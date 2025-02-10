import * as THREE from "three";
import { getBoxGeometry } from "box";
import { buildWarehouseExterior } from "warehouseExterior";
import { convertGroupToSingleMesh } from "meshMerge";
import { buildYardArea } from "yardArea";

export function buildCompound(json, scene) {
    let name = json.compound.name;
    let width = json.compound.width;
    let depth = json.compound.depth;
    let wallThickness = json.compound.wallThickness;
    let wallHeight = json.compound.wallHeight;
    let position = new THREE.Vector3(json.compound.position.x, json.compound.position.y, json.compound.position.z)

    const compundGroup = new THREE.Group();

    const base = getBoxGeometry(width, 0.1, depth, 0xe6e6e6);

    base.position.set(position.x, position.y, position.z);

    compundGroup.add(base);

    const walls = compundWallBuilder(width, depth, wallThickness, wallHeight);

    compundGroup.add(walls);

    const compound = convertGroupToSingleMesh(compundGroup);

    compound.position.set(position.x, position.y, position.z);

    compound.name = name;

    scene.add(compound);

    buildWarehouseExterior(json, scene);

    buildYardArea(json, scene);
}

function compundWallBuilder(width, depth, thickness, height) {

    var compoundWalls = new THREE.Group();

    // Front Wall
    const frontWall = getBoxGeometry(width+thickness, height, thickness, 0xe6e6e6);
    frontWall.position.set(0, height / 2, depth / 2); // Position at front
    compoundWalls.add(frontWall);

    // Back Wall
    const backWall = getBoxGeometry(width+thickness, height, thickness, 0xe6e6e6);
    backWall.position.set(0, height / 2, -depth / 2); // Position at back
    compoundWalls.add(backWall);

    // Left Wall
    const leftWall = getBoxGeometry(thickness, height, depth, 0xe6e6e6);
    leftWall.position.set(-width / 2, height / 2, 0); // Position on left
    compoundWalls.add(leftWall);

    // Right Wall
    const rightWall = getBoxGeometry(thickness, height, depth, 0xe6e6e6);
    rightWall.position.set(width / 2, height / 2, 0); // Position on right
    compoundWalls.add(rightWall);

    compoundWalls = convertGroupToSingleMesh(compoundWalls);

    return compoundWalls;
}