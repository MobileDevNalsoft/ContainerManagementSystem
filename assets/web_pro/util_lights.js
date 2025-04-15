import * as THREE from 'three';

window.addLights = function(scene){
  // Add ambient light
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.3);
  ambientLight.castShadow = false; // Soft white light
  ambientLight.position.set(0,15,0);
  // scene.add(ambientLight);

  // // Add directional light
  const directionalLight = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight.position.set(-30, 15, 0); // Position the light
  directionalLight.lookAt(0,0,0);
  scene.add(directionalLight);

  // // Add directional light
  const directionalLight1 = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight1.position.set(30, 15, 0); // Position the light
  directionalLight1.lookAt(0,0,0);
  scene.add(directionalLight1);

  const directionalLight2 = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight2.position.set(0, 15, -30); // Position the light
  directionalLight2.lookAt(0,0,0);
  scene.add(directionalLight2);

  const directionalLight3 = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
  directionalLight3.position.set(0, 15, 30); // Position the light
  directionalLight3.lookAt(0,0,0);
  scene.add(directionalLight3);

  const rectLight = new THREE.RectAreaLight(0xffffff, 1, 600, 800);
  rectLight.position.set(0,50,0);
  rectLight.lookAt(0,0,0);
  scene.add(rectLight);
}