import { Application } from "@hotwired/stimulus"

const application = Application.start()

// app/views/layouts/application.html.erb に csrf_meta_tags で設定されている csrf-token' の取得
window.getCsrfToken = () => {
  const metas = document.getElementsByTagName('meta');
  for (let meta of metas) {
      if (meta.getAttribute('name') === 'csrf-token') {
          console.log('csrf-token:', meta.getAttribute('content'));
          return meta.getAttribute('content');
      }
  }
    return '';
}
// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
