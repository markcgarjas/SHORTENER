import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["alias"]

  copy() {
    navigator.clipboard.writeText(this.aliasTarget.textContent);
    document.getElementsByClassName("notice")[0].innerText = 'copied! ' + this.aliasTarget.textContent
  }
}