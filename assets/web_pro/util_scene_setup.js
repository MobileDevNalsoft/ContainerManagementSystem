import * as THREE from "three";

window.initScene = async function () {
  const scene = new THREE.Scene();

  scene.background = new THREE.Color(0x000000);

  // add scene to global variable
  globalThis.scene = scene;

  const threeDView = document.getElementById("container-yard-3dview");
  renderer.setSize(threeDView.clientWidth, threeDView.clientHeight);

  scene.add(camera);

  addLights(scene);

  const base = getBoxGeometry(600, 50, 600, 0x999999);

  base.name = "YARD";

  base.position.y = -25;

  const areaBoundingBox = new THREE.Box3().setFromObject(base);
  const areaSize = new THREE.Vector3();
  areaBoundingBox.getSize(areaSize);

  const topLeftCorner = new THREE.Vector3(-areaSize.x / 2, 0, -areaSize.z / 2);

  scene.add(base);

  await loadEnvironment(topLeftCorner);

  // Create a GSAP timeline for smoother transitions
  const timeline = gsap.timeline();

  controls.enabled = false;
  controls.enableDamping = false;

  // Callbacks after animation completes
  timeline.call(() => {
    controls.enabled = true; // Re-enable controls after animation
    controls.enableDamping = true; // Re-enable damping after animation
  });

  window.addEventListener("resize", () => {
    camera.aspect = threeDView.clientWidth / threeDView.clientHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(threeDView.clientWidth, threeDView.clientHeight);
  });
};
