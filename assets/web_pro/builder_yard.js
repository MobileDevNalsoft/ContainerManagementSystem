import * as THREE from "three";

export function buildYard() {
    let name = json.yard.name;
    let width = json.yard.width;
    let depth = json.yard.depth;
    let position = new THREE.Vector3(json.yard.position.x, json.yard.position.y, json.yard.position.z)

    const yardGroup = new THREE.Group();

    const base = getBoxGeometry(width, 0.1, depth, 0xe6e6e6);

    base.position.set(position.x, position.y, position.z);

    yardGroup.add(base);

    const yard = convertGroupToSingleMesh(yardGroup);

    yard.position.set(position.x, position.y, position.z);

    yard.name = name;

    scene.add(yard);

    return yard;
}

