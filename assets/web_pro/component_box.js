import * as THREE from "three";

window.getBoxGeometry = function (
  xSpread,
  ySpread,
  zSpread,
  color,
  transparent,
  opacity
) {
  // Create Plane Geometry
  const geometry = new THREE.BoxGeometry(xSpread, ySpread, zSpread);

  // Create Material with Texture
  const material = new THREE.MeshStandardMaterial({
    metalness: 0,
    color: color,
    roughness: 1,
    envMap: null,
    normalMap: null,
  });

  // Create Mesh
  const box = new THREE.Mesh(geometry, material);

  return box;
};
