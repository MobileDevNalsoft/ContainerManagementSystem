import * as THREE from "three";
import { ThreeDText } from "3dText";

window.storeLotsData = function (data) {
  globalThis.lotsData = JSON.parse(data);
};

// add container
window.addContainer = async function (containerNbr, areaName) {
  const scene = globalThis.scene;
  const targetObject = globalThis.targetObject;
  const lot = globalThis.lot;
  const containerSize = globalThis.containerSize;
  const lotsData = globalThis.lotsData[`${areaName.toLowerCase()}_area`];
  lotsData[lot].push({ containerNbr: containerNbr });
  const count = lotsData[lot].length;
  const containerGroup = new THREE.Group();
  const containerClone = globalThis.container.clone();
  containerGroup.add(containerClone);
  containerClone.position.set(
    targetObject.position.x,
    targetObject.position.y + (count - 1) * containerSize.y,
    targetObject.position.z
  );
  ThreeDText(containerNbr, 1, 0.1).then((title) => {
    const titleBoundingBox = new THREE.Box3().setFromObject(title);
    const titleSize = new THREE.Vector3();
    titleBoundingBox.getSize(titleSize);
    title.raycast = () => {};
    title.rotation.y = Math.PI / 2;
    title.position.set(
      containerClone.position.x + containerSize.x / 2,
      containerClone.position.y + containerSize.y / 2,
      containerClone.position.z + titleSize.x / 2
    );
    title.name = containerNbr;
    containerGroup.add(title);
  });
  const uuid = containerClone.uuid;
  globalThis.objData.set(uuid, {
    containerNbr: containerNbr,
    area: areaName,
  });
  scene.add(containerGroup);
  globalThis.targetObject = null;
};

window.deleteContainer = function () {
  const scene = globalThis.scene;
  const targetObject = globalThis.targetObject;

  if (!targetObject) {
    console.warn("No target object selected.");
    return;
  }

  if (targetObject.parent) {
    console.log("Target Object:", targetObject);
    console.log("Target Object Parent:", targetObject.parent);

    // Dispose of target object
    if (targetObject.geometry) {
      targetObject.geometry.dispose();
    }
    if (Array.isArray(targetObject.material)) {
      targetObject.material.forEach((material) => material.dispose());
    } else if (targetObject.material) {
      targetObject.material.dispose();
    }

    // Remove title object (text mesh) from scene
    const titleObject = scene.getObjectByName(
      globalThis.objData.get(targetObject.parent.uuid)?.containerNbr
    );

    if (titleObject) {
      console.log("Removing title:", titleObject.name);
      if (titleObject.geometry) {
        titleObject.geometry.dispose();
      }
      if (titleObject.material) {
        titleObject.material.dispose();
      }
      titleObject.parent?.remove(titleObject);
      scene.remove(titleObject);
    } else {
      console.warn("Title object not found.");
    }

    // Remove all children from parent (including the container)
    targetObject.parent.children.slice().forEach((child) => {
      if (child.geometry) {
        child.geometry.dispose();
      }
      if (child.material) {
        child.material.dispose();
      }
      targetObject.parent.remove(child);
      scene.remove(child);
    });

    // Remove the container's parent from scene
    targetObject.parent.parent?.remove(targetObject.parent);
    scene.remove(targetObject.parent);

    console.log("Removed:", targetObject.parent);

    // Remove from objData
    globalThis.objData.delete(targetObject.parent.uuid);
  } else {
    console.warn("Target object has no parent.");
  }

  // Force scene update
  scene.updateMatrixWorld(true);

  // Debug: Print all objects remaining in the scene
  scene.traverse((obj) => {
    console.log(
      `Remaining Object: ${obj.name || obj.uuid}, Position:`,
      obj.position
    );
  });
};

window.relocateContainer = function (targetLot, targetContainer, areaName) {
  const scene = globalThis.scene;
  const targetObject = globalThis.targetObject;
  const currentLot = globalThis.objData.get(targetObject.parent?.uuid).lotNo;
  const containerSize = globalThis.containerSize;
  const lotsData = globalThis.lotsData[`${areaName.toLowerCase()}_area`];
  lotsData[currentLot] = lotsData[currentLot].filter(
    (obj) => obj.container_nbr != targetContainer
  );
  lotsData[targetLot].push({ containerNbr: targetContainer });
  const count = lotsData[targetLot].length;
  const targetLotPosition = scene.getObjectByName(
    areaName + "_" + targetLot
  ).position;
  const currentLotPosition = scene.getObjectByName(
    areaName + "_" + currentLot
  ).position;

  const targetTitle = scene.getObjectByName(targetContainer);
  const titleBoundingBox = new THREE.Box3().setFromObject(targetTitle);
  const titleSize = new THREE.Vector3();
  titleBoundingBox.getSize(titleSize);

  globalThis.scene.traverse((object) => {
    if (object.isMesh) {
      // Ensure it's a 3D object, not a Group or Light
      if (
        object.name.includes("Container") &&
        object.parent.position.x == currentLotPosition.x &&
        object.parent.position.z == currentLotPosition.z
      ) {
        console.log(
          `Object: ${object.name || object.uuid}, Position:`,
          object.parent.position.x +
            " " +
            object.parent.position.y +
            " " +
            object.parent.position.z
        );
        if (object.parent.position.y > 8) {
          object.parent.position.set(
            targetObject.parent.position.x,
            targetObject.parent.position.y,
            targetObject.parent.position.z
          );
          const currentTitle = scene.getObjectByName(
            globalThis.objData.get(object.parent.uuid).containerNbr
          );

          const currentTitleBoundingBox = new THREE.Box3().setFromObject(
            currentTitle
          );
          const currentTitleSize = new THREE.Vector3();
          currentTitleBoundingBox.getSize(currentTitleSize);

          currentTitle.position.set(
            targetObject.parent.position.x + containerSize.x / 2,
            targetObject.parent.position.y + containerSize.y / 2,
            targetObject.parent.position.z + currentTitleSize.z / 2
          );
        }
      }
    }
  });

  targetObject.parent.position.set(
    targetLotPosition.x,
    targetLotPosition.y + (count - 1) * containerSize.y,
    targetLotPosition.z
  );

  targetTitle.position.set(
    targetObject.parent.position.x + containerSize.x / 2,
    targetObject.parent.position.y + containerSize.y / 2,
    targetObject.parent.position.z + titleSize.z / 2
  );

  globalThis.targetObject = null;
};
