import { loadModel } from "modelLoader";
import * as THREE from "three";
import * as GLTFLoader from "gltfLoader";

export async function loadEnvironment(){ 

const yardBase = new THREE.Group();

const gltf =  await loadModel("../glbs/yard_base.glb");
const model = gltf.scene;

    model.scale.set(6.8, 2.5, 6.8);
    model.position.set(0,-40,0);
    yardBase.add(model);
    scene.add(yardBase);
}