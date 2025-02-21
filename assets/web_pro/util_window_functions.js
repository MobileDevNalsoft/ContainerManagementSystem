import * as THREE from "three";

window.storeLotsData = function (data) {
  globalThis.lotsData = JSON.parse(data);
};

window.setCustomer = function (name) {
  globalThis.customerName = name;
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
  const customColor =
    count == 1 ? new THREE.Color(0xff0000) : new THREE.Color(0xffffff); // Red color

  // Iterate through all the meshes in the container and apply the color to their materials
  containerClone.traverse((child) => {
    if (child.isMesh) {
      // For each mesh, check if it has a material and apply the color
      if (child.material) {
        // Clone the material so that each container has its own unique material
        if (Array.isArray(child.material)) {
          // Handle cases where multiple materials exist for a mesh (array of materials)
          child.material.forEach((material) => {
            material = material.clone(); // Clone the material
            material.color.set(customColor); // Set the custom color
            child.material = material; // Apply the cloned material back to the mesh
          });
        } else {
          // Single material for the mesh
          child.material = child.material.clone(); // Clone the material
          child.material.color.set(customColor); // Set the custom color
        }
      }
    }
  });
  ThreeDText(containerNbr, 1, 0.1, 0xffffff).then((title) => {
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

  const now = new Date();

  const formattedDate =
    now.getFullYear() +
    "-" +
    String(now.getMonth() + 1).padStart(2, "0") +
    "-" +
    String(now.getDate()).padStart(2, "0") +
    " " +
    String(now.getHours()).padStart(2, "0") +
    ":" +
    String(now.getMinutes()).padStart(2, "0") +
    ":" +
    String(now.getSeconds()).padStart(2, "0") +
    "." +
    String(now.getMilliseconds()).padStart(3, "0");

  console.log("customer name " + globalThis.customerName);
  const uuid = containerClone.uuid;
  globalThis.objData.set(uuid, {
    containerNbr: containerNbr,
    area: areaName,
    lotNo: lot,
    arrivalTime: formattedDate,
    customerName: globalThis.customerName,
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

  globalThis.scene.traverse((object) => {
    if (object.isMesh) {
      // Ensure it's a 3D object, not a Group or Light
      if (
        object.name.includes("Container") &&
        object.parent.position.x == targetObject.parent.position.x &&
        object.parent.position.z == targetObject.parent.position.z
      ) {
        console.log("obj name " + object.name);
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

          const customColor = new THREE.Color(0xff0000); // Red color

          // Iterate through all the meshes in the container and apply the color to their materials
          object.traverse((child) => {
            if (child.isMesh) {
              // For each mesh, check if it has a material and apply the color
              if (child.material) {
                // Clone the material so that each container has its own unique material
                if (Array.isArray(child.material)) {
                  // Handle cases where multiple materials exist for a mesh (array of materials)
                  child.material.forEach((material) => {
                    material = material.clone(); // Clone the material
                    material.color.set(customColor); // Set the custom color
                    child.material = material; // Apply the cloned material back to the mesh
                  });
                } else {
                  // Single material for the mesh
                  child.material = child.material.clone(); // Clone the material
                  child.material.color.set(customColor); // Set the custom color
                }
              }
            }
          });

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
};

window.relocateContainer = function (targetLot, targetContainer, areaName) {
  const scene = globalThis.scene;
  const targetObject = globalThis.targetObject;
  const currentLot = globalThis.objData.get(targetObject.parent?.uuid).lotNo;
  console.log("lotNo " + currentLot);
  const containerSize = globalThis.containerSize;
  const lotsData = globalThis.lotsData[`${areaName.toLowerCase()}_area`];
  lotsData[currentLot] = lotsData[currentLot].filter(
    (obj) => obj.container_nbr != targetContainer
  );
  lotsData[targetLot].push({ containerNbr: targetContainer });
  const count = lotsData[targetLot].length;
  const targetLotObj = scene.getObjectByName(areaName + "_" + targetLot);
  const targetLotPosition = targetLotObj.position;
  const currentLotPosition = scene.getObjectByName(
    areaName + "_" + currentLot
  ).position;

  const targetTitle = scene.getObjectByName(targetContainer);
  const titleBoundingBox = new THREE.Box3().setFromObject(targetTitle);
  const titleSize = new THREE.Vector3();
  titleBoundingBox.getSize(titleSize);

  highlightLotAndContainer(targetObject, targetTitle, targetLotObj);

  let topCon = 1;

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
        if (object.parent.position.y > targetObject.parent.position.y) {
          object.parent.position.set(
            object.parent.position.x,
            object.parent.position.y - topCon * containerSize.y,
            object.parent.position.z
          );

          if (object.parent.position.y === 0) {
            const customColor = new THREE.Color(0xff0000); // Red color

            // Iterate through all the meshes in the container and apply the color to their materials
            object.traverse((child) => {
              if (child.isMesh) {
                // For each mesh, check if it has a material and apply the color
                if (child.material) {
                  // Clone the material so that each container has its own unique material
                  if (Array.isArray(child.material)) {
                    // Handle cases where multiple materials exist for a mesh (array of materials)
                    child.material.forEach((material) => {
                      material = material.clone(); // Clone the material
                      material.color.set(customColor); // Set the custom color
                      child.material = material; // Apply the cloned material back to the mesh
                    });
                  } else {
                    // Single material for the mesh
                    child.material = child.material.clone(); // Clone the material
                    child.material.color.set(customColor); // Set the custom color
                  }
                }
              }
            });
          }

          const currentTitle = scene.getObjectByName(
            globalThis.objData.get(object.parent.uuid).containerNbr
          );

          const currentTitleBoundingBox = new THREE.Box3().setFromObject(
            currentTitle
          );
          const currentTitleSize = new THREE.Vector3();
          currentTitleBoundingBox.getSize(currentTitleSize);

          currentTitle.position.set(
            currentTitle.position.x,
            currentTitle.position.y - topCon * containerSize.y,
            currentTitle.position.z
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

  globalThis.objData.get(targetObject.parent?.uuid).lotNo = targetLot;

  const customColor =
    count == 1 ? new THREE.Color(0xff0000) : new THREE.Color(0xffffff); // Red color

  // Iterate through all the meshes in the container and apply the color to their materials
  targetObject.traverse((child) => {
    if (child.isMesh) {
      // For each mesh, check if it has a material and apply the color
      if (child.material) {
        // Clone the material so that each container has its own unique material
        if (Array.isArray(child.material)) {
          // Handle cases where multiple materials exist for a mesh (array of materials)
          child.material.forEach((material) => {
            material = material.clone(); // Clone the material
            material.color.set(customColor); // Set the custom color
            child.material = material; // Apply the cloned material back to the mesh
          });
        } else {
          // Single material for the mesh
          child.material = child.material.clone(); // Clone the material
          child.material.color.set(customColor); // Set the custom color
        }
      }
    }
  });

  targetTitle.position.set(
    targetObject.parent.position.x + containerSize.x / 2,
    targetObject.parent.position.y + containerSize.y / 2,
    targetObject.parent.position.z + titleSize.z / 2
  );

  globalThis.targetObject = null;
};

function highlightLotAndContainer(
  container,
  title,
  lot,
  highlightColor = 0xffff00,
  duration = 3000,
  interval = 500
) {
  const originalColor = lot.material.color.getHex();

  const blinkInterval = setInterval(() => {
    if (container.visible == true) {
      lot.material.color.set(highlightColor);
    } else {
      lot.material.color.set(originalColor);
    }
    container.visible = !container.visible;
    title.visible = container.visible;
  }, interval);

  // Revert the color after the specified duration
  setTimeout(() => {
    clearInterval(blinkInterval);
    container.visible = true;
    title.visible = true;
    lot.material.color.set(originalColor);
  }, duration);
}
