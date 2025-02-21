window.loadJSON = async function (path) {
    const data = await fetch(path)
        .then(response => {
            // Check if the response is okay (status code 200-299)
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            // Parse the response body as JSON
            return response.json();
        })
        .catch(error => {
            console.error('Error fetching data:', error);
        });
    globalThis.json = data;
}