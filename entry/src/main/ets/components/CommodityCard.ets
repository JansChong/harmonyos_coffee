// 每一个商品的类型约束
import { home_product_item_t } from "../model/request"

// 商品卡片自定义组件
@Component
export default struct CommodityCard {

  // 子组件接收参数
  @Prop product_data:home_product_item_t;

  build(){

    Column(){
      Image(this.product_data.smallImg)
        .margin({bottom: 20})
        .width("100%")
        // .height(160)
      Text(this.product_data.name)
        .fontSize(18)
        .maxLines(1) // 最大显示1行文本
        .textOverflow({overflow:TextOverflow.Ellipsis}) // 溢出：显示省略号
      Text(this.product_data.enname)
        .fontColor($r("app.color.unselected_font_color"))
        .margin({top:2, bottom:3})
        .maxLines(1) // 最大显示1行文本
        .textOverflow({overflow:TextOverflow.Ellipsis}) // 溢出：显示省略号
      Text("￥" + this.product_data.price)
        .fontColor("#e4393c")
    }
    .width("100%")
    .alignItems(HorizontalAlign.Start)
    .margin({bottom:10})

  }
}