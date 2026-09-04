// 创建一个HTTP请求，里面包括发起请求、中断请求、订阅/取消订阅HTTP Response Header事件。当发起多个HTTP请求时，需为每个HTTP请求创建对应HttpRequest对象。每一个HttpRequest对象对应一个HTTP请求。
// 当该请求使用完毕时，需调用destroy方法释放资源，否则会出现内存泄露问题。

// 导入功能模块
import { http } from '@kit.NetworkKit'

// 请求 基地址
const BASEURL:string = "https://kf.webxyq.com";
// 请求 appkey
const APPKEY:string = "U2FsdGVkX19WSQ59Cg+Fj9jNZPxRC5y0xB1iV06BeNA=";

/**
 * 封装网络请求
 * @param url 请求地址,  比如 /banner
 * @param method 请求方式 GET POST
 * @param params 请求参数
 * @returns Promise<ResponseType>
 */
let request = (url: string, method: string = "GET", params: object = Object({})): Promise<http.HttpResponse> =>{
  //  创建请求实例
  let httpRequest = http.createHttp();
  // 构建请求方式
  let type = method == "GET" ? http.RequestMethod.GET : http.RequestMethod.POST;

  // 给参数params添加一个appkey属性, 所有接口都需要
  Object(params).appkey = APPKEY;

  //  用实例发起网络请求
   return httpRequest.request(BASEURL + url, {
     // 请求方式
     method: type, // 可选，默认为http.RequestMethod.GET。
     // 请求头
     header: {
       // 本项目: post请求   参数需要序列化成: 参数1=值1&参数2=值2&参数3=值
       "Content-Type": "application/x-www-form-urlencoded"
       // 其他项目大部分
       // "Content-Type": "application/json"
     },
    //  请求参数:  当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定。
    extraData: params, // 自API version 26开始，推荐使用body字段传递请求体内容，具体格式与服务端协商确定。
     // 请求成功 返回的数据格式
    expectDataType: http.HttpDataType.OBJECT,
   })
     // 请求结束
     .finally(()=>{
       // 销毁实例
       httpRequest.destroy();
     })


   // new Promise()
   //   .then() // 请求成功
   //   .catch() // 请求失败
   //   .finally() // 请求结束



   // usingCache: true, // 可选，默认为true。
    // priority: 1, // 可选，默认为1。
    // readTimeout: 60000, // 可选，默认为60000ms。
    // connectTimeout: 60000, // 可选，默认为60000ms。
    // usingProtocol: http.HttpProtocol.HTTP1_1, // 可选，协议类型默认值由系统自动指定。
    // usingProxy: false, // 可选，默认使用系统代理，设置为false不使用代理，自API 10开始支持该属性。

}


// 导出网络请求
export default request;