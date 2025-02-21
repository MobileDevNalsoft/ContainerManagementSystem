import * as THREE from "three";

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

  updateTruckMovement();
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

const combinedPath = [
  new THREE.Vector3(300, 1, 230),
  new THREE.Vector3(-170, 1, 230), // turn
  new THREE.Vector3(-200, 1, 200), // turn
  new THREE.Vector3(-200, 1, -52),
  new THREE.Vector3(-170, 1, -82),
  new THREE.Vector3(210, 1, -82),
  new THREE.Vector3(240, 1, -52),
  new THREE.Vector3(240, 1, 230),
];

let index = 0;
async function moveTruck(delta) {
  let SPEED = 15;

  const targetPosition = combinedPath[index];
  const direction = targetPosition.clone().sub(truckGroup.position);

  const distanceSq = direction.lengthSq();
  if (distanceSq > 0.05 * 0.05) {
    direction.normalize();
    // Calculate the target angle
    const targetAngle = Math.atan2(-direction.z, direction.x);
    // Get current angle and calculate the shortest path
    let currentAngle = truckGroup.rotation.y;
    const angleDifference =
      THREE.MathUtils.euclideanModulo(
        targetAngle - currentAngle + Math.PI,
        Math.PI * 2
      ) - Math.PI;

    if (Math.abs(angleDifference) > 0.01) {
      currentAngle += angleDifference * delta * 2; // Smoothly interpolate rotation
      truckGroup.rotation.y = currentAngle;
    }
    const moveDistance = Math.min(delta * SPEED, Math.sqrt(distanceSq));
    truckGroup.position.add(direction.multiplyScalar(moveDistance));
  } else {
    truckGroup.position.copy(targetPosition);
    index += 1;
    if(index == combinedPath.length-1){
        index = 0;
    }
  }
}

const clock = new THREE.Clock();
function truckAnimationLoop() {
  moveTruck(clock.getDelta());

  requestAnimationFrame(truckAnimationLoop);
}
