import * as THREE from "three";
import { getBoxGeometry } from "box";
import { ThreeDText } from "3dText";

export async function buildInspectionArea(json, scene, warehouseCenter) {
  const name = json.warehouseInterior.inspectionArea.name;
  const width = json.warehouseInterior.inspectionArea.width;
  const depth = json.warehouseInterior.inspectionArea.depth;
  const position = new THREE.Vector3(
    warehouseCenter.x + json.warehouseInterior.inspectionArea.position.x,
    warehouseCenter.y + json.warehouseInterior.inspectionArea.position.y,
    warehouseCenter.z + json.warehouseInterior.inspectionArea.position.z
  );

  const inspectionArea = getBoxGeometry(width, 0.1, depth, 0x999999);

  inspectionArea.name = name;

  inspectionArea.position.set(position.x, position.y, position.z);

  scene.add(inspectionArea);

  const inspectionAreaCenter = new THREE.Vector3();
  inspectionArea.updateMatrixWorld();
  inspectionArea.getWorldPosition(inspectionAreaCenter);

  const title = await ThreeDText(toCamelCase(name), 1, 0.1);
  title.position.set(
    inspectionAreaCenter.x - 5,
    inspectionAreaCenter.y + 0.5,
    inspectionAreaCenter.z + 6.5
  );

  scene.add(title);
}
