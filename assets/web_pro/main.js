import * as THREE from "three";

document.addEventListener("DOMContentLoaded", async function () {
  createRenderer();

  createCamera();

  addControls();

  await initScene();

  addInteractions();

  await loadJSON("./container_yard.json");

  await buildAreas();

  await startAnimation();

  console.log('{"loaded":"100%"}');

  const clock = new THREE.Clock();
  function animate() {
    requestAnimationFrame(animate);
    water.material.uniforms["time"].value += clock.getDelta() * 0.6;
    controls.update();
    renderer.render(scene, camera);
  }

  animate();
});
