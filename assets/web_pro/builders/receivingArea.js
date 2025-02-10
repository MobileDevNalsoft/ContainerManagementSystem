import * as THREE from "three";
import { getBoxGeometry } from "box";
import { ThreeDText } from "3dText";

export async function buildReceivingArea(json, scene, warehouseCenter) {
    const name = json.warehouseInterior.receivingArea.name;
    const width = json.warehouseInterior.receivingArea.width;
    const depth = json.warehouseInterior.receivingArea.depth;
    const position = new THREE.Vector3(warehouseCenter.x + json.warehouseInterior.receivingArea.position.x,warehouseCenter.y + json.warehouseInterior.receivingArea.position.y,warehouseCenter.z + json.warehouseInterior.receivingArea.position.z);

    const receivingArea = getBoxGeometry(width, 0.1, depth, 0x999999);

    receivingArea.name = name;

    receivingArea.position.set(position.x, position.y, position.z);

    scene.add(receivingArea);

    const receivingAreaCenter = new THREE.Vector3();
      receivingArea.updateMatrixWorld();
      receivingArea.getWorldPosition(receivingAreaCenter);
    
      const title = await ThreeDText(toCamelCase(name), 1, 0.1);
      title.position.set(
        receivingAreaCenter.x - 4,
        receivingAreaCenter.y + 0.5,
        receivingAreaCenter.z - 6
      );
    
      scene.add(title);
}