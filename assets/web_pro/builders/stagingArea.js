import * as THREE from "three";
import { getBoxGeometry } from "box";
import { ThreeDText } from "3dText";

export async function buildStagingArea(json, scene, warehouseCenter) {
    const name = json.warehouseInterior.stagingArea.name;
    const width = json.warehouseInterior.stagingArea.width;
    const depth = json.warehouseInterior.stagingArea.depth;
    const position = new THREE.Vector3(warehouseCenter.x + json.warehouseInterior.stagingArea.position.x,warehouseCenter.y + json.warehouseInterior.stagingArea.position.y,warehouseCenter.z + json.warehouseInterior.stagingArea.position.z);

    const stagingArea = getBoxGeometry(width, 0.1, depth, 0x999999);

    stagingArea.name = name;

    stagingArea.position.set(position.x, position.y, position.z);

    scene.add(stagingArea);

    const stagingAreaCenter = new THREE.Vector3();
      stagingArea.updateMatrixWorld();
      stagingArea.getWorldPosition(stagingAreaCenter);
    
      const title = await ThreeDText(toCamelCase(name), 1, 0.1);
      title.position.set(
        stagingAreaCenter.x - 5,
        stagingAreaCenter.y + 0.5,
        stagingAreaCenter.z - 6
      );
    
      scene.add(title);
}