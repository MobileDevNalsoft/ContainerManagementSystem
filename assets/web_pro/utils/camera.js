import * as THREE from "three";

export function createCamera() {
  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    3000
  );

  // Adjusted camera position
  camera.position.set(0,10,310); // Set to view the scene correctly

  globalThis.camera = camera;
}

window.switchCamera = function() {
  const controls = globalThis.controls;
  const camera = globalThis.camera;
  const { position, target } = getPositionAndTarget();

  // Create a GSAP timeline for smoother transitions
  const timeline = gsap.timeline();

  controls.enabled = false;
  controls.enableDamping = false;

  // Animate position and rotation simultaneously
  timeline
    .to(camera.position, {
      duration: 3,
      x: position.x,
      y: position.y,
      z: position.z,
      ease: "power3.inOut",
    })
    .to(
      controls.target,
      {
        duration: 3,
        x: target.x,
        y: target.y,
        z: target.z,
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
}

function getPositionAndTarget() {
  let position = new THREE.Vector3();
  let target = new THREE.Vector3(0, 0, 0);
  const object = globalThis.targetObject;
  let box;
  const view = object.name.toString().split("_")[0];

  switch (view) {
      case "DRY":
      case "DAMAGED":
      case "REFRIGERATED":
      case "EMPTY":
        position.set(
          object.position.x,
          object.position.y + 100,
          object.position.z + 140
        );
        box = new THREE.Box3().setFromObject(object);
        box.getCenter(target);
        target.z = target.z+70;
        break;
      case "YARD":
        position.set(
          0,400,200
        );
        box = new THREE.Box3().setFromObject(object);
        box.getCenter(target);
        target.z = 85;
        break;
  }

  return { position, target };
}