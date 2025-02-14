import * as THREE from "three";
import { loadModel } from "modelLoader";

export async function buildContainers(yard) {

  const yardCenter = new THREE.Vector3();
  yard.updateMatrixWorld();
  yard.getWorldPosition(yardCenter);

  const yardBoundingBox = new THREE.Box3().setFromObject(yard);
  const yardSize = new THREE.Vector3();
  yardBoundingBox.getSize(yardSize);
  
  const topRightCorner = new THREE.Vector3(
      yardCenter.x + yardSize.x / 2,
      yardCenter.y,
      yardCenter.z - yardSize.z / 2
  );

  const gltf = await loadModel("../glbs/blue_container.glb");
  const container = gltf.scene;
  // scene.add(container);
  const containerBoundingBox = new THREE.Box3().setFromObject(container);
  const containerSize = new THREE.Vector3();
  container.scale.set(1.5, 1.5, 1.5);
  containerBoundingBox.getSize(containerSize);
  container.rotation.y = Math.PI / 2;
  const start = 5;
  const gap = 5.5;
  for (let i = 0; i < 20; i++) {
    const containerClone = container.clone();
    containerClone.position.set(
      topRightCorner.x - containerSize.z / 2*1.5 - 3,
      topRightCorner.y,
      topRightCorner.z + containerSize.x / 2*1.5 + start - 1 + gap * (i)
    );
    scene.add(containerClone);
  }
}
