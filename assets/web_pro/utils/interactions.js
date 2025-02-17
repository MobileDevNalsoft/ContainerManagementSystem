import * as THREE from "three";

export function addInteractions() {
  const container = document.getElementById("container-yard-3dview");

  const raycaster = new THREE.Raycaster();

  const mouse = new THREE.Vector2();
  const lastPos = new THREE.Vector2();
  function onMouseMove(e) {
    if (e.target.classList.contains("ignoreRaycast")) {
      return;
    }
    const rect = container.getBoundingClientRect();
    mouse.x = ((e.clientX - rect.left) / rect.width) * 2 - 1;
    mouse.y = -((e.clientY - rect.top) / rect.height) * 2 + 1;

    raycaster.setFromCamera(mouse, camera);
    // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
    const intersects = raycaster.intersectObjects(scene.children, true);
    if (intersects.length > 0) {
      const targetObject = intersects[0].object;
    }
  }

  function onMouseDown(e) {
    lastPos.x = (e.clientX / container.clientWidth) * 2 - 1;
    lastPos.y = -(e.clientY / container.clientHeight) * 2 + 1;
  }

  function onMouseUp(e) {
    if (e.target.classList.contains("ignoreRaycast")) return;

    const tooltip = document.getElementById("tooltip");
    raycaster.setFromCamera(mouse, camera);
    // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
    const intersects = raycaster.intersectObjects(scene.children, true);
    if (intersects.length === 0) return;
    const targetObject = intersects[0].object;
    globalThis.targetObject = targetObject;

    console.log("name:", targetObject.name);
    if ((lastPos.distanceTo(mouse) <= 0.05) & (e.button === 0)) {
      if (targetObject.name.includes("lot")) {
        const areaName = targetObject.userData?.area;
        
        if (!areaName) return; // Prevent errors if `area` is undefined
        
        const areaData = lotsData[`${areaName.toLowerCase()}_area`];
        const lotNo = targetObject.name.split("_")[1];
        globalThis.lot = lotNo;

        if (areaData && areaData[lotNo]?.length <= 1) {
          console.log(JSON.stringify({ lotNo: lotNo, area: areaName }));
        }
      } else if (targetObject.name.includes("Container")) {
        const uuid = targetObject.parent?.uuid;
        if (uuid && globalThis.objData.has(uuid)) {
          globalThis.currentContainerUUID = uuid;
          console.log(
            JSON.stringify({
              containerNbr: globalThis.objData.get(uuid).containerNbr,
              area: globalThis.objData.get(uuid).area,
            })
          );
        }
      }
    } else if ((lastPos.distanceTo(mouse) <= 0.05) & (e.button === 2)) {
      if (targetObject.name.includes("Container")) {
        const uuid = targetObject.parent?.uuid;
        if (uuid && globalThis.objData.has(uuid)) {
          console.log(
            JSON.stringify({
              deleteContainer: globalThis.objData.get(uuid).containerNbr,
              area: globalThis.objData.get(uuid).area,
            })
          );
        }
      }
    }
  }

  window.addEventListener("mousemove", onMouseMove); // triggered when mouse pointer is moved.
  window.addEventListener("mousedown", onMouseDown);
  window.addEventListener("mouseup", onMouseUp); // triggered when mouse pointer is clicked.

  document.addEventListener("wheel", (event) => {});
}

export function updateTooltipPosition(targetObject, tooltip, camera) {
  if (!targetObject || !tooltip) return;

  // Get the object's world position
  const objectPosition = new THREE.Vector3();
  targetObject.getWorldPosition(objectPosition);

  // Convert world position to screen coordinates
  const vector = objectPosition.project(camera);
  const x = (vector.x * 0.5 + 0.5) * window.innerWidth;
  const y = (-(vector.y * 0.5) + 0.5) * window.innerHeight;

  // Position tooltip at the object's screen position
  tooltip.style.left = `${x}px`;
  tooltip.style.top = `${y - 60}px`; // Adjust to avoid overlapping
}
