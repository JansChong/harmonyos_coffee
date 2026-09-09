// 导入网络请求
import ajax from "./request";
import { http } from "@kit.NetworkKit";

import { RegistrationInfo } from "../model/other_t"

// Home页面的数据接口

// 拉取轮播图的接口
let fetchBanner = (): Promise<http.HttpResponse> => {
  // 发起网络请求
  return ajax("/banner")
}

// 拉取商品列表
let fetchHomeProductList = (): Promise<http.HttpResponse> =>{
  return ajax("/typeProducts", "GET", Object({
     key: "isHot",
     value: "1"
  }))
}

// 拉取商品分类
let fetchProductType = (): Promise<http.HttpResponse> =>{
  return ajax("/type", "GET")
}

/**
 * 通过分类拉取商品列表
 * @param value 要获取的商品的分类， 比如“latte”
 * @returns Promise<http.HttpResponse>
 */
let fetchProductListByType = (value:string):Promise<http.HttpResponse> =>{
  return ajax("/typeProducts", "GET", Object({
    key: "type",
    value
  }))
}



/** 注册账号
 * @param registrationInfo 注册信息
 * @param registrationInfo.phone 手机号码
 * @param registrationInfo.password 密码
 * @param registrationInfo.nickName 昵称
 * @returns Promise<http.HttpResponse>
 */
let registerAccount = (registrationInfo: RegistrationInfo): Promise<http.HttpResponse>  =>{
  return ajax("/register", "POST", registrationInfo)
}

// 导出数据接口
export {
  fetchBanner  // 拉取轮播图的接口
  ,fetchHomeProductList // 拉取商品列表
  ,fetchProductType // 拉取商品分类
  ,fetchProductListByType // 通过分类拉取商品列表
  ,registerAccount // 注册账号
}