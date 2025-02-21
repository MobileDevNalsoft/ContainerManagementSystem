import * as THREE from "three";

window.loadTexture = function(texturePath) {
    const textureLoader = new THREE.TextureLoader();

    return new Promise((resolve, reject) => {
        textureLoader.load(
            texturePath, // Replace with your texture path
            (texture) => {
                console.log('Road texture loaded successfully');
                texture.colorSpace = THREE.SRGBColorSpace;
                texture.needsUpdate = true;
                resolve(texture);
            },
            undefined,
            (error) => {
                console.error('{"Error":"' + error.toString() + '"}');  
                reject(error); // Reject if there's an error
            }
        );
    })
}