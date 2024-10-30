import comp from "/Users/hughes/docs/press/docs/.vuepress/.temp/pages/en/demo/index.html.vue"
const data = JSON.parse("{\"path\":\"/en/demo/\",\"title\":\"Demo\",\"lang\":\"en-US\",\"frontmatter\":{\"title\":\"Demo\",\"createTime\":\"2024/10/30 11:12:46\",\"permalink\":\"/en/demo/\"},\"headers\":[],\"readingTime\":{\"minutes\":0.04,\"words\":13},\"filePathRelative\":\"en/notes/demo/README.md\",\"bulletin\":false}")
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
