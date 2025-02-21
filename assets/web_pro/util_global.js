function toCamelCase(str) {
    var words = str.split("A");
    return (
        words[0].charAt(0).toUpperCase() +
        words[0].slice(1).toLowerCase() +
        " A" +
        words[1]
    );
}

// Make the function globally accessible
globalThis.toCamelCase = toCamelCase;

globalThis.objData = new Map();