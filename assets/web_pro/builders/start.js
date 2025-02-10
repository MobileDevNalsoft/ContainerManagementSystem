import * as THREE from 'three';
import { buildCompound } from "compound";

export function startBuildingWarehouse(json, scene){
    buildCompound(json ,scene);
}