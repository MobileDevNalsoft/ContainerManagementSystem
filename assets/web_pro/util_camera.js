import * as THREE from "three";

window.createCamera = function () {

  const container = document.getElementById("container-yard-3dview");

  const camera = new THREE.PerspectiveCamera(
    30,
    container.clientWidth / container.clientHeight,
    0.1,
    1000000
  );

  // Adjusted camera position
  camera.position.set(230,270,1000); // Set to view the scene correctly

  globalThis.camera = camera;

  camera.updateProjectionMatrix();
}

window.switchCamera = function(name) {
  const { position, target } = getPositionAndTarget(name != null ? name : null);

  doGSAP(position, target);
}

function getPositionAndTarget(name) {
  let position = new THREE.Vector3();
  let target = new THREE.Vector3(0, 0, 0);
  const object = name!=null? scene.getObjectByName(name) : globalThis.targetObject;
  let box;
  const view = object.name.toString().split("_")[0];

  switch (view) {
      case "DRY":
      case "REFRIGERATED":
      case "DAMAGED":
      case "EMPTY":
      case "UNASSIGNED":
        position.set(
          object.position.x,
          390,
          object.position.z + 283
        );
        box = new THREE.Box3().setFromObject(object);
        box.getCenter(target);
        target.z = target.z + 45;
        break;
      case "YARD":
        globalThis.areaFocused = false;
        position.set(
          0,750,688.7 
        );
        box = new THREE.Box3().setFromObject(object);
        box.getCenter(target);
        target.z = 55;
        break;
  }

  return { position, target };
}