import * as THREE from "three";

window.buildAreas = async function () {
  buildArea(
    json.areas.dryArea,
    lotsData.DRY,
    new THREE.Vector3(-100, 0, -220),
    0x999999
  );
  buildArea(
    json.areas.damagedArea,
    lotsData.DAMAGED,
    new THREE.Vector3(185, 0, -245),
    0x999999
  );
  buildArea(
    json.areas.refrigeratedArea,
    lotsData.REFRIGERATED,
    new THREE.Vector3(-100, 0, 0),
    0x999999
  );
  buildArea(
    json.areas.emptyArea,
    lotsData.EMPTY,
    new THREE.Vector3(185, 0, -25),
    0x999999
  );
  buildArea(
    json.areas.unassignedArea,
    lotsData.UNASSIGNED,
    new THREE.Vector3(100, 0, 190),
    0x999999
  );
};

let lots = [];
let containers = [];
const rowGap = 3;
const columnGap = 20;
const padding = 40;

async function buildArea(areaJson, areaLotsData, position, color) {
  const totalColumns = areaLotsData.max_lots / areaJson.lotsPerRow;
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

  console.log('area name : ', area.name);

  const edges = new THREE.EdgesGeometry(area.geometry);
  const edgePositions = edges.attributes.position.array; // Vertex positions
  const borderGroup = new THREE.Group();
  borderGroup.name = area.name + '_BORDER'

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

  const gltf = await loadModel("../glbs/final_container.glb");
  const container = gltf.scene;
  // const containerGeometry = new THREE.BoxGeometry(8, 8, 20);
  // containerGeometry.translate(0, 4, 0);
  // const containerMaterial = new THREE.MeshBasicMaterial({ color: 0xffffff });
  // const container = new THREE.Mesh(containerGeometry, containerMaterial);
  globalThis.container = container;

  const containerBoundingBox = new THREE.Box3().setFromObject(container);
  const containerSize = new THREE.Vector3();
  containerBoundingBox.getSize(containerSize);
  globalThis.containerSize = containerSize;

  const baseMesh = container.getObjectByProperty('type', 'Mesh')?.clone();
  const sharedGeometry = baseMesh.geometry;
  sharedGeometry.scale(0.029, 0.029, 0.029);
  sharedGeometry.rotateY(Math.PI/2);
  const sharedMaterial = baseMesh.material;

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
      lot.getWorldPosition(lotCenter);

      const serialNumber = i + 1 + totalRows * j;

      await ThreeDText(serialNumber.toString(), 1, 0.1).then((title) => {
        title.rotation.x = -Math.PI / 2;
        title.position.set(
          lot.position.x - 1,
          lot.position.y + 0.025,
          lot.position.z + lotDepth / 2.2
        );
        lotGroup.add(title);
      });

      areaGroup.add(lotGroup);

      lot.name = areaJson.name + "_" + (i + 1 + totalRows * j);
      border.name = lot.name + "_border";
      lot.userData = {
        area: areaJson.name,
      };
      lots.push(lotGroup);

      for (let i = 0; i < areaLotsData.lots[lot.name]?.length; i++) {
        const containerGroup = new THREE.Group();
        const containerClone = new THREE.Mesh(sharedGeometry, sharedMaterial.clone());
        const customColor = getColor();
        containerClone.material.color.set(customColor);
        const containerName = 'CON_'+ areaLotsData.lots[lot.name][i].shipment;
        containerClone.name = containerName;
        containerClone.traverse((child) => {
          if (child.isObject3D) {
            child.name = containerName; // Ensure all children have the same name
          }
        });
        containerClone.position.set(
          lot.position.x,
          lot.position.y + (areaLotsData.lots[lot.name][i].lvl - 1) * containerSize.y,
          lot.position.z
        );
        containerGroup.add(containerClone);

        await ThreeDText(
          areaLotsData.lots[lot.name][i].shipment,
          1,
          0.1,
          0xffffff
        ).then((title) => {
          title.raycast = () => {};
          title.rotation.y = Math.PI / 2;
          title.position.set(
            containerClone.position.x + containerSize.x / 2,
            containerClone.position.y + containerSize.y/2,
            containerClone.position.z + 6
          );
          title.name = areaLotsData.lots[lot.name][i].shipment;
          containerGroup.add(title);
        });
        areaGroup.add(containerGroup);
        const uuid = containerClone.uuid;
        globalThis.objData.set(uuid, {
          shipment: areaLotsData.lots[lot.name][i].shipment,
          containerNbr: areaLotsData.lots[lot.name][i].container_nbr,
          liner: areaLotsData.lots[lot.name][i].liner,
          arrivalDate: areaLotsData.lots[lot.name][i].arrival_date,
          expectedEndDate: areaLotsData.lots[lot.name][i]?.expected_end_date,
          customerName: areaLotsData.lots[lot.name][i]?.customer,
          days: areaLotsData.lots[lot.name][i]?.days,
          area: areaJson.name,
          lotNo: lot.name,
        });
        containers.push(containerClone);
      }
    }
  }
 
//   scene.add(areaGroup);
  globalThis.containers = containers;
}

window.getColor = function () {
  const colors = [0xff0000, 0x6cc24a, 0x6484f3, 0xbd7c3b];

  const randomIndex = Math.floor(Math.random() * colors.length);

  return new THREE.Color(colors[randomIndex]);
};

window.getBorderColor = function (area) {
  switch (area) {
    case "DRY":
      return new THREE.Color(0x00b7eb);
    case "REFRIGERATED":
      return new THREE.Color(0xc2f530);
    case "DAMAGED":
      return new THREE.Color(0xd46942);
    case "EMPTY":
      return new THREE.Color(0x9c9391);
    case "UNASSIGNED":
      return new THREE.Color(0xe5e5e5);
  }
};