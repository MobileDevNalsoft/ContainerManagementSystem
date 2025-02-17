import * as THREE from "three";
import { addLights } from "lights";
import { createWaterEffect } from "water";

export function initScene() {
  const scene = new THREE.Scene();

  scene.background = new THREE.Color(0x000000);

  // add scene to global variable
  globalThis.scene = scene;

  const threeDView = document.getElementById("container-yard-3dview");
  renderer.setSize(threeDView.clientWidth, threeDView.clientHeight);

  scene.add(camera);

  addLights(scene);

  createWaterEffect();

  // Create a GSAP timeline for smoother transitions
  const timeline = gsap.timeline();

  controls.enabled = false;
  controls.enableDamping = false;

  // Animate position and rotation simultaneously
  timeline
    .to(camera.position, {
      duration: 3,
      x: 0,
      y: 400,
      z: 200,
      ease: "power3.inOut",
    })
    .to(
      controls.target,
      {
        duration: 3,
        x: 0,
        y: 0,
        z: 85,
        ease: "power3.inOut",
        onUpdate: function () {
          camera.lookAt(controls.target); // Smoothly look at the target
        },
      },
      "<"
    );

  // Callbacks after animation completes
  timeline.call(() => {
    controls.enabled = true; // Re-enable controls after animation
    controls.enableDamping = true; // Re-enable damping after animation
  });

  window.addEventListener("resize", () => {
    camera.aspect = threeDView.clientWidth / threeDView.clientHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(threeDView.clientWidth, threeDView.clientHeight);
  });
}
