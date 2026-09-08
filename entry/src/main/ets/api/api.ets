// 导入网络请求
import ajax from "./request";
import { http } from "@kit.NetworkKit";


// Home页面的数据接口

// 拉取轮播图的接口
let fetchBanner = (): Promise<http.HttpResponse>=> {
  // 发起网络请求
  return ajax("/banner")
}

// 拉取商品列表
let fetchHomeProductList = (): Promise<http.HttpResponse>=>{
  return ajax("/typeProducts", "GET", Object({
     key: "isHot",
     value: "1"
  }))
}


// 拉取商品分类
let fetchProductType = (): Promise<http.HttpResponse>=>{
  return ajax("/type", "GET")
}

/**
 * 通过分类拉取商品列表
 * @param value 要获取的商品的分类， 比如“latte”
 * @returns Promise<http.HttpResponse>
 */
let fetchProductListByType = (value:string):Promise<http.HttpResponse>=>{
  return ajax("/typeProducts", "GET", Object({
    key: "type",
    value
  }))
}


// 导出数据接口
export {
  fetchBanner  // 拉取轮播图的接口
  ,fetchHomeProductList // 拉取商品列表
  ,fetchProductType // 拉取商品分类
  ,fetchProductListByType // 通过分类拉取商品列表
}