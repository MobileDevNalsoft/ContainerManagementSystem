import * as THREE from "three";
import { addLights } from "lights";

export function initScene(renderer, camera) {
  const scene = new THREE.Scene();
  const threeDView = document.getElementById("threeDView");
  renderer.setSize(threeDView.clientWidth, threeDView.clientHeight);

  scene.add(camera);

  addLights(scene);

  window.addEventListener("resize", () => {
    camera.aspect = threeDView.clientWidth / threeDView.clientHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(threeDView.clientWidth, threeDView.clientHeight);
  });

  return { scene };
}
