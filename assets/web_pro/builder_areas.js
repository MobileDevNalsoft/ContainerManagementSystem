import * as THREE from "three";

window.buildAreas = async function () {
  buildArea(
    json.areas.dryArea,
    lotsData.dry_area,
    new THREE.Vector3(-60, 0, 0),
    0xd2b48c
  );
  buildArea(
    json.areas.damagedArea,
    lotsData.damaged_area,
    new THREE.Vector3(150, 0, 0),
    0xe07d77
  );
  buildArea(
    json.areas.refrigeratedArea,
    lotsData.refrigerated_area,
    new THREE.Vector3(-60, 0, 150),
    0xadd8e6
  );
  buildArea(
    json.areas.emptyArea,
    lotsData.empty_area,
    new THREE.Vector3(150, 0, 150),
    0xf5f5f5
  );
};

let lots = [];
let containers = [];
let dragControls;
const rowGap = 10;
const columnGap = 20;
const padding = 40;

async function buildArea(areaJson, areaLotsData, position, color) {
  const totalColumns = Object.keys(areaLotsData).length / areaJson.lotsPerRow;
  const totalRows = areaJson.lotsPerRow;
  const width =
    json.lotSize.width * totalRows + rowGap * (totalRows - 1) + padding;
  const depth =
    json.lotSize.depth * totalColumns +
    columnGap * (totalColumns - 1) +
    padding;
  const lotWidth = json.lotSize.width;
  const lotDepth = json.lotSize.depth;

  const areaGroup = new THREE.Group();

  const area = getBoxGeometry(width, 0.05, depth, color);

  area.position.set(position.x, position.y, position.z);

  area.name = areaJson.name + "_AREA";

  const edges = new THREE.EdgesGeometry(area.geometry); // Get edges of the box
  const borderMaterial = new THREE.LineBasicMaterial({
    color: 0x000000,
    linewidth: 2,
  }); // Black border
  const border = new THREE.LineSegments(edges, borderMaterial);
  border.position.copy(area.position); // Align border with lot
  areaGroup.add(border); // Add border to the scene

  const areaCenter = new THREE.Vector3();
  area.updateMatrixWorld();
  area.getWorldPosition(areaCenter);

  const areaBoundingBox = new THREE.Box3().setFromObject(area);
  const areaSize = new THREE.Vector3();
  areaBoundingBox.getSize(areaSize);

  const topLeftCorner = new THREE.Vector3(
    areaCenter.x - areaSize.x / 2,
    areaCenter.y,
    areaCenter.z - areaSize.z / 2
  );

  areaGroup.add(area);

  scene.add(areaGroup);

  await ThreeDText(areaJson.name, 5, 0.1, 0x000000).then((title) => {
    const titleBoundingBox = new THREE.Box3().setFromObject(title);
    const titleSize = new THREE.Vector3();
    titleBoundingBox.getSize(titleSize);
    title.rotation.x = -Math.PI / 2;
    title.position.set(
      areaCenter.x - titleSize.x / 2,
      areaCenter.y,
      areaCenter.z + areaSize.z / 2.12
    );
    scene.add(title);
  });

  const gltf = await loadModel("../glbs/white_container.glb");
  const container = gltf.scene;
  globalThis.container = container;

  const containerBoundingBox = new THREE.Box3().setFromObject(container);
  const containerSize = new THREE.Vector3();
  containerBoundingBox.getSize(containerSize);
  globalThis.containerSize = containerSize;

  for (let i = 0; i < totalRows; i++) {
    for (let j = 0; j < totalColumns; j++) {
      const lotGroup = new THREE.Group();
      const lot = getBoxGeometry(lotWidth, 0.1, lotDepth, 0xe6e6e6);
      lot.position.set(
        topLeftCorner.x +
          lotWidth / 2 +
          rowGap +
          lotWidth * i +
          rowGap * (i - 1) +
          padding / 2,
        topLeftCorner.y,
        topLeftCorner.z +
          lotDepth / 2 +
          columnGap +
          lotDepth * j +
          columnGap * (j - 1) +
          padding / 2
      );
      lotGroup.add(lot);

      const edges = new THREE.EdgesGeometry(lot.geometry); // Get edges of the box
      const borderMaterial = new THREE.LineBasicMaterial({
        color: 0x000000,
        linewidth: 2,
      }); // Black border
      const border = new THREE.LineSegments(edges, borderMaterial);
      border.position.copy(lot.position); // Align border with lot
      lotGroup.add(border); // Add border to the scene
      
      const lotCenter = new THREE.Vector3();
      lot.updateMatrixWorld();
      lot.getWorldPosition(lotCenter);
      
      const serialNumber = i + 1 + totalRows * j;
      
      await ThreeDText(serialNumber.toString(), 1, 0.1).then((title) => {
        const titleBoundingBox = new THREE.Box3().setFromObject(title);
        const titleSize = new THREE.Vector3();
        titleBoundingBox.getSize(titleSize);
        title.rotation.x = -Math.PI / 2;
        title.position.set(
          lot.position.x - titleSize.x / 2,
          lot.position.y + 0.025,
          lot.position.z + lotDepth / 2.2
        );
        lotGroup.add(title);
      });
      
      scene.add(lotGroup);
      
      let lotNo = "lot" + (i + 1 + totalRows * j);
      lot.name = areaJson.name + "_" + lotNo;
      border.name = lot.name+'_border';
      lot.userData = {
        area: areaJson.name,
      };
      lots.push(lotGroup);

      for (let i = 0; i < areaLotsData[lotNo].length; i++) {
        const containerGroup = new THREE.Group();
        const containerClone = container.clone();
        containerClone.position.set(
          lot.position.x,
          lot.position.y + i * containerSize.y,
          lot.position.z
        );
        const customColor = i == 0 ? new THREE.Color(0xff0000) : new THREE.Color(0xffffff); // Red color

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
        containerGroup.add(containerClone);

        await ThreeDText(
          areaLotsData[lotNo][i].container_nbr,
          1,
          0.1,
          0xffffff
        ).then((title) => {
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
          title.name = areaLotsData[lotNo][i].container_nbr;
          containerGroup.add(title);
        });
        scene.add(containerGroup);
        const uuid = containerClone.uuid;
        globalThis.objData.set(uuid, {
          containerNbr: areaLotsData[lotNo][i].container_nbr,
          arrivalTime: areaLotsData[lotNo][i]?.arrival_time,
          customerName: areaLotsData[lotNo][i]?.customer_name,
          area: areaJson.name,
          lotNo: lotNo,
        });
        containers.push(containerClone);
      }
    }
  }
  globalThis.containers = containers;
}

function enableDragging() {
  dragControls = new DragControls(containers, camera, renderer.domElement);

  let selectedContainer = null;
  let originalPosition = new THREE.Vector3();
  let mouse = new THREE.Vector2();
  const raycaster = new THREE.Raycaster();

  // Mouse move listener (to get correct mouse coordinates)
  window.addEventListener("pointermove", (e) => {
    const container = document.getElementById("container-yard-3dview");
    const rect = container.getBoundingClientRect();
    mouse.x = ((e.clientX - rect.left) / rect.width) * 2 - 1;
    mouse.y = -((e.clientY - rect.top) / rect.height) * 2 + 1;
  });

  // Drag start
  dragControls.addEventListener("dragstart", (event) => {
    controls.enabled = false;
    selectedContainer = event.object;
    originalPosition.copy(selectedContainer.position);
  });

  // Dragging: Check if the container is over a lot
  dragControls.addEventListener("drag", () => {
    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObjects(lots, true);

    if (intersects.length > 0) {
      const targetLot = intersects.find((intersect) =>
        intersect.object.name.startsWith("lot")
      );
      if (targetLot) {
        console.log("Hovering over:", targetLot.object.name);
        targetLot.object.material.color.set(0x00ff00); // Highlight the target lot
      }
    }
  });

  // Drag end: Snap to the center of the lot
  dragControls.addEventListener("dragend", (event) => {
    controls.enabled = true;
    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObjects(lots, true);

    if (intersects.length > 0) {
      const targetLot = intersects.find((intersect) =>
        intersect.object.name.startsWith("lot")
      );
      if (targetLot) {
        console.log("Dropped on:", targetLot.object.name);
        console.log(
          targetLot.object.position.x +
            " " +
            targetLot.object.position.y +
            " " +
            targetLot.object.position.z
        );

        // Move container to the exact center
        event.object.position.set(
          targetLot.object.position.x - containerSize.x * 1.21,
          targetLot.object.position.y + containerSize.y / 2, // Stack on top of the lot
          targetLot.object.position.z
        );

        targetLot.object.material.color.set(0xe6e6e6); // Reset color after dropping
      }
    } else {
      event.object.position.copy(originalPosition); // Revert if not dropped on a valid lot
    }
  });
}
