import { Controller } from "stimulus"
console.log('import')
export default class extends Controller {
  static targets = []

  scan() {
    console.log('js here')
    $.ajax({
      url: "/shows",
      type: "post",
      dataType: "json",
      contentType: 'application/json',
      success: function(data) {
      },
      error: function(data) {}
    })
  }
}