import * as THREE from "three";
import { addLights } from "lights";

export function initScene() {
  const scene = new THREE.Scene();

  scene.background = new THREE.Color(0x000000);

  // add scene to global variable
  globalThis.scene = scene;

  const threeDView = document.getElementById("container-yard-3dview");
  renderer.setSize(threeDView.clientWidth, threeDView.clientHeight);

  scene.add(camera);

  addLights(scene);

  window.addEventListener("resize", () => {
    camera.aspect = threeDView.clientWidth / threeDView.clientHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(threeDView.clientWidth, threeDView.clientHeight);
  });
}
