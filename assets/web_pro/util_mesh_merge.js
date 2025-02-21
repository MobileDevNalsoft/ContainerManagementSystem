import * as THREE from "three";
import * as BufferGeometryUtils from "bufferGeometryUtils";

export function convertGroupToSingleMesh(group) {
    let mergedGeometry = new THREE.BufferGeometry(); // Placeholder for the merged geometry
    let mergedMaterial = null; // Will be used to store the material

    let geometries = [];

    // Traverse all child objects in the group
    group.traverse((child) => {
      if (child.isMesh) {
        // Ensure the geometry is in world space for proper merging
        child.updateMatrixWorld();

        // Apply the mesh's world transform to its geometry
        const clonedGeometry = child.geometry.clone();
        clonedGeometry.applyMatrix4(child.matrixWorld);

        // Collect the geometry for merging
        geometries.push(clonedGeometry);

        // Store the material of the first mesh (assuming all meshes use the same material)
        if (!mergedMaterial) {
          mergedMaterial = child.material;
        }
      }
    });

    // Merge all geometries into a single geometry
    mergedGeometry = BufferGeometryUtils.mergeGeometries(geometries);

    // Create a new mesh from the merged geometry and the material
    const mergedMesh = new THREE.Mesh(mergedGeometry, mergedMaterial);

    // Optionally remove the original group from the scene and add the new mesh

    return mergedMesh; // Return the new merged mesh
  }