import * as THREE from 'three';

export function getPlaneGeometry(
    width,
    depth,
    color
  ) {
    // Create Plane Geometry
    const geometry = new THREE.PlaneGeometry(width, depth);

    // Create Material with Texture
    const material = new THREE.MeshStandardMaterial({
      metalness: 0.1,
      roughness: 0.5,
      color: color
    });

    // Create Mesh
    const plane = new THREE.Mesh(geometry, material);

    // Rotate Plane to be perpendicular to Y-axis
    plane.rotation.x = -Math.PI / 2;

    return plane;
  }