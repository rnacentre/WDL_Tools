import { defineNavbarConfig } from 'vuepress-theme-plume'

export const zhNavbar = defineNavbarConfig([
  { text: '首页', link: '/' },
  {
    text: '文档目录',
    items: [{ text: '示例', link: '/notes/demo/README.md' }]
  },
])

export const enNavbar = defineNavbarConfig([
  { text: 'Home', link: '/en/' },
  {
    text: 'Docs Directory',
    items: [{ text: 'Demo', link: '/en/notes/demo/README.md' }]
  },
])

