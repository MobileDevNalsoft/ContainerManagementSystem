import * as THREE from "three";
import { FontLoader } from "fontLoader";
import { TextGeometry } from "textGeometry";

export function ThreeDText(text, size, height) {
  // Load the font
  const loader = new FontLoader();
  return new Promise((resolve, reject) => {
    loader.load("../fonts/Gilroy.json", function (font) {
      const textGeometry = new TextGeometry(text, {
        font: font,
        size: size,
        depth: height,
        curveSegments: 12,
        bevelEnabled: true,
        bevelThickness: 0.05,
        bevelSize: 0.05,
        bevelOffset: 0,
        bevelSegments: 5,
      });

      const textMaterial = new THREE.MeshStandardMaterial({ color: 0x666666 }); // Red color
      const textMesh = new THREE.Mesh(textGeometry, textMaterial);
      resolve(textMesh);
    });
  });
}
