// 导入参数类型约束
import { input_field_t, RegistrationInfo } from "../model/other_t"

// 弹窗
import { promptAction } from '@kit.ArkUI';

// 导入注册接口
import { registerAccount } from "../api/api";

import { validateNickName, validatePassword, validatePhone } from "../utils/validForm";

@Entry
@Component
struct LoginPage {
  @State isShowSheet: boolean = false; // 是否显示半模态框
  @State phoneNumber: string = ''; // 手机号
  @State password: string = ''; // 密码
  @State nickName: string = ''; // 昵称
  @State isPasswordVisible: boolean = false; // 密码是否可见
  @State phoneError: string = ''; // 手机错误提示
  @State passwordError: string = ''; // 密码错误提示
  @State nickNameError: string = ''; // 昵称错误提示
  @State isPhoneValid: boolean = true; // 手机号是否通过验证
  @State isPasswordValid: boolean = true; // 密码是否通过验证
  @State isNickNameValid: boolean = true; // 昵称是否通过验证
  @State hasValidated: boolean = false; // 是否需要验证表单
  phoneErrMsg: string = "请输入正确的 11 位手机号";
  passwordErrMsg: string = "密码需含字母、数字、符号三种且长度大于 6 位";
  nickNameErrMsg: string = "昵称至少有两个字符，不可以有空白字符";

  // 点击登录：触发校验
  private onLogin(): void {
    console.log(`登录：：
    手机号码 = ${this.phoneNumber}
    密码 = ${this.password}
    昵称 = ${this.nickName}`)

    this.hasValidated = true; // 需要表单验证  -- 给输入框的onChange使用的

    // 点击登录按钮再验证一次
    this.isPhoneValid = validatePhone(this.phoneNumber);
    this.isPasswordValid = validatePassword(this.password);
    this.phoneError = this.isPhoneValid ? '' : this.phoneErrMsg;
    this.passwordError = this.isPasswordValid ? '' : this.passwordErrMsg;

    // 如果手机号和密码验证通过
    if (this.isPhoneValid && this.isPasswordValid) {
      // 显示Dialog
      AlertDialog.show({
        title: '登录',
        message: '校验通过，执行登录请求',
        confirm: {
          value: '确定',
          action: () => {
          }
        }
      });
    }
  }

  // 点击模态框注册按钮: 触发校验
  private onRegister(): void {
    // console.log(`注册：：
    // 手机号码 = ${this.phoneNumber}
    // 密码 = ${this.password}
    // 昵称 = ${this.nickName}`)

    this.hasValidated = true; // 需要表单验证  -- 给输入框的onChange使用的

    // 点击注册按钮验证一次
    this.isPhoneValid = validatePhone(this.phoneNumber);
    this.isPasswordValid = validatePassword(this.password);
    this.isNickNameValid = validateNickName(this.nickName);
    this.phoneError = this.isPhoneValid ? '' : this.phoneErrMsg;
    this.passwordError = this.isPasswordValid ? '' : this.passwordErrMsg;
    this.nickNameError = this.isNickNameValid ? '' : this.nickNameErrMsg;

    // 如果手机号、密码和昵称验证通过
    if (this.isPhoneValid && this.isPasswordValid && this.isNickNameValid) {
      // 构建注册参数
      let registrationInfo: RegistrationInfo = {
        phone: this.phoneNumber,
        password: this.password,
        nickName: this.nickName
      }

      // 调用注册接口
       registerAccount(registrationInfo)
         .then(res=>{
           console.log("注册结果 =>", JSON.stringify(res.result));

           // 显示注册信息  "注册成功"  "手机号已被注册"
           promptAction.openToast({
             message: Object(res.result).msg,
             bottom: "40%"
           })

           // 注册成功 或者 已经注册
           if(Object(res.result).code == 100 ){
             // 数据初始化 -- 避免半模态页面的表单验证结果 传递到 外面
             this.hasValidated = false;
             this.phoneError = "";
             this.passwordError = "";
             this.nickNameError = "";

             // 输入框输入的数据 也要初始化 （避免后续 输入框显示空值，但实际有值）
             this.password = "";
             this.nickName = "";

             //关闭半模态页面
             this.isShowSheet = false;
           }
         })
    }

  }

  build() {
    Column() {
      // 顶部导航栏：Logo（粉色盒子）+ 首页
      this.TopBar();

      // 欢迎标题
      this.WelcomeHeader();

      // 表单区域
      this.FormArea();

      // 弹性占位，将按钮推到底部
      Blank();

      // 底部按钮
      this.BottomButtons();
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF');
  }

  // ================= 自定义构建函数（可复用） =================

  // 顶部导航栏
  @Builder
  TopBar() {
    Row() {
      Row() {
        // 粉色纯色盒子替代 Logo 图片
        Image($r("app.media.home_active"))
          .width(32)
          .height(32)
          .borderRadius(16);

        Text('Luckin Coffee')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ left: 8 });
      }

      Blank();

      Text('首页')
        .fontSize(14)
        .fontColor($r("app.color.theme_color"))
        .onClick(() => {
          // 返回首页
        });
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .padding({
      left: 20,
      right: 20,
      top: 16,
      bottom: 16
    })
    .margin({ bottom: 60 });
  }

  // 欢迎标题
  @Builder
  WelcomeHeader() {
    Column() {
      Text('欢迎回来！')
        .fontSize(32)
        .fontColor('#534944');

      Text('Please login to your accounts')
        .fontSize(18)
        .fontColor('#999999')
        .margin({ top: 8 });
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding({
      left: 20,
      right: 20,
      top: 32,
      bottom: 32
    })
    .margin({ bottom: 30 });
  }

  // 表单区域
  @Builder
  FormArea() {
    Column() {
      // 手机号输入框（复用自定义构建函数）
      this.InputField({
        label: '手机号',
        placeholder: '手机号',
        text: this.phoneNumber,
        type: InputType.PhoneNumber,
        isValid: this.isPhoneValid,
        error: this.phoneError,
        onChange: (value: string) => {
          this.phoneNumber = value;
          if (this.hasValidated) {
            this.isPhoneValid = validatePhone(value);
            this.phoneError = this.isPhoneValid ? '' : this.phoneErrMsg;
          }
        }
      });

      // 密码输入框（复用自定义构建函数，带显隐切换）
      this.InputField({
        label: '密码',
        placeholder: '密码',
        text: this.password,
        type: InputType.Password,
        isValid: this.isPasswordValid,
        error: this.passwordError,
        onChange: (value: string) => {
          this.password = value;
          if (this.hasValidated) {
            this.isPasswordValid = validatePassword(value);
            this.passwordError = this.isPasswordValid ? '' : this.passwordErrMsg;
          }
        }

      });

      // 忘记密码
      Row() {
        Blank();
        Text('忘记密码？')
          .fontSize(13)
          .fontColor('#999999')
          .onClick(() => {
            // 跳转找回密码
          });
      }
      .width('100%')
      .margin({ top: 12 });
    }
    .width('100%')
    .padding({ left: 20, right: 20 });
  }

  // 可复用输入框构建函数（手机号 / 密码 / 昵称 通用）
  @Builder
  InputField(params: input_field_t) {
    Column() {
      // 标签 + 输入框 + 显隐图标 同一行
      Row() {
        // 标签
        Text(params.label)
          .fontSize(16)
          .fontColor('#333333')
          .width(56)
          .margin({ right: 40 });

        // 输入框（无边框）
        TextInput({ placeholder: params.placeholder, text: params.text })
          .layoutWeight(1)
          .height(48)
          .type(params.type)
          .fontSize(14)
          .fontColor('#333333')
          .borderRadius(0)
          .padding({ left: 4, right: 4 })
          .backgroundColor(Color.Transparent)
          .placeholderColor($r("app.color.unselected_font_color"))
          .onChange((value: string) => {
            params.onChange(value);
          });
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      // 浅色底部边框
      .border({ width: { bottom: 1 }, color: { bottom: '#E5E5E5' } })
      .padding({ bottom: 4 });

      // 错误提示
      if (!params.isValid && params.error.length > 0) {
        Text(params.error)
          .fontSize(12)
          .fontColor('#FF4D4F')
          .margin({ top: 4 });
      }
    }
    .alignItems(HorizontalAlign.Start)
    .margin({ bottom: 16 });
  }

  // 底部按钮
  @Builder
  BottomButtons() {
    Column() {
      // 登录按钮（主按钮）
      Button('登录')
        .width('100%')
        .height(48)
        .backgroundColor('#0052D9')
        .fontColor('#FFFFFF')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .borderRadius(24)
        .margin({ bottom: 50 })
        .onClick(() => {
          this.onLogin();
        });

      // 注册按钮（次按钮）
      Button('注册')
        .width('100%')
        .height(48)
        .backgroundColor('#FFFFFF')
        .fontColor('#333333')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .borderRadius(24)
        .border({ width: 1, color: '#E5E5E5' })
        .margin({ top: 12 })
        .onClick(() => {
          // 初始化变量  --  避免外面的表单验证结果 传递到 半模态页面
          this.hasValidated = false;
          this.phoneError = "";
          this.passwordError = "";

          // 输入框输入的数据 也要初始化 （避免后续 输入框显示空值，但实际有值）
          this.password = "";

          // 显示半模态页面
          this.isShowSheet = true;
        })
        // .绑定半模态页面(是否显示， 自定义构建函数,  其他配置)
        .bindSheet($$this.isShowSheet, this.SheetBuilder(), {
          showClose: false,
          height: "65%",
          // 二次确认监听
          onWillDismiss: (sheetAction: DismissSheetAction)=>{
            // 数据初始化 -- 避免半模态页面的表单验证结果 传递到 外面
            this.hasValidated = false;
            this.phoneError = "";
            this.passwordError = "";
            this.nickNameError = "";

            // 输入框输入的数据 也要初始化 （避免后续 输入框显示空值，但实际有值）
            this.password = "";
            this.nickName = "";

            // sheetAction.reason // 获取关闭模态框的方式
            sheetAction.dismiss(); // 关闭模态框
          }
        })

    }
    .width('100%')
    .padding({ left: 20, right: 20, bottom: 32 });
  }

  // 半模态转场
  @Builder
  SheetBuilder() {
    Column() {

      // 顶部标题
      Row() {
        Text("注册").fontSize(30)
        Text("X")
          .fontSize(20)
          .fontColor($r("app.color.unselected_font_color"))
          .onClick(()=>{
            // 数据初始化 -- 避免半模态页面的表单验证结果 传递到 外面
            this.hasValidated = false;
            this.phoneError = "";
            this.passwordError = "";
            this.nickNameError = "";

            // 输入框输入的数据 也要初始化 （避免后续 输入框显示空值，但实际有值）
            this.password = "";
            this.nickName = "";


            //关闭半模态页面
            this.isShowSheet = false;
          })
      }
      .width("100%")
      .margin({ bottom: 40 })
      .justifyContent(FlexAlign.SpaceBetween)


      // 中间表单
      Column() {
        // 手机号码输入框
        this.InputField({
          label: "手机号",
          placeholder: "手机号",
          text: this.phoneNumber,
          type: InputType.PhoneNumber,
          isValid: this.isPhoneValid,
          error: this.phoneError,
          onChange: (value: string) => {
            this.phoneNumber = value;
            if (this.hasValidated) {
              this.isPhoneValid = validatePhone(value);
              this.phoneError = this.isPhoneValid ? '' : '请输入正确的 11 位手机号';
            }
          }
        })
        // 密码输入框（复用自定义构建函数，带显隐切换）
        this.InputField({
          label: '密码',
          placeholder: '密码',
          type: InputType.Password,
          isValid: this.isPasswordValid,
          error: this.passwordError,
          onChange: (value: string) => {
            this.password = value;
            if (this.hasValidated) {
              this.isPasswordValid = validatePassword(value);
              this.passwordError = this.isPasswordValid ? '' : this.passwordErrMsg;
            }
          }

        });
        // 昵称输入框
        this.InputField({
          label: "昵称",
          placeholder: "请输入昵称",
          type: InputType.Normal,
          isValid: this.isNickNameValid,
          error: this.nickNameError,
          onChange: (value: string) => {
            // 昵称输入框的值，赋予状态变量
            this.nickName = value;
            // 如果点击注册以后， 验证不通过， 每一次输入都会进行昵称验证
            if (this.hasValidated) {
              this.isNickNameValid = validateNickName(value);
              this.nickNameError = this.isNickNameValid ? "" : this.nickNameErrMsg
            }
          }
        })

      }
      .padding({
        left: 15,
        right: 15,
        bottom: 35
      })


      // 底部注册按钮
      Button('注册')
        .width('100%')
        .height(48)
        .backgroundColor('#0052D9')
        .fontColor('#FFFFFF')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .borderRadius(24)
        .margin({ bottom: 10 })
        .onClick(() => {
          // TODO... 真正的注册函数
          this.onRegister();
        });


    }.padding(20)
  }
}
