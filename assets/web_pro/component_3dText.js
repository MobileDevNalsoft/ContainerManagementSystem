import * as THREE from "three";
import { FontLoader } from "fontLoader";
import { TextGeometry } from "textGeometry";

window.ThreeDText = function (text, size, height, color) {
  // Load the font
  const loader = new FontLoader();
  return new Promise((resolve, reject) => {
    loader.load("./Gilroy.json", function (font) {
      const textGeometry = new TextGeometry(text, {
        font: font,
        size: size,
        depth: height,
        curveSegments: 12,
        bevelEnabled: true,
        bevelThickness: 0.1,
        bevelSize: 0.1,
        bevelOffset: 0,
        bevelSegments: 5,
      });

      const textMaterial = new THREE.MeshStandardMaterial({ color: color ?? 0X000000 }); // Red color
      const textMesh = new THREE.Mesh(textGeometry, textMaterial);
      resolve(textMesh);
    });
  });
}
