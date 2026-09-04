// 导入自定义组件
import Home from "../views/Home"
import MenuPage from "../views/Menu"
import ShopBag from "../views/ShopBag"
import My from "../views/My"

// 每一个tabBar的类型约束
interface tabBarItem_t {
    title: string,  // 标题
    img: Resource,  // 默认图片
    imgActive: Resource // 选中图片
}

@Entry
@Component
struct Index {
  // Struct 到 build 之间, 可以定义变量、声明函数、调用生命周期

  // 底部按钮需要使用的数据
  tabBarData: Array<tabBarItem_t> = [
    {
      title: "首页",
      img: $r("app.media.home"),
      imgActive: $r("app.media.home_active")
    },
    {
      title: "菜单",
      img: $r("app.media.menu"),
      imgActive: $r("app.media.menu_active")
    },
    {
      title: "购物袋",
      img: $r("app.media.shopbag"),
      imgActive: $r("app.media.shopbag_active")
    },
    {
      title: "我的",
      img: $r("app.media.my"),
      imgActive: $r("app.media.my_active")
    }
  ];

  // @State 定义状态变量: 数据变化会驱动视图更新
  @State selectedIndex:number = 0; // 当前点击的页签的索引

  /**
   * 局部 自定义构建函数
   * @param desc 用于构建图片和标题的 tabBarData数组项
   * @param idx  当前数组项的下标, 用于匹配 selectedIndex 实现图标高亮
   */
  @Builder
  customTabBar( desc: tabBarItem_t, idx:number ){
      // 列  内容垂直排列
      Column(){
        // 图标
        Image( this.selectedIndex == idx ? desc.imgActive: desc.img)
          .width(25)
          .margin({bottom: 2})

        // 文字
        Text(desc.title)
          .fontSize(14)
          .fontColor(this.selectedIndex == idx ? $r("app.color.theme_color") : $r("app.color.unselected_font_color"))
      }
  }

  // 写页面内容
  build() {

      // 通过页签切换内容
      Tabs({
          // 页签所在的位置
          barPosition: BarPosition.End,
          // 当前显示的页面的索引
          index: 0
      }){
        // 根据数组长度 生成内容, 语法: ForEach(数组, (数组项, 下标)=>{ } )
        ForEach(this.tabBarData, (item: tabBarItem_t, index: number) => {
            // 不同页签对应的 页面内容
            TabContent(){
              // 支持单个子组件。
              if (index == 0) Home() // 首页
              else if(index == 1) MenuPage() // 菜单
              else if(index == 2) ShopBag() // 购物袋
              else My() // 我的
            }

            // 第一种: 通过 string 实现 tabbar
            // .tabBar(item.title)

            // 第二种: 通过 tabBarOption 实现 tabbar
            // .tabBar({
            //   icon: this.selectedIndex == index ? item.imgActive : item.img,
            //   text: item.title
            // })

            // 第三种: 通过 自定义构建函数 实现 tabbar
            // 页签上显示的内容: tabBar
            // .tabBar( this.customTabBar(item, index) )

            // 第四种: 通过 new BottomTabBarStyle 实现tabBar
            .tabBar( new BottomTabBarStyle(
              this.selectedIndex == index ? item.imgActive : item.img, // 第一个参数 icon
              item.title, // 第一个参数 icon
            ).labelStyle({
              selectedColor: $r("app.color.theme_color"),
              unselectedColor: $r("app.color.unselected_font_color")
            }) )


        })
      }
      // .barPosition(BarPosition.End)
      // tabs 页签 发生改变时, 触发 onchange 方法
      .onChange((event)=>{
        console.log("当前显示的页签的索引:", event);
        // 把索引赋值给状态变量
        this.selectedIndex = event;
      })
  }
}