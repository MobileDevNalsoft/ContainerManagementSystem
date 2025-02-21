import * as THREE from "three";

window.addInteractions = function () {
  const scene = globalThis.scene;
  const container = document.getElementById("container-yard-3dview");

  const raycaster = new THREE.Raycaster();

  const mouse = new THREE.Vector2();
  const lastPos = new THREE.Vector2();
  globalThis.tooltip = document.getElementById("tooltip");
  globalThis.areaFocused = false;
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
      globalThis.hoverObject = targetObject;
      const name = targetObject.name;
      if (name.includes("Container")) {
        const uuid = targetObject.parent?.uuid;
        if (uuid && globalThis.objData.has(uuid)) {
          const containerData = globalThis.objData.get(uuid);
          switch (containerData.area) {
            case "DRY":
            case "REFRIGERATED":
            case "EMPTY":
              const arrivalDate = containerData.arrivalTime.split(" ")[0];
              const detentionDays = getDaysDiff(arrivalDate);
              const detentionText =
                detentionDays > 0 ? `Detention Days: ${detentionDays}<br>Detention Cost: ${detentionDays*500}Rs` : "";
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${containerData.containerNbr}</strong><div class="tooltip-content">
                                            Customer Name: ${containerData.customerName}<br>
                                            Arrival Date: ${arrivalDate}<br>
                                            ${detentionText}
                                            </div>`;
              break;
            case "DAMAGED":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${containerData.containerNbr}</strong>`;
              break;
          }
          setToolTipPosition(targetObject, tooltip, camera);
        }
      } else if (name.includes("AREA") && areaFocused == false) {
        const areaLots = lotsData[`${name.toLowerCase()}`];
        const totalLots = Object.keys(areaLots).length;
        const availableLots = Object.keys(areaLots).filter(
          (lot) => areaLots[lot].length < 2
        ).length;
        tooltip.style.display = "block";
        tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                            Available Lots: ${availableLots}<br>
                                            Occupied Lots: ${
                                              totalLots - availableLots
                                            }
                                            </div>`;
        setToolTipPosition(targetObject, tooltip, camera);
      } else if(name.includes('YARD')){
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>YARD</strong>`;
              tooltip.style.left = `${e.clientX + 10}px`; // Offset for better visibility
              tooltip.style.top = `${e.clientY + 10}px`;
      }
      else {
        tooltip.style.display = "none";
      }
    }
  }

  window.setToolTipPosition = function (targetObject, tooltip, camera) {
    // Position tooltip at the mouse location
    const objectPosition = new THREE.Vector3();
    targetObject.getWorldPosition(objectPosition);

    // Convert world position to screen coordinates
    const vector = objectPosition.project(camera);
    const x = (vector.x * 0.5 + 0.5) * window.innerWidth;
    const y = (-(vector.y * 0.5) + 0.5) * window.innerHeight;

    // Position tooltip at the center of the object's position
    tooltip.style.left = `${x}px`;
    tooltip.style.top = `${y - 60}px`;
  };

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
    const name = targetObject.name;
    console.warn("name:", name);
    if ((lastPos.distanceTo(mouse) <= 0.01) & (e.button === 0)) {
      if (name.includes("lot")) {
        const areaName = targetObject.userData?.area;

        if (!areaName) return; // Prevent errors if `area` is undefined

        const areaData = lotsData[`${areaName.toLowerCase()}_area`];
        const lotNo = name.split("_")[1];
        globalThis.lot = lotNo;

        if (areaData && areaData[lotNo]?.length <= 3) {
          console.log(JSON.stringify({ lotNo: lotNo, area: areaName }));
        }
      } else if (name.includes("Container")) {
        const uuid = targetObject.parent?.uuid;
        if (uuid && globalThis.objData.has(uuid)) {
          globalThis.currentContainerUUID = uuid;
          console.log(
            JSON.stringify({
              containerNbr: globalThis.objData.get(uuid).containerNbr,
              area: globalThis.objData.get(uuid).area,
              lotNo: globalThis.objData.get(uuid).lotNo
            })
          );
        }
      } else if (name.includes("AREA")) {
        areaFocused = true;
        switchCamera();
      } else if (name.includes('YARD')){
        switchCamera();
      }
    } else if ((lastPos.distanceTo(mouse) <= 0.01) & (e.button === 2)) {
      if (name.includes("Container")) {
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
    }else {
      areaFocused = false;
    }
  }

  window.addEventListener("mousemove", onMouseMove); // triggered when mouse pointer is moved.
  window.addEventListener("mousedown", onMouseDown);
  window.addEventListener("mouseup", onMouseUp); // triggered when mouse pointer is clicked.

  document.addEventListener("wheel", (event) => {
    tooltip.style.display = "none";
    areaFocused = false;
  });
};
