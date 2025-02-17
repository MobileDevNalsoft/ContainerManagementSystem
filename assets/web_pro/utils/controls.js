import * as THREE from "three";
import { OrbitControls } from "orbitControls";

export function addControls(){
  // Set up OrbitControls with the new camera
  const controls = new OrbitControls(camera, renderer.domElement);
  controls.enableDamping = true; // Enable smooth movement
  controls.dampingFactor = 0.25;
  controls.zoomSpeed = 2;
  controls.screenSpacePanning = false;
  controls.panSpeed = 2;

  // limiting vertical rotation around x axis
  controls.minPolarAngle = 0.1;
  controls.maxPolarAngle = Math.PI / 2.2;

  // limiting horizontal rotation around y axis
  controls.minAzimuthAngle = -Math.PI;
  controls.maxAzimuthAngle = Math.PI;

  var minPan;
  var maxPan;

  controls.minDistance = 10;
  controls.maxDistance = 1000;
  minPan = new THREE.Vector3(-300, -50, -300);
  maxPan = new THREE.Vector3(300, 50, 300);

  // Function to clamp target position
  function clampTarget() {
    controls.target.x = Math.max(
      minPan.x,
      Math.min(maxPan.x, controls.target.x)
    );
    controls.target.y = Math.max(
      minPan.y,
      Math.min(maxPan.y, controls.target.y)
    );
    controls.target.z = Math.max(
      minPan.z,
      Math.min(maxPan.z, controls.target.z)
    );
  }

  // Listen for changes in controls
  controls.addEventListener("change", clampTarget);

  // Initial call to set target within bounds if necessary
  clampTarget();

  // Update controls to reflect the target position
  controls.update();

  globalThis.controls = controls;
}