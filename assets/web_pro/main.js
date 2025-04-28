
document.addEventListener("DOMContentLoaded", async function () {

  createRenderer();

  createCamera();

  addControls();

  await initScene();

  async function waitForLotsData() {
    // Check if lotsData is defined in the global scope
    if (typeof lotsData !== "undefined") {
      addInteractions();

      await loadJSON("./container_yard.json");

      await buildAreas();

      // await startAnimations();

      console.log('{"loaded":"100%"}');
    } else {
      // Wait 100ms and check again
      setTimeout(waitForLotsData, 100);
    }
  }
  
  // Start the recursive check
  waitForLotsData();

  function animate() {
    requestAnimationFrame(animate);
    controls.update();
    renderer.render(scene, camera);
  }

  animate();
});
