import * as THREE from "three";


const loadingManager = new THREE.LoadingManager();

let loadedItems = 0;
let totalItems = 0;


function updateProgress(){
  let percentComplete = (loadedItems/totalItems)*100;
  console.log('percent '+percentComplete);
  if(percentComplete >= 100){
    scene.visible = true;
  }
}

loadingManager.onLoad = function () {
  updateProgress();
}

loadingManager.onProgress = function (url, itemsLoaded, itemsTotal){
  loadedItems = itemsLoaded;
  totalItems = itemsTotal;
  updateProgress();
}

export async function startBuildingContainerYard() {
  const columnGap = 15;
  const rowGap = 10;
  const scale = 1;
  const padding = 50;
  const totalRows = json.containers.countPerRow;
  const totalColumns = json.containers.totalCount / totalRows;

  scene.visible = false;

  totalItems++; // Track model count
  const gltf = await loadModel("../glbs/blue_container.glb", loadingManager);
  loadedItems++;
  updateProgress();
  const container = gltf.scene;
  const containerBoundingBox = new THREE.Box3().setFromObject(container);
  const containerSize = new THREE.Vector3();
  container.scale.set(scale, scale, scale);
  containerBoundingBox.getSize(containerSize);

  
  let name = json.yard.name;
  let width =
    containerSize.z * scale * totalColumns + columnGap * (totalColumns + 1) + padding;
  let depth = containerSize.x * scale * totalRows + rowGap * (totalRows + 1) + padding;

  const yardGroup = new THREE.Group();

  const base = getBoxGeometry(width, 0.1, depth, 0xe6e6e6);

  yardGroup.add(base);

  const yard = convertGroupToSingleMesh(yardGroup);

  const yardMaterial = new THREE.MeshBasicMaterial({
    color: 0xa9a9a9
  });

  yard.material = yardMaterial;

  yard.position.set(0,0,0);

  yard.name = name;

  scene.add(yard);

  const yardCenter = new THREE.Vector3();
  yard.updateMatrixWorld();
  yard.getWorldPosition(yardCenter);

  const yardBoundingBox = new THREE.Box3().setFromObject(yard);
  const yardSize = new THREE.Vector3();
  yardBoundingBox.getSize(yardSize);

  const topRightCorner = new THREE.Vector3(
    yardCenter.x + yardSize.x / 2,
    yardCenter.y,
    yardCenter.z - yardSize.z / 2
  );

  container.rotation.y = -Math.PI / 2;

  for (let i = 0; i < totalColumns; i++) {
    for (let j = 0; j < totalRows; j++) {
      for (let k = 0; k < json.containers.levels; k++) {
        totalItems++;
        const containerClone = container.clone();
        containerClone.position.set(
          topRightCorner.x -
            (containerSize.z / 2) * scale -
            columnGap * (i + 1) -
            containerSize.z * scale * i - padding/2,
          topRightCorner.y + containerSize.y * scale * k,
          topRightCorner.z +
            (containerSize.x / 2) * scale +
            rowGap * (j + 1) +
            containerSize.x * scale * j + padding/2
        );
        scene.add(containerClone);


        const containerCenter = new THREE.Vector3();
        containerClone.updateMatrixWorld();
        containerClone.getWorldPosition(containerCenter);

        const serialNumber = i * totalRows * json.containers.levels + j * json.containers.levels + k;
        const fullText = `CON-${serialNumber.toString().padStart(4, '0')}`; // Combine text and serial number

        totalItems++;
        ThreeDText(fullText, 1, 0.1).then((title) => {
          const titleBoundingBox = new THREE.Box3().setFromObject(title);
          const titleSize = new THREE.Vector3();
          titleBoundingBox.getSize(titleSize);
          title.position.set(containerClone.position.x - titleSize.x / 2, containerClone.position.y + containerSize.y / 2, containerClone.position.z + containerSize.x / 2);
          scene.add(title);
          loadedItems++;
          updateProgress();
        });

        loadedItems++;
        updateProgress();
      }
    }
  }

  
}
