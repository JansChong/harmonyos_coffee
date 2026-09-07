@Entry
  // 自定义组件 -- MenuPage
@Component
  // export default  以默认导出的方式 导出组件
export default struct MenuPage {
  build() {
    Column() {

      // 1. 顶部搜索栏
      Search({ placeholder: "请输入搜索关键字" })
        .margin({ left: 20, right: 20, bottom: 10 })

      // 2. 页面内容
      Row() {
        // 侧边栏
        Column() {
          Row() {
            Text("热卖推荐")
              .padding({ left: 20, top: 16, bottom: 16 })
              .border({
                width: { left: 2 },
                style: BorderStyle.Solid,
                color: $r("app.color.theme_color")
              })
          }
          .width("100%")
          .padding({ top: 10, bottom: 10 })
          .background(Color.White)
        }
        .width("35%")
        .height("calc(100% - 50vp)")
        .alignItems(HorizontalAlign.Start)
        .backgroundColor("#f7f8fa")

        // 侧边栏对应的商品
        Row() {
        }
        .width("65%")
        .height("calc(100% - 50vp)")
        .backgroundColor("#0000ea")
      }

    }

  }
}