import * as THREE from 'three';

window.addLights = function(scene){
  // Add ambient light
  const ambientLight = new THREE.AmbientLight(0xffffff, 1);
  ambientLight.castShadow = false; // Soft white light
  ambientLight.position.set(0,10,0);
  scene.add(ambientLight);

  // // Add directional light
  const directionalLight = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight.position.set(0, 10, 0); // Position the light
  scene.add(directionalLight);

  // // Add directional light
  const directionalLight1 = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight1.shadow.bias = -0.005;
  directionalLight1.position.set(0, 20, 50); // Position the light
  scene.add(directionalLight1);

  const directionalLight2 = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight2.shadow.bias = -0.005;
  directionalLight2.position.set(-50, 20, 0); // Position the light
  scene.add(directionalLight2);

  const directionalLight3 = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight3.shadow.bias = -0.005;
  directionalLight3.position.set(50, 20, 0); // Position the light
  scene.add(directionalLight3);
}