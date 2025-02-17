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

// window.switchCamera = function(scene, name, camera, controls) {
//   const { position, target } = getPositionAndTarget(scene, name);

//   // Create a GSAP timeline for smoother transitions
//   const timeline = gsap.timeline();

//   controls.enabled = false;
//   controls.enableDamping = false;

//   // Animate position and rotation simultaneously
//   timeline
//     .to(camera.position, {
//       duration: 3,
//       x: position.x,
//       y: position.y,
//       z: position.z,
//       ease: "power3.inOut",
//     })
//     .to(
//       controls.target,
//       {
//         duration: 3,
//         x: target.x,
//         y: target.y,
//         z: target.z,
//         ease: "power3.inOut",
//         onUpdate: function () {
//           camera.lookAt(controls.target); // Smoothly look at the target
//         },
//       },
//       "<"
//     );

//   // Callbacks after animation completes
//   timeline.call(() => {
//     controls.enabled = true; // Re-enable controls after animation
//     controls.enableDamping = true; // Re-enable damping after animation
//     if (name.includes("compound")) {
//       globalThis.areaFocused = false;
//     }
//   });
// }

// export function getPositionAndTarget(scene, name) {
//   let position = new THREE.Vector3();
//   let target = new THREE.Vector3(0, 0, 0);
//   let object = new THREE.Object3D();
//   let box;
//   let view = name.toString().split("_")[0];

//   if (!["compoundArea", "storageArea", "warehouse"].includes(view)) {
//     document.getElementById("wms-bot").style.display = "none";
//   }

//   switch (data.model) {
//     case "warehouse":
//       switch (view) {
//         case "compoundArea":
//           position.set(0, 550, 220);
//           target.set(0, 0, -60);
//           target.z = target.z + 50;
//           console.log('{"object":"null"}');
//           break;
//         case "warehouse":
//           object = scene.getObjectByName(name);
//           position.set(
//             object.position.x,
//             object.position.y + 250,
//             object.position.z + 100
//           );
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case "storageArea":
//           object = scene.getObjectByName(view);
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           position.set(-78, 60, 20);
//           target.y = target.y + 25;
//           target.x = target.x + 5;
//           break;
//         case "inspectionArea":
//           position.set(21.2, 50, -50);
//           object = scene.getObjectByName(view);
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case "stagingArea":
//           position.set(-119, 80, 0);
//           object = scene.getObjectByName(view);
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case "activityArea":
//           position.set(-49, 80, -20);
//           object = scene.getObjectByName(view);
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case "receivingArea":
//           position.set(20.8, 80, 0);
//           object = scene.getObjectByName(view);
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case "yardArea":
//           position.set(50, 320, -34);
//           object = scene.getObjectByName(view);
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case "dockArea-IN":
//           position.set(20.9, 120, -2);
//           object = scene.getObjectByName(view);
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           target.z = target.z + 25;
//           break;
//         case "dockArea-OUT":
//           position.set(-113.95, 120, -2);
//           object = scene.getObjectByName(view);
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           target.z = target.z + 25;
//           break;
//         case "rack5r":
//         case "rack4r":
//         case "rack3r":
//         case "rack2r":
//         case "rack1r":
//           object = scene.getObjectByName(view);
//           position.set(
//             object.position.x + 20,
//             object.position.y + 24,
//             object.position.z
//           );
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case "rack5l":
//         case "rack4l":
//         case "rack3l":
//         case "rack2l":
//         case "rack1l":
//           object = scene.getObjectByName(view);
//           position.set(
//             object.position.x - 20,
//             object.position.y + 24,
//             object.position.z
//           );
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case 'lpnLifeCycle':
//           object = scene.getObjectByName('warehouse_wall');
//           position.set(
//             object.position.x+20,
//             object.position.y + 250,
//             object.position.z + 100
//           );
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           target.x = target.x + 20;
//           break;
//       }
//       break;
//     case "storageArea":
//       switch (view) {
//         case "storageArea":
//         case "compoundArea":
//           position.set(0, 45, 150);
//           target.z = 50;
//           break;
//         case "rack5r":
//         case "rack4r":
//         case "rack3r":
//         case "rack2r":
//         case "rack1r":
//           object = scene.getObjectByName(view);
//           position.set(
//             object.position.x + 20,
//             object.position.y + 24,
//             object.position.z
//           );
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//         case "rack5l":
//         case "rack4l":
//         case "rack3l":
//         case "rack2l":
//         case "rack1l":
//           object = scene.getObjectByName(view);
//           position.set(
//             object.position.x - 20,
//             object.position.y + 24,
//             object.position.z
//           );
//           box = new THREE.Box3().setFromObject(object);
//           box.getCenter(target);
//           break;
//       }
//       break;
//   }

//   return { position, target };
// }