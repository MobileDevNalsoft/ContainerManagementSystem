import * as THREE from "three";
import { addObjectToScene } from "addObject";

export function addInteractions(scene, camera, renderer, gridHelper) {
  const raycaster = new THREE.Raycaster();

  // need mouse coordinates for raycasting.
  const mouse = new THREE.Vector2();
  const lastPos = new THREE.Vector2();

  const draggableElements = document.querySelectorAll(".draggable");
  let draggedObjectType = null;

  draggableElements.forEach((item) => {
    item.addEventListener("dragstart", (event) => {
      draggedObjectType = event.target.id; // Get the type of object (cube, sphere, cylinder)
    });
  });

  const threeCanvas = document.getElementById("threeCanvas");

  threeCanvas.addEventListener("dragover", (event) => {
    event.preventDefault(); // Allow dropping
  });

  threeCanvas.addEventListener("drop", (e) => {
    e.preventDefault();

    // Find the drop position in 3D space using raycasting
    const mouse = new THREE.Vector2();
    const rect = document.getElementById("threeDView").getBoundingClientRect();
    mouse.x = ((e.clientX - rect.left) / rect.width) * 2 - 1;
    mouse.y = -((e.clientY - rect.top) / rect.height) * 2 + 1;

    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObject(gridHelper);

    if (intersects.length > 0) {
      addObjectToScene(scene, draggedObjectType);
    }
  });
}
