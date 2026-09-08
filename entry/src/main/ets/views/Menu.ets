// 导入数据接口
import { fetchProductType,fetchProductListByType } from "../api/api";

// 导入自定义组件
import CommodityCard from "../components/CommodityCard";

// 导入类型约束
import {
  side_menu_t, side_menu_item_t,
  home_product_item_t, home_product_t
} from "../model/request"


  // 自定义组件 -- MenuPage
@Component
  // export default  以默认导出的方式 导出组件
export default struct MenuPage {
  // 侧边栏列表
  @State side_menu_list: side_menu_item_t[] = [];
  // 侧边栏当前激活的下标
  @State select_side_idx:number = 0;
  // 右侧商品列表
  @State productList: home_product_item_t[][] = [];

  // 生命周期函数 -- 页面初始化完成
  async aboutToAppear() {
    // 获取商品类型 -- 返回第一个分类的商品类型
    let type:string = await this.getProductType();
    // 拿到第一个类型的商品
    this.getProductListByType(type);
  }

  build() {
    Column() {

      // 1. 顶部搜索栏
      Search({ placeholder: "请输入搜索关键字" })
        .margin({ left: 20, right: 20, bottom: 10 })

      // 2. 页面内容
      Row() {
        // 侧边栏
        Column() {

          ForEach(this.side_menu_list, (item: side_menu_item_t, index: number) => {
            Row() {
              Text(item.typeDesc)
                .padding({ left: 20, top: 16, bottom: 16 })
                .border({
                  width: { left: 2 },
                  style: BorderStyle.Solid,
                  color: this.select_side_idx == index ? $r("app.color.theme_color") : Color.Transparent
                })
            }.width("100%").padding({ top: 10, bottom: 10 })
            .background(this.select_side_idx == index ? Color.White: Color.Transparent)
            .onClick(()=>{
                // 如果点击的是已经选中的
                if(index == this.select_side_idx) return;
                // 当前点击的侧边栏的下标， 赋值给状态变量
                this.select_side_idx = index;

                // 通过当前的分类调用方法
                this.getProductListByType(item.type)

            })
          })

        }
        .width("35%")
        .height("calc(100% - 50vp)")
        .alignItems(HorizontalAlign.Start)
        .backgroundColor("#f7f8fa")

        // 侧边栏对应的商品
        Row() {
          Scroll(){
            // 商品列表
            Row({ space: 10 }) {
              // 长度为2的二维数组
              ForEach(this.productList, (child_arr: home_product_item_t[], index) => {
                // 商品列表
                Column() {
                  // 遍历这一列商品
                  ForEach(child_arr, (item: home_product_item_t, index) => {
                    // 父组件传递参数product_data给子组件
                    CommodityCard({ product_data: item }) // 商品卡片 -- 自定义组件
                  })
                }
                .width("calc(50% - 5vp)")
              })
            }
            .alignItems(VerticalAlign.Top)
            .padding(10)
            .backgroundColor(Color.White)
          }
        }
        .width("65%")
        .margin({bottom: 50})
      }
      .alignItems(VerticalAlign.Top)

    }

  }

  // 获取商品类型
  private async getProductType() {
    let type:string = "";  // 第0个分类的类型

    await fetchProductType()
      .then(res => {
        console.log("获取到商品分类 =>", JSON.stringify(res.result))
        // 服务器返回的值
        let temp: side_menu_t = res.result as side_menu_t;
        // 获取到侧边栏列表
        this.side_menu_list = temp.result;
        // 获取到第0个分类的类型
        type = temp.result[0].type;
      })

    return type; // 第0个分类的类型
  }

  /**
   * 通过分类获取商品列表
   * @param _type 商品分类，比如 "latte"
   */
  private getProductListByType(_type:string){
    // 右侧商品初始化
    this.productList = [];

    fetchProductListByType(_type)
      .then(res=>{
        // 获取到接口数据
        let temp:home_product_t = res.result as home_product_t;
        // 临时变量: 商品列表一维数组
        let temp_arr: home_product_item_t[] = temp.result;
        let temp_len: number = temp_arr.length;
        // 遍历数组, 把一维数组展开成二维数组
        for (let i = 0; i < temp_len; i++) {
          // 取n的余数,就是把一维数组分成n列数据(n个子数组)
          // 商品列表二维数组初始化 => 如果当前子数组没有初始化
          if (this.productList[i % 2] == undefined) {
            // 把子数组初始化成空数组
            this.productList[i % 2] = [];
          }
          // push() 往数组尾部插入元素
          this.productList[i % 2].push(temp_arr[i]);
        }
        console.log("首页商品列表 =>", JSON.stringify(this.productList));
      })
  }
}