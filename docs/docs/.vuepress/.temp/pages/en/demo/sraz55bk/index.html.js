import comp from "/Users/hughes/docs/press/docs/.vuepress/.temp/pages/en/demo/sraz55bk/index.html.vue"
const data = JSON.parse("{\"path\":\"/en/demo/sraz55bk/\",\"title\":\"foo\",\"lang\":\"en-US\",\"frontmatter\":{\"title\":\"foo\",\"createTime\":\"2024/10/30 11:12:46\",\"permalink\":\"/en/demo/sraz55bk/\"},\"headers\":[],\"readingTime\":{\"minutes\":0.04,\"words\":11},\"filePathRelative\":\"en/notes/demo/foo.md\",\"bulletin\":false}")
export { comp, data }

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updatePageData) {
    __VUE_HMR_RUNTIME__.updatePageData(data)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ data }) => {
    __VUE_HMR_RUNTIME__.updatePageData(data)
  })
}
