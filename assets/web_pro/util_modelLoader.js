import * as GLTFLoader from "gltfLoader";
import {DRACOLoader} from "draco";

window.loadModel = function(modelPath) {
    const loader = new GLTFLoader.GLTFLoader();

    return new Promise((resolve, reject) => {
        // Create and configure the DRACOLoader
        const dracoLoader = new DRACOLoader();
        dracoLoader.setDecoderPath('https://cdn.jsdelivr.net/npm/three@0.114.0/examples/js/libs/draco/');
        loader.setDRACOLoader( dracoLoader );
        loader.load(
            modelPath,
            function (gltf) {
                resolve(gltf); // Resolve with the loaded glTF model
            },
            (xhr) => {
                if(xhr.lengthComputable){
                    let percentComplete = (xhr.loaded/xhr.total)*100;

                    console.log('{"percentComplete":"' +
                         Math.round(percentComplete)
                          + '"}')
                }
            },
            undefined,
            function (error) {
                console.error('{"Error":"' + error.toString() + '"}');  
                reject(error); // Reject if there's an error
            }
        );
    })
}