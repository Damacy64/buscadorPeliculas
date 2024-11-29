async function fetchMovie() {
    const title = document.getElementById("movie-title").value;
    const apiKey = "257d8bf7"; // Reemplaza con tu clave de API de OMDb

    // Resetea el contenido previo
    document.getElementById("error").textContent = "";
    document.getElementById("movie-info").style.display = "none";

    if (!title) {
        document.getElementById("error").textContent = "Por favor ingrese un titulo.";
        return;
    }

    try {
        const response = await fetch(`https://www.omdbapi.com/?t=${encodeURIComponent(title)}&apikey=${apiKey}`);
        const data = await response.json();

        if (data.Response === "True") {
            document.getElementById("title").textContent = data.Title;
            document.getElementById("year").textContent = `Year: ${data.Year}`;
            document.getElementById("poster").src = data.Poster !== "N/A" ? data.Poster : "";
            document.getElementById("plot").textContent = data.Plot;
            document.getElementById("movie-info").style.display = "block";
        } else {
            document.getElementById("error").textContent = "Pelicula no encontrada. Por favor intente con otro titulo.";
        }
    } catch (error) {
        console.error("Error fetching data:", error);
        document.getElementById("error").textContent = "There was an error fetching the movie data. Please try again later.";
    }
}