// 导入自定义组件
import CommodityCard from "../components/CommodityCard";

// 导入数据接口
import {
  fetchBanner, fetchHomeProductList
} from "../api/api"

// 导入数据类型
import {
  banner_t, banner_item_t, home_product_t, home_product_item_t
} from "../model/request"

// 自定义组件
@Component
  // export default  以默认导出的方式 导出组件
export default struct Home {
  // 轮播图列表数据
  @State bannerList: banner_item_t[] = [];
  // 首页商品列表
  @State productList: home_product_item_t[][] = [];

  // 生命周期函数 -- 初始化完成
  aboutToAppear(): void {
    // 获取轮播图列表
    this.getBannerList();
    // 获取商品列表
    this.getProductList();
  }

  // 页面内容
  build() {
    Column() {

      // 1.顶部导航
      Row() {
        // 1. 左侧文本
        Row() {
          Text("上午好")
            .margin({ right: 10 })

          Text("登陆")
            .margin({ right: 24 })
            .fontWeight(FontWeight.Bold)
        }

        // 2. 右侧搜索框
        Search({
          placeholder: "请输入搜索关键字"
        })
        // 占剩余空间的权重
          .layoutWeight(1)
      }
      .width("100%")
      .backgroundColor(Color.White)
      .height($r("app.float.navbar_height"))
      .padding(15)


      // 2. 滚动视图容器 （高度等于父组件高度的100%，这里要去掉顶部导航不滚动的部分的高度）
      Scroll() {
        //  Scroll支持单一子节点
        Column() {
          // 轮播图
          Swiper() {
            ForEach(this.bannerList, (item: banner_item_t, index: number) => {
              Image(item.bannerImg)
                .width("100%")
            })
          }
          .width("100%")
          .height(268.36)
          .backgroundColor($r("app.color.unselected_font_color"))
          .indicator(
            // 面板指示点静态方法
            Indicator.dot() // 返回面板指示点对象
              .selectedColor($r("app.color.theme_color"))
              .color($r("app.color.unselected_font_color"))
              .right(20)
          )

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
          .margin({ top: 10 })
          .backgroundColor(Color.White)
        }
      }
      .height("calc(100% - 50vp)")
      .scrollBar(BarState.Off) // 关闭滚动条的显示


    }
    .width("100%")
    .height("100%")
    .backgroundColor("#efefef")

  }

  // 获取轮播图列表
  private getBannerList() {
    // 调用数据接口
    fetchBanner()
      .then(res => {
        console.log("轮播图数据", JSON.stringify(res.result))
        // 把轮播图列表数据, 赋值给状态变量
        this.bannerList = Object(res.result).result;
      })
  }

  // 获取商品列表
  private getProductList() {
    fetchHomeProductList()
      .then(res => {
        //  拿到商品列表一维数组
        //  console.log("首页商品列表 =>", JSON.stringify(Object(res.result).result));

        // 临时变量: 商品列表一维数组
        let temp_arr: home_product_item_t[] = Object(res.result).result;
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