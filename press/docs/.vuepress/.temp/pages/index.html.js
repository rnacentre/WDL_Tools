import comp from "/Users/hughes/docs/press/docs/.vuepress/.temp/pages/index.html.vue"
const data = JSON.parse("{\"path\":\"/\",\"title\":\"\",\"lang\":\"zh-CN\",\"frontmatter\":{\"pageLayout\":\"home\",\"externalLinkIcon\":false,\"config\":[{\"type\":\"hero\",\"full\":true,\"background\":\"tint-plate\",\"hero\":{\"name\":\"RiboCV\",\"tagline\":\"Ctrl + C & Ctrl + V\",\"text\":\"让复杂的工作变得只要学会复制粘贴就能上手\",\"actions\":[{\"theme\":\"brand\",\"text\":\"快速开始\",\"link\":\"./quickstart.md\"},{\"theme\":\"alt\",\"text\":\"Github →\",\"link\":\"https://github.com/rnacentre/WDL_Tools\"}]}}]},\"headers\":[],\"readingTime\":{\"minutes\":0.19,\"words\":58},\"filePathRelative\":\"README.md\",\"categoryList\":[],\"bulletin\":false}")
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
