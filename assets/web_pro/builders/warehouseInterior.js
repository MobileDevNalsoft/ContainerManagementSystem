import * as THREE from "three";
import { getPlaneGeometry } from "plane";
import { buildStorageArea } from "storageArea";
import { buildInspectionArea } from "inspectionArea";
import { buildStagingArea } from "stagingArea";
import { buildActivityArea } from "activityArea";
import { buildReceivingArea } from "receivingArea";

export function buildAreas(json, scene, warehouseCenter, width, depth){
    let nextAreaPosition = new THREE.Vector3(warehouseCenter.x-width/2+json['areas'][0]['width']/2, warehouseCenter.y+0.05, warehouseCenter.z-depth/2+json['areas'][0]['depth']/2);
    let coveredWidth = json['areas'][0]['width'];

    json['areas'].forEach((item, index) => {
        const area = getPlaneGeometry(item['width'], item['depth'], 0xe6e6e6);
        area.name = item['name'];
        console.log('coveredWidth '+coveredWidth+' width '+width);
        if(coveredWidth <= width){
            area.position.set(nextAreaPosition.x, nextAreaPosition.y, nextAreaPosition.z);
            scene.add(area);
            nextAreaPosition.x = nextAreaPosition.x + item['width']/2+json['areas'][index+1]['width']/2;
            console.log('index '+ index+ 'length ' +json['areas'].length);
            if(index < json['areas'].length){
                coveredWidth = coveredWidth + json['areas'][index+1]['width'];
            }
        }else{
            console.log(warehouseCenter.x + " " + warehouseCenter.y + " " + warehouseCenter.z);
            console.log(nextAreaPosition.x + " " + nextAreaPosition.y + " " + nextAreaPosition.z);
        }
    });
    
    
}

export function buildWarehouseInterior(json, scene, warehouseCenter){
    buildStorageArea(json, scene, warehouseCenter);
    buildInspectionArea(json, scene, warehouseCenter);
    buildStagingArea(json, scene, warehouseCenter);
    buildActivityArea(json, scene, warehouseCenter);
    buildReceivingArea(json, scene, warehouseCenter);
}
