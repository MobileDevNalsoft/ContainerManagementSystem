import * as THREE from "three";
import { getBoxGeometry } from "box";
import { ThreeDText } from "3dText";
import { loadModel } from "modelLoader";

export async function buildYardArea(json, scene) {
  const name = json.yardArea.name;
  const width = json.yardArea.width;
  const depth = json.yardArea.depth;
  const position = new THREE.Vector3(
    json.yardArea.position.x,
    json.yardArea.position.y,
    json.yardArea.position.z
  );

  const yardArea = getBoxGeometry(width, 0.1, depth, 0x999999);

  yardArea.name = name;

  yardArea.position.set(position.x, position.y, position.z);

  scene.add(yardArea);

  const yardAreaCenter = new THREE.Vector3();
  yardArea.updateMatrixWorld();
  yardArea.getWorldPosition(yardAreaCenter);

  const title = await ThreeDText(toCamelCase(name), 1, 0.1);
  title.rotation.z = -Math.PI / 2;
  title.position.set(yardAreaCenter.x, yardAreaCenter.y, yardAreaCenter.z - 4);

  const yardBoundingBox = new THREE.Box3().setFromObject(yardArea);
  const yardSize = new THREE.Vector3();
  yardBoundingBox.getSize(yardSize);

  const bottomLeftCorner = new THREE.Vector3(
    yardAreaCenter.x - yardSize.x / 2,
    yardAreaCenter.y,
    yardAreaCenter.z + yardSize.z / 2
  );
  const topRightCorner = new THREE.Vector3(
    yardAreaCenter.x + yardSize.x / 2,
    yardAreaCenter.y,
    yardAreaCenter.z - yardSize.z / 2
  );

  scene.add(title);

  const gltf = await loadModel("../glbs/truck.glb");
  const truck = gltf.scene;
  const truckBoundingBox = new THREE.Box3().setFromObject(truck);
  const truckSize = new THREE.Vector3();
  truckBoundingBox.getSize(truckSize);
  truck.scale.set(0.8, 0.8, 0.8);
  truck.rotation.y = Math.PI / 2;
  const start = 4;
  const gap = 5.5;
  for (let i = 0; i < 20; i++) {
    const truckClone = truck.clone();
    if (i < 10) {
      truckClone.position.set(
        bottomLeftCorner.x + truckSize.z / 2 + 1,
        bottomLeftCorner.y,
        bottomLeftCorner.z - truckSize.x / 2 - start - gap * i
      );
    } else {
      truckClone.rotation.y = -Math.PI / 2;
      truckClone.position.set(
        topRightCorner.x - truckSize.z / 2 - 1,
        topRightCorner.y,
        topRightCorner.z + truckSize.x / 2 + start - 1 + gap * (i - 10)
      );
    }
    scene.add(truckClone);
  }
}
