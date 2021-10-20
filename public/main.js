class ModalContainer extends HTMLElement {
  constructor () {
    super()

    this.escListener = (e) => {
      console.log(e)
      if (e.key === 'Escape') {
        this.dispatchEvent(new Event('esc'))
      }
    }

    document.addEventListener('keydown', this.escListener)
    this.clickListener = (e) => { e.stopPropagation() }
    this.addEventListener('click', this.clickListener)
  }

  disconnectedCallback () {
    document.removeEventListener('keydown', this.escListener)
    this.removeEventListener('click', this.clickListener)
  }
}

customElements.define('modal-container', ModalContainer)

const app = Elm.Main.init()
