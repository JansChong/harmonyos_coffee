// 手机号正则：中国大陆手机号 1[3-9] 后接 9 位数字
const phoneRegex: RegExp = /^1[3-9]\d{9}$/;

// 校验手机号
export function validatePhone(phone: string): boolean {
  return phoneRegex.test(phone);
}

// 校验密码：需同时包含字母、数字、其他符号三种，且长度大于等于 6
export function validatePassword(pwd: string): boolean {
  // 密码长度 大于等于6
  if (pwd.length < 6) {
    return false;
  }

  let hasLetter = /[a-zA-Z]/.test(pwd);  // 需要包含一个字母
  let hasDigit = /\d/.test(pwd);  // 需要包含一个数字
  let hasSymbol = /[^a-zA-Z0-9\s]/.test(pwd); // 需要一个 除 字母数字空格符号 之外的任意符号

  let typeCount: number = 0;
  if (hasLetter) typeCount++;
  if (hasDigit) typeCount++;
  if (hasSymbol) typeCount++;
  return typeCount >= 3;
}