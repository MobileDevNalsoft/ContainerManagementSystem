import * as THREE from "three";

document.addEventListener("DOMContentLoaded", async function () {
  createRenderer();

  createCamera();

  addControls();

  await initScene();

  addInteractions();

  await loadJSON("./container_yard.json");

  await buildAreas();

  // await startAnimations();

  console.log('{"loaded":"100%"}');

  function animate() {
    requestAnimationFrame(animate);
    controls.update();
    renderer.render(scene, camera);
  }

  animate();
});
