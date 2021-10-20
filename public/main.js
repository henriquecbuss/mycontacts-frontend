class ClickCatcher extends HTMLElement {
  constructor () {
    super()

    this.clickListener = (e) => { e.stopPropagation() }
    this.addEventListener('click', this.clickListener)
  }

  disconnectedCallback () {
    this.removeEventListener('click', this.clickListener)
  }
}

customElements.define('click-catcher', ClickCatcher)

const app = Elm.Main.init()
