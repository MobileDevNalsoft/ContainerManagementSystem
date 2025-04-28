import * as THREE from "three";

window.storeLotsData = function (data) {
  globalThis.lotsData = JSON.parse(data);
};

window.storeLotsDataFromLocal = function () {
  // if(window.localStorage.getItem('area_lots_data') !== null){
  //   globalThis.lotsData = JSON.parse(window.localStorage.getItem('area_lots_data'));
  // }else{
    console.log('{"getLotsData":"null"}');
  // }
}

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
  const customColor = getColor(); // Red color

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

window.deleteContainer = function (containerNbr, areaName) {
  const scene = globalThis.scene;
  const targetObject = scene.getObjectByName('CON_'+containerNbr);
  const currentLot = globalThis.objData.get(targetObject?.uuid).lotNo;
  const containerSize = globalThis.containerSize;
  const lotsData = globalThis.lotsData[`${areaName}`]['lots'];
  console.warn('delete container '+targetObject.name);
  console.warn('delete container before'+JSON.stringify(lotsData));
  lotsData[currentLot] = lotsData[currentLot].filter(
    (obj) => obj.shipment != targetContainer
  );

  if (!targetObject) {
    console.warn("No target object selected.");
    return;
  }

  console.warn('delete container after'+JSON.stringify(lotsData));

  globalThis.scene.traverse((object) => {
    if (object.isMesh) {
      // Ensure it's a 3D object, not a Group or Light
      if (
        object.name.includes("CON") &&
        object.position.x == currentLotPosition.x &&
        object.position.z == currentLotPosition.z
      ) {
        console.log(
          `relocation Object: ${object.name || object.parent.uuid || containerSize.y/2}, Position:`,
          object.position.x +
            " " +
            object.position.y +
            " " +
            object.position.z
        );
        if (object.position.y > targetObject.position.y) {
          object.position.set(
            object.position.x,
            object.position.y - containerSize.y,
            object.position.z
          );

            const customColor = getColor();

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
            globalThis.objData.get(object.uuid).containerNbr
          );

          
          const currentTitleBoundingBox = new THREE.Box3().setFromObject(
            currentTitle
          );
          const currentTitleSize = new THREE.Vector3();
          currentTitleBoundingBox.getSize(currentTitleSize);
          
          currentTitle.position.set(
            currentTitle.position.x,
            currentTitle.position.y - containerSize.y,
            currentTitle.position.z
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
      targetObject.name.split('_')[1]
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

window.relocateContainer = function (targetLot, targetContainer, areaName, targetAreaName) {
  const scene = globalThis.scene;
  const targetObject = scene.getObjectByName('CON_'+targetContainer);
  const currentLot = globalThis.objData.get(targetObject?.uuid).lotNo;
  const containerSize = globalThis.containerSize;
  const lotsData = globalThis.lotsData[`${areaName}`]['lots'];
  lotsData[currentLot] = lotsData[currentLot].filter(
    (obj) => obj.shipment != targetContainer
  );
  const targetAreaLotsData = globalThis.lotsData[`${targetAreaName}`]['lots'];
  targetAreaLotsData[targetLot].push({ shipment: targetContainer, lvl: targetAreaLotsData[targetLot].length+1 });
  const count = targetAreaLotsData[targetLot].length;
  const targetLotObj = scene.getObjectByName(targetLot);
  const targetLotPosition = targetLotObj.position;
  const currentLotPosition = scene.getObjectByName(
    currentLot
  ).position;

  const targetTitle = scene.getObjectByName(targetContainer);
  const titleBoundingBox = new THREE.Box3().setFromObject(targetTitle);
  const titleSize = new THREE.Vector3();
  titleBoundingBox.getSize(titleSize);

  highlightLotAndContainer(targetObject, targetTitle, targetLotObj);

  globalThis.scene.traverse((object) => {
    if (object.isMesh) {
      // Ensure it's a 3D object, not a Group or Light
      if (
        object.name.includes("CON") &&
        object.position.x == currentLotPosition.x &&
        object.position.z == currentLotPosition.z
      ) {
        console.warn('relocation container name '+object.name);
        console.log(
          `relocation Object: ${object.name || object.parent.uuid || containerSize.y/2}, Position:`,
          object.position.x +
            " " +
            object.position.y +
            " " +
            object.position.z
        );
        if (object.position.y > targetObject.position.y) {
          object.position.set(
            object.position.x,
            object.position.y - containerSize.y,
            object.position.z
          );

            const customColor = getColor();

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
            globalThis.objData.get(object.uuid).containerNbr
          );

          
          const currentTitleBoundingBox = new THREE.Box3().setFromObject(
            currentTitle
          );
          const currentTitleSize = new THREE.Vector3();
          currentTitleBoundingBox.getSize(currentTitleSize);
          
          currentTitle.position.set(
            currentTitle.position.x,
            currentTitle.position.y - containerSize.y,
            currentTitle.position.z
          );
        }
      }
    }
  });

  targetObject.position.set(
    targetLotPosition.x,
    targetLotPosition.y + (count - 1) * containerSize.y,
    targetLotPosition.z
  );

  globalThis.objData.get(targetObject?.uuid).lotNo = targetLot;

  const customColor = getColor();

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
    targetObject.position.x + containerSize.x / 2,
    targetObject.position.y + containerSize.y / 2,
    targetObject.position.z + titleSize.z / 2
  );

  globalThis.targetObject = null;
};

const activeHighlights = new Map();

function highlightLotAndContainer(
  container,
  title,
  lot,
  highlightColor = 0xffff00,
  duration = 3000,
  interval = 500
) {
  const key = lot.uuid;

  // If it's already blinking — skip this call
  if (lot.userData.isBlinking) {
    console.log(`Highlight already active for ${lot.name}, skipping.`);
    return;
  }

  const originalColor = lot.material.color.getHex();

  lot.userData.isBlinking = true;

  const intervalId = setInterval(() => {
    if (container.visible === true) {
      lot.material.color.set(highlightColor);
    } else {
      lot.material.color.set(originalColor);
    }
    container.visible = !container.visible;
    title.visible = container.visible;
  }, interval);

  const timeoutId = setTimeout(() => {
    clearInterval(intervalId);
    container.visible = true;
    title.visible = true;
    lot.material.color.set(originalColor);
    lot.userData.isBlinking = false;
    activeHighlights.delete(key);
  }, duration);

  activeHighlights.set(key, { intervalId, timeoutId });
}


window.goToContainer = function (containerNbr, lotNo){
  const scene = globalThis.scene;
  const container = scene.getObjectByName('CON_'+containerNbr);
  const title = scene.getObjectByName(containerNbr);
  const lot = scene.getObjectByName(lotNo);

  highlightLotAndContainer(container, title, lot);
}
