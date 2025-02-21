import * as THREE from "three";

window.addSkyDome = function() {
    // Load the skydome texture
    const loader = new THREE.TextureLoader();
    loader.load("./sky_box.jpg", function (texture) {
      // Create a large sphere geometry for the skydome
      const geometry = new THREE.SphereGeometry(800,  // Radius of the hemisphere
        32,   // Width segments
        32,   // Height segments
        0,    // phiStart: Start angle in the X axis
        Math.PI * 2,  // phiLength: Full horizontal circle
        0,    // thetaStart: Start angle in the Y axis
        Math.PI / 1.75  // thetaLength: Only upper half to create a dome
        );

      texture.wrapS = THREE.RepeatWrapping; // Ensure the texture wraps horizontally
      texture.wrapT = THREE.ClampToEdgeWrapping; // Optionally clamp vertically to prevent top/bottom seams
      texture.minFilter = THREE.LinearFilter; // Smooth out texture if it's low-res

      // Create a material using the loaded texture
      const material = new THREE.MeshBasicMaterial({
        map: texture,
        side: THREE.BackSide, // Render the inside of the sphere
      });

      // Create the skydome mesh
      const skydome = new THREE.Mesh(geometry, material);

      skydome.rotation.y = Math.PI / 2;

      skydome.position.y = 100;

      // Add the skydome to the scene
      globalThis.scene.add(skydome);
    });
  }