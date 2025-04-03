import * as THREE from "three";

window.buildAreas = async function () {
  buildArea(
    json.areas.dryArea,
    lotsData.dry_area,
    new THREE.Vector3(-100, 0, -200),
    0x999999
  );
  buildArea(
    json.areas.damagedArea,
    lotsData.damaged_area,
    new THREE.Vector3(185, 0, -225),
    0x999999
  );
  buildArea(
    json.areas.refrigeratedArea,
    lotsData.refrigerated_area,
    new THREE.Vector3(-100, 0, 20),
    0x999999
  );
  buildArea(
    json.areas.emptyArea,
    lotsData.empty_area,
    new THREE.Vector3(185, 0, -5),
    0x999999
  );
};

let lots = [];
let containers = [];
let dragControls;
const rowGap = 3;
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

  const edges = new THREE.EdgesGeometry(area.geometry);
  const edgePositions = edges.attributes.position.array; // Vertex positions
  const borderGroup = new THREE.Group();

  for (let i = 0; i < edgePositions.length; i += 6) {
    const start = new THREE.Vector3(
      edgePositions[i],
      edgePositions[i + 1],
      edgePositions[i + 2]
    );
    const end = new THREE.Vector3(
      edgePositions[i + 3],
      edgePositions[i + 4],
      edgePositions[i + 5]
    );

    // Create a thin box along the edge
    const direction = end.clone().sub(start);
    const length = direction.length();
    const geometry = new THREE.BoxGeometry(length, 1, 1); // Adjust width/height for thickness
    const material = new THREE.MeshBasicMaterial({ color: getBorderColor(areaJson.name) });
    const edgeMesh = new THREE.Mesh(geometry, material);

    // Position and orient the mesh
    edgeMesh.position.copy(start).lerp(end, 0.5); // Center between start and end
    edgeMesh.quaternion.setFromUnitVectors(
      new THREE.Vector3(1, 0, 0),
      direction.normalize()
    );

    borderGroup.add(edgeMesh);
  }

  borderGroup.position.copy(area.position);
  areaGroup.add(borderGroup);

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
      const lot = getBoxGeometry(lotWidth, 0.1, lotDepth, 0x999999);
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
      border.name = lot.name + "_border";
      lot.userData = {
        area: areaJson.name,
      };
      lots.push(lotGroup);

      // for (let i = 0; i < areaLotsData[lotNo].length; i++) {
        // const containerGroup = new THREE.Group();
        // const containerClone = container.clone();
        // containerClone.position.set(
        //   lot.position.x,
        //   lot.position.y + i * containerSize.y,
        //   lot.position.z
        // );
        // const customColor = getColor();

        // // Iterate through all the meshes in the container and apply the color to their materials
        // containerClone.traverse((child) => {
        //   if (child.isMesh) {
        //     // For each mesh, check if it has a material and apply the color
        //     if (child.material) {
        //       // Clone the material so that each container has its own unique material
        //       if (Array.isArray(child.material)) {
        //         // Handle cases where multiple materials exist for a mesh (array of materials)
        //         child.material.forEach((material) => {
        //           material = material.clone(); // Clone the material
        //           material.color.set(customColor); // Set the custom color
        //           child.material = material; // Apply the cloned material back to the mesh
        //         });
        //       } else {
        //         // Single material for the mesh
        //         child.material = child.material.clone(); // Clone the material
        //         child.material.color.set(customColor); // Set the custom color
        //       }
        //     }
        //   }
        // });
        // containerGroup.add(containerClone);

        // await ThreeDText(
        //   areaLotsData[lotNo][i].container_nbr,
        //   1,
        //   0.1,
        //   0xffffff
        // ).then((title) => {
        //   const titleBoundingBox = new THREE.Box3().setFromObject(title);
        //   const titleSize = new THREE.Vector3();
        //   titleBoundingBox.getSize(titleSize);
        //   title.raycast = () => {};
        //   title.rotation.y = Math.PI / 2;
        //   title.position.set(
        //     containerClone.position.x + containerSize.x / 2,
        //     containerClone.position.y + containerSize.y / 2,
        //     containerClone.position.z + titleSize.x / 2
        //   );
        //   title.name = areaLotsData[lotNo][i].container_nbr;
        //   containerGroup.add(title);
        // });
        // scene.add(containerGroup);
        // const uuid = containerClone.uuid;
        // globalThis.objData.set(uuid, {
        //   containerNbr: areaLotsData[lotNo][i].container_nbr,
        //   arrivalTime: areaLotsData[lotNo][i]?.arrival_time,
        //   customerName: areaLotsData[lotNo][i]?.customer_name,
        //   area: areaJson.name,
        //   lotNo: lotNo,
        // });
        // containers.push(containerClone);
      // }
    }
  }
  globalThis.containers = containers;
}

window.getColor = function () {
  const colors = [0xff0000, 0x6cc24a, 0x6484f3, 0xbd7c3b];

  const randomIndex = Math.floor(Math.random() * colors.length);
  
  return new THREE.Color(colors[randomIndex]);
};


window.getBorderColor = function (area) {
  switch (area) {
    case 'DRY':
      return new THREE.Color(0x00B7EB);
    case 'REFRIGERATED':
      return new THREE.Color(0xc2f530);
    case 'DAMAGED':
      return new THREE.Color(0xd46942);
    case 'EMPTY':
      return new THREE.Color(0xe5e5e5);
  }
};


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
