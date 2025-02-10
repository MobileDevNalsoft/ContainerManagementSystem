// Import Three.js core from the import map

import { createRenderer } from "renderer";
import { createCamera } from "camera";
import { initScene } from "initScene";
import { addControls } from "controls";
import { loadJSON } from "jsonLoader";
import { startBuildingWarehouse } from "start";

let undoStack = [];
let redoStack = [];
// Store the currently selected object
let selectedObject = null;
let selectedObjectOutline = null;
let localOriginMarker = null;

document.addEventListener("DOMContentLoaded", async function () {
  const renderer = createRenderer();

  const camera = createCamera();

  const { scene } = initScene(renderer, camera);

  const controls = addControls(camera, renderer);

  const json = await loadJSON('./warehouse.json');

  startBuildingWarehouse(json, scene);

  // Step 4: Render loop
  function animate() {
    requestAnimationFrame(animate);
    controls.update();
    renderer.render(scene, camera);
  }

  animate();
});
