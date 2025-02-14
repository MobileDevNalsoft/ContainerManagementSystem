import * as THREE from "three";

export function createRenderer(){
  const renderer = new THREE.WebGLRenderer({
      canvas: threeCanvas,
      antialias: true,
      alpha: true,
      logarithmicDepthBuffer: true,
      preserveDrawingBuffer: true,
    });
  renderer.setPixelRatio(Math.min(Math.max(1, window.devicePixelRatio), 2));
  
  // PMREM Generator for improved environment lighting
  const pmremGenerator = new THREE.PMREMGenerator(renderer);
  pmremGenerator.compileEquirectangularShader();

  globalThis.renderer = renderer;
}