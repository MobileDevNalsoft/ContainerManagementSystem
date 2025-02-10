import * as THREE from "three";
import { getBoxGeometry } from "box";
import { ThreeDText } from "3dText";

export async function buildActivityArea(json, scene, warehouseCenter) {
    const name = json.warehouseInterior.activityArea.name;
    const width = json.warehouseInterior.activityArea.width;
    const depth = json.warehouseInterior.activityArea.depth;
    const position = new THREE.Vector3(warehouseCenter.x + json.warehouseInterior.activityArea.position.x,warehouseCenter.y + json.warehouseInterior.activityArea.position.y,warehouseCenter.z + json.warehouseInterior.activityArea.position.z);

    const activityArea = getBoxGeometry(width, 0.1, depth, 0x999999);

    activityArea.name = name;

    activityArea.position.set(position.x, position.y, position.z);

    scene.add(activityArea);

    const activityAreaCenter = new THREE.Vector3();
      activityArea.updateMatrixWorld();
      activityArea.getWorldPosition(activityAreaCenter);
    
      const title = await ThreeDText(toCamelCase(name), 1, 0.1);
      title.position.set(
        activityAreaCenter.x - 4,
        activityAreaCenter.y + 0.5,
        activityAreaCenter.z - 6
      );
    
      scene.add(title);
}