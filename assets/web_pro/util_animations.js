import * as THREE from "three";

window.startAnimations = function () {
  createNodes();
  // startTruckAnimation();
  // startContainerHandlerAnimation();
}


window.startTruckAnimation = async function () {
  const gltf = await loadModel("../glbs/truck.glb");
  const model = gltf.scene;
  const truckGroup = new THREE.Group();
  truckGroup.add(model);
  globalThis.truck = model;
  globalThis.containerOnTruck = globalThis.container.clone();
  containerOnTruck.position.set(
    truck.position.x ,
    truck.position.y + containerSize.y * 0.35,
    truck.position.z - containerSize.z * 0.25
  );
  truckGroup.add(containerOnTruck);
  globalThis.truckGroup = truckGroup;
  scene.add(truckGroup);

  getShortestPath(
    ['r1', 'r452'],
    truckGroup,
    0xcc0066,
  );
}


window.startAnimation = async function () {
  const gltf = await loadModel("../glbs/truck.glb");
  const model = gltf.scene;
  const truckGroup = new THREE.Group();
  truckGroup.add(model);
  globalThis.truck = model;
  globalThis.containerOnTruck = globalThis.container.clone();
  containerOnTruck.rotateY(Math.PI / 2);
  containerOnTruck.position.set(
    truck.position.x - containerSize.x * 0.6,
    truck.position.y + containerSize.y * 0.35,
    truck.position.z
  );
  truckGroup.add(containerOnTruck);
  globalThis.truckGroup = truckGroup;
  scene.add(truckGroup);

  // updateTruckMovement();
// truckGroup.position.set(300, 1, 230);
// truckGroup.rotation.y = Math.PI;
// truckAnimationLoop();
};

const speed = 0.002;
let progress = 0;

// const stopPosition = new THREE.Vector3(-200, 1, 200);

let isPaused = false; // Flag to check if truck is stopped

window.updateTruckMovement = function () {
  if (!truckGroup || isPaused) return; // Stop updating when paused

  //   if (truck.position.distanceTo(stopPosition) < 1) {
  //     isPaused = true; // Set flag to pause movement
  //     setTimeout(() => {
  //       isPaused = false; // Resume movement after 5 seconds
  //     }, 5000);
  //   }
  progress += speed;
  const point = curve.getPointAt(progress % 1);

  const tangent = curve.getTangentAt(progress % 1).normalize();
  // Calculate the normal vector (perpendicular to the curve)
  const up = new THREE.Vector3(0, 1, 0); // Assuming road is mostly horizontal
  const normal = new THREE.Vector3().crossVectors(tangent, up).normalize();

  // Calculate the offset position
  const offset = new THREE.Vector3().copy(normal).multiplyScalar(0); // set 0 to some value to move the vehicle towards left or right
  const newPosition = new THREE.Vector3().addVectors(point, offset);

  // Set object's position
  truckGroup.position.copy(newPosition);
  // Create a quaternion to orient the truckGroup correctly
  const quaternion = new THREE.Quaternion();
  quaternion.setFromUnitVectors(new THREE.Vector3(0, 0, 1), tangent.negate()); // Align local Z-axis with the tangent

  // Apply quaternion and fix sideways rotation
  truckGroup.setRotationFromQuaternion(quaternion);
  truckGroup.rotateY(Math.PI / 2); // Rotate 90° to correct sideways facing
  requestAnimationFrame(updateTruckMovement);
};

window.startContainerHandlerAnimation = async function (){
  const gltf = await loadModel("../glbs/container_handler.glb");
  const model = gltf.scene;
  model.rotateY(Math.PI / 2);

  // getShortestPath(
  //   ['a31', 'a300'],
  //   model,
  //   0xcc0066,
  // );
}

window.doGSAP = function (position, target) {
  const timeline = gsap.timeline();

  controls.enabled = false;

  // Animate position and rotation simultaneously
  timeline
    .to(camera.position, {
      duration: 3,
      x: position.x,
      y: position.y,
      z: position.z,
      ease: "power2.inOut",
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
  });
};
