import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fileInput", "results"]

  async submitForm(event) {
    event.preventDefault();

    const fileInput = this.fileInputTarget;
    const file = fileInput.files[0];

    if (!file) {
      this.displayError("Please select a file to upload.");
      return;
    }

    const formData = new FormData();
    formData.append("file", file);

    try {
      const response = await fetch("/upload_users", {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.head.querySelector("meta[name=csrf-token]")?.content
        },
        body: formData
      });

      // Handle the response as JSON
      if (response.ok) {
        const data = await response.json();
        this.updateResults(data.results);
      } else {
        this.displayError("There was a problem with the server response.");
      }
    } catch (error) {
      console.error("Error uploading file:", error);
    }
  }

  updateResults(results) {
    this.resultsTarget.innerHTML = ""; // Clear previous results

    results.forEach(result => {
      const listItem = document.createElement("li");
      listItem.textContent = `${result.name || "Error"} - ${result.result}`;
      this.resultsTarget.appendChild(listItem);
    });
  }

  displayError(message) {
    this.resultsTarget.innerHTML = `<li class="error">${message}</li>`;
  }
}
