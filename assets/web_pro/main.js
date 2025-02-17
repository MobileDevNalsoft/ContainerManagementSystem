// Import Three.js core from the import map
import { createRenderer } from "renderer";
import { createCamera } from "camera";
import { initScene } from "initScene";
import { addControls } from "controls";
import { loadJSON } from "jsonLoader";
import { addInteractions } from "interactions";
import { getBoxGeometry } from "box";
import { loadEnvironment } from "environment";
import * as THREE from "three";

document.addEventListener("DOMContentLoaded", async function () {
  createRenderer();

  createCamera();

  addControls();

  addInteractions();

  initScene();

  
  await loadJSON("./container_yard.json");

  await loadEnvironment();

  const base = getBoxGeometry(700, 0.03, 700, 0x999999);

  base.name = 'YARD_AREA';
  
  scene.add(base);
  
  buildAreas();
  
  const clock = new THREE.Clock();
  function animate() {
    requestAnimationFrame(animate);


    // water.material.uniforms['time'].value += clock.getDelta()*0.6; 
    controls.update();
    renderer.render(scene, camera);
  }

  animate();
});
