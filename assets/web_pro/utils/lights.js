import * as THREE from 'three';

export function addLights(scene){
  // Add ambient light
  const ambientLight = new THREE.AmbientLight(0xffffff, 1);
  ambientLight.castShadow = false; // Soft white light
  scene.add(ambientLight);

  // // Add directional light
  const directionalLight = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight.position.set(0, 2, 0); // Position the light
  scene.add(directionalLight);

  // // Add directional light
  const directionalLight1 = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight.position.set(0, -5, 0); // Position the light
  scene.add(directionalLight1);
}