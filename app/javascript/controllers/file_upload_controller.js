import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fileInput", "results", "spinner"]

  async submitForm(event) {
    event.preventDefault();
    this.clearResults();
    this.showSpinner();

    const fileInput = this.fileInputTarget;
    const file = fileInput.files[0];

    if (!file) {
      this.displayError("Please select a file to upload.");
      this.hideSpinner();
      return;
    }

    const formData = new FormData();
    formData.append("file", file);

    try {
      const response = await fetch("/upload_users", {
        method: "POST",
        headers: { "X-CSRF-Token": document.head.querySelector("meta[name=csrf-token]")?.content },
        body: formData
      });
      this.hideSpinner();
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

  clearResults() {
    this.resultsTarget.innerHTML = "";
  }

  showSpinner() {
    this.spinnerTarget.style.display = "block";
  }

  hideSpinner() {
    this.spinnerTarget.style.display = "none";
  }

  updateResults(results) {
    this.clearResults();

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
