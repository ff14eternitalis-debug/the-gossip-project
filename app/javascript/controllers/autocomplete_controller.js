import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown", "selected", "hiddenInputs"]
  static values = { users: Array, preselected: Object }

  connect() {
    this.selectedUsers = []

    if (this.hasPreselectedValue && this.preselectedValue.id) {
      this.selectedUsers.push(this.preselectedValue)
      this.renderSelected()
      this.renderHiddenInputs()
    }

    this.boundClose = this.closeDropdown.bind(this)
    document.addEventListener("click", this.boundClose)
  }

  disconnect() {
    document.removeEventListener("click", this.boundClose)
  }

  search() {
    const query = this.inputTarget.value.toLowerCase().trim()

    if (query.length < 1) {
      this.dropdownTarget.classList.add("d-none")
      return
    }

    const filtered = this.usersValue.filter(user => {
      const fullName = `${user.first_name} ${user.last_name || ""}`.toLowerCase()
      const firstName = user.first_name.toLowerCase()
      return (firstName.startsWith(query) || fullName.startsWith(query)) &&
             !this.selectedUsers.find(s => s.id === user.id)
    })

    if (filtered.length === 0) {
      this.dropdownTarget.innerHTML = `<div class="autocomplete-empty">Aucun résultat</div>`
      this.dropdownTarget.classList.remove("d-none")
      return
    }

    this.dropdownTarget.innerHTML = filtered.map(user => `
      <div class="autocomplete-item" data-id="${user.id}" data-name="${user.first_name} ${user.last_name || ""}">
        ${user.first_name} ${user.last_name || ""}
      </div>
    `).join("")

    this.dropdownTarget.querySelectorAll(".autocomplete-item").forEach(item => {
      item.addEventListener("mousedown", (e) => {
        e.preventDefault()
        this.selectUser(item)
      })
    })

    this.dropdownTarget.classList.remove("d-none")
  }

  selectUser(item) {
    const id = item.dataset.id
    const name = item.dataset.name.trim()

    this.selectedUsers.push({ id, name })
    this.renderSelected()
    this.renderHiddenInputs()

    this.inputTarget.value = ""
    this.dropdownTarget.classList.add("d-none")
    this.inputTarget.focus()
  }

  removeUser(id) {
    this.selectedUsers = this.selectedUsers.filter(u => u.id !== id)
    this.renderSelected()
    this.renderHiddenInputs()
  }

  renderSelected() {
    if (this.selectedUsers.length === 0) {
      this.selectedTarget.innerHTML = ""
      return
    }

    this.selectedTarget.innerHTML = this.selectedUsers.map(user => `
      <span class="autocomplete-chip">
        ${user.name}
        <button type="button" class="autocomplete-chip-remove" data-id="${user.id}" aria-label="Retirer">×</button>
      </span>
    `).join("")

    this.selectedTarget.querySelectorAll(".autocomplete-chip-remove").forEach(btn => {
      btn.addEventListener("click", () => this.removeUser(btn.dataset.id))
    })
  }

  renderHiddenInputs() {
    this.hiddenInputsTarget.innerHTML = this.selectedUsers.map(user => `
      <input type="hidden" name="message[recipient_ids][]" value="${user.id}">
    `).join("")
  }

  closeDropdown(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.add("d-none")
    }
  }
}
