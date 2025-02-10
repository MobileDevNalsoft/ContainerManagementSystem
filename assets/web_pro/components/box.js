import * as THREE from 'three';

export function getBoxGeometry(
    xSpread,
    ySpread,
    zSpread,
    color
  ) {
    // Create Plane Geometry
    const geometry = new THREE.BoxGeometry(xSpread, ySpread, zSpread);

    // Create Material with Texture
    const material = new THREE.MeshStandardMaterial({
      metalness: 0.1,
      roughness: 0.5,
      color: color
    });

    // Create Mesh
    const box = new THREE.Mesh(geometry, material);

    return box;
  }