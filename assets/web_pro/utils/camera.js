import * as THREE from "three";

export function createCamera() {
  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    3000
  );

  // Adjusted camera position
  camera.position.set(0,650,200); // Set to view the scene correctly

  globalThis.camera = camera;
}
