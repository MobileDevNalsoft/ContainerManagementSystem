import * as THREE from 'three';
import { OrbitControls } from 'orbitControls';

export function addControls(camera, renderer){
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
  minPan = new THREE.Vector3(-150, -50, -150);
  maxPan = new THREE.Vector3(150, 50, 150);

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

  // Make the camera look at a specific point (optional)
  const center = new THREE.Vector3(0, 0, 50); // Adjust this based on your scene
  controls.target.copy(center);

  // Update controls to reflect the target position
  controls.update();

  return controls;
}