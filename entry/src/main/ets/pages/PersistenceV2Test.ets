// @ObservedV2装饰器与@Trace装饰器用于装饰类以及类中的属性，使得被装饰的类和属性具有深度观测的能力:
// 需要配合使用，单独使用没有任何作用。
// 被@Trace属性property变化时，仅会通知property关联的组件进行刷新。
// 在嵌套类中，嵌套类中的属性property被@Trace装饰且嵌套类被@ObservedV2装饰时，才具有触发UI刷新的能力。
// 在继承类中，父类或子类中的属性property被@Trace装饰且该property所在类被@ObservedV2装饰时，才具有触发UI刷新的能力。
// 未被@Trace装饰的属性用在UI中无法感知到变化，也无法触发UI刷新。
// 使用@ObservedV2与@Trace装饰器的类，需通过new操作符实例化后，才具备被观测变化的能力。


// static globalConnect<T extends object>(type: ConnectOptions<T>): T | undefined
// 将键值对数据存储在应用磁盘中。如果给定的key已经存在于PersistenceV2中，返回对应的值；否则，会通过获取默认值的构造器构造默认值，并返回。如果通过globalConnect连接的对象是@ObservedV2对象，该对象@Trace属性的变化，会触发整个关联对象的自动刷新；非@Trace属性变化则不会自动持久化，如需持久化非@Trace属性的变化，可调用PersistenceV2.save接口手动存储。




import { PersistenceV2, Type, ConnectOptions } from '@kit.ArkUI';
import { contextConstant } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
// 接受序列化失败的回调
PersistenceV2.notifyOnError((key: string, reason: string, msg: string) => {
  hilog.error(DOMAIN, 'testTag', '%{public}s', `error key: ${key}, reason: ${reason}, message: ${msg}`);
});

@ObservedV2
class SampleChild {
  @Trace public childId: number = 0;
  public groupId: number = 1;
}

@ObservedV2
export class SampleGlobalConnect {
  // 对于复杂对象需要@Type修饰，确保序列化成功
  @Type(SampleChild)
  @Trace public father: SampleChild = new SampleChild();
  // @Trace public father: SampleChild = new SampleChild();
  // @Trace public father: SampleChild = new SampleChild();
}

@Entry
@ComponentV2
struct Page1 {
  @Local refresh: number = 0;
  // key不传入尝试用为type的name作为key，加密参数不传入默认加密等级为EL2
  @Local p: SampleGlobalConnect =
    PersistenceV2.globalConnect({ type: SampleGlobalConnect, defaultCreator: () => new SampleGlobalConnect() })!;
  // // 使用key:global1连接，传入加密等级为EL1
  // @Local p1: SampleGlobalConnect = PersistenceV2.globalConnect({
  //   type: SampleGlobalConnect,
  //   key: 'global1',
  //   defaultCreator: () => new SampleGlobalConnect(),
  //   areaMode: contextConstant.AreaMode.EL1
  // })!;
  // // 使用key:global2连接，使用构造函数形式，加密参数不传入默认加密等级为EL2
  // options: ConnectOptions<SampleGlobalConnect> =
  //   { type: SampleGlobalConnect, key: 'global2', defaultCreator: () => new SampleGlobalConnect() };
  // @Local p2: SampleGlobalConnect = PersistenceV2.globalConnect(this.options)!;
  // // 使用key:global3连接，直接写加密数值，范围只能在0-4，否则运行会crash,例如加密设置为EL3
  // @Local p3: SampleGlobalConnect = PersistenceV2.globalConnect({
  //   type: SampleGlobalConnect,
  //   key: 'global3',
  //   defaultCreator: () => new SampleGlobalConnect(),
  //   areaMode: 3
  // })!;

  build() {
    Column() {
      // 显示数据
      // 被@Trace修饰的数据可以自动持久化进磁盘
      Text('Key 全局连接示例childId: ' + this.p.father.childId.toString())
        .onClick(() => {
          this.p.father.childId += 1;
        })
        .fontSize(25)
        .margin(5)
        .fontColor(Color.Red)

      Text('Key 全局连接示例groupId: ' + this.p.father.groupId.toString())
        .onClick(() => {
          this.p.father.groupId += 1;
        })
        .fontSize(25)
        .margin(5)
        .fontColor(Color.Red)


      // Text('Key global1: ' + this.p1.father.childId.toString())
      //   .onClick(() => {
      //     this.p1.father.childId += 1;
      //   })
      //   .fontSize(25)
      //   .margin(5)
      //   .fontColor(Color.Red)
      // Text('Key global2: ' + this.p2.father.childId.toString())
      //   .onClick(() => {
      //     this.p2.father.childId += 1;
      //   })
      //   .fontSize(25)
      //   .margin(5)
      //   .fontColor(Color.Red)
      // Text('Key global3: ' + this.p3.father.childId.toString())
      //   .onClick(() => {
      //     this.p3.father.childId += 1;
      //   })
      //   .fontSize(25)
      //   .margin(5)
      //   .fontColor(Color.Red)
      // keys接口
      // keys本身不会刷新，需要借助状态变量刷新
      Text('持久化 keys: ' + PersistenceV2.keys().toString() + ' 刷新: ' + this.refresh)
        .onClick(() => {
          this.refresh += 1;
        })
        .fontSize(25)
        .margin(5)

      // remove接口
      Text('Remove key 移除全局连接示例: ' + ' 刷新: ' + this.refresh)
        .onClick(() => {
          // 删除这个key，会导致和p失去联系，之后即使reconnect，p也无法存储
          PersistenceV2.remove(SampleGlobalConnect);
          this.refresh += 1;
        })
        .fontSize(25)
        .margin(5)

      // Text('Remove key global1: ' + 'refresh: ' + this.refresh)
      //   .onClick(() => {
      //     // 删除这个key，会导致和p1失去联系，之后即使reconnect，p1也无法存储
      //     PersistenceV2.remove('global1');
      //     this.refresh += 1;
      //   })
      //   .fontSize(25)
      //   .margin(5)
      // Text('Remove key global2: ' + 'refresh: ' + this.refresh)
      //   .onClick(() => {
      //     // 删除这个key，会导致和p2失去联系，之后即使reconnect，p2也无法存储
      //     PersistenceV2.remove('global2');
      //     this.refresh += 1;
      //   })
      //   .fontSize(25)
      //   .margin(5)
      // Text('Remove key global3: ' + 'refresh: ' + this.refresh)
      //   .onClick(() => {
      //     // 删除这个key，会导致和p3失去联系，之后即使reconnect，p3也无法存储
      //     PersistenceV2.remove('global3');
      //     this.refresh += 1;
      //   })
      //   .fontSize(25)
      //   .margin(5)

      // reConnect
      // 重新连接也无法和之前的状态变量建立联系，因此无法保存数据
      // Text('ReConnect key global2: ' + 'refresh: ' + this.refresh)
      //   .onClick(() => {
      //     // 此时会重新存储一个key为global2的变量，但该变量与p2无关
      //     PersistenceV2.globalConnect(this.options);
      //     this.refresh += 1;
      //   })
      //   .fontSize(25)
      //   .margin(5)

      // save接口
      Text('not save key 全局连接示例: ' + this.p.father.groupId.toString() + ' refresh: ' + this.refresh)
        .onClick(() => {
          // 未被@Trace保存的对象无法自动存储
          this.p.father.groupId += 1;
          this.refresh += 1;
        })
        .fontSize(25)
        .margin(5)

      Text('save key 全局连接示例: ' + this.p.father.groupId.toString() + ' refresh: ' + this.refresh)
        .onClick(() => {
          // 未被@Trace保存的对象无法自动存储，需要调用save存储
          this.p.father.groupId += 1;
          PersistenceV2.save(SampleGlobalConnect);
          this.refresh += 1;
        })
        .fontSize(25)
        .margin(5)
    }
    .width('100%')
  }
}