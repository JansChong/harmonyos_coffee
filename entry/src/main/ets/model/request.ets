
// 轮播图的数据类型约束
export interface banner_t {
    code: number;
    result: banner_item_t[];
}

export interface banner_item_t {
    bannerImg: string;
    name: string;
    pid: string;
}


// 首页商品列表类型约束
export interface home_product_t {
    code: number;
    result: home_product_item_t[];
}

export interface home_product_item_t {
    createdAt: string;
    desc: string;
    enname: string;
    id: number;
    isHot: number;
    largeImg: string;
    name: string;
    pid: string;
    price: string;
    smallImg: string;
    type: string;
    typeDesc: string;
    updatedAt: string;
}