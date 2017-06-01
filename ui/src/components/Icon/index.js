export default {
  functional: true,

  props: {
    icon: {
      type: String,
      required: true
    },
    className: {
      type: String,
      required: false
    }
  },

  render(h, { props: { icon, className } }) {
    return <i class={`${className} material-icons`}>{icon}</i>
  }
}
