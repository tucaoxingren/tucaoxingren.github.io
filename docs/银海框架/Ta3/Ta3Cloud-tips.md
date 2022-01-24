## Ta3 4.0.1 组件问题记录

### issue

#### onChange
`onChange` 触发条件为键盘输入后失去焦点时触发

若想点击月份后触发 可以使用`onBlur`失去焦点触发 例如
```html
<body>
<ta:fieldset cols="3">
    <ta:issue id="aae002" key="期号" onBlur="fnAae002Blur()"/>
</ta:fieldset>
</body>
<script type="text/javascript">
    $(document).ready(function () {
        $("body").taLayout();
        aae002Cur = Base.getValue('aae002');
    });
    // 存储期号值 全局变量
    var aae002Cur;

    function fnAae002Blur() {
        // console.log('失去焦点');
        var aae002 = Base.getValue('aae002');
        if (aae002Cur !== aae002) {
            aae002Cur = aae002;
            //TODO something
        }
    }
</script>
```

## 获取服务器绝对路径
### JS
`Base.globvar.basePath`
### 页面中
`${basePath}`

## Exception
`PrcException`引入路径为`com.yinhai.sisp3.his.common.exception.PrcException`，引入其它`PrcException`无法捕获

## ExcelFileUtils工具类
只可以处理xls格式，不能处理xlsx格式

## 关闭新打开的窗口
```html
<ta:button id="btnClose" key="关闭" isShowIcon="true" icon="icon-close" onClick="parent.Base.closeWindow('medicalNewPan');"/>
```

## 引入JS文件
```javascript
<script src="<%=basePath%>ta/resource/showProv/city.js" type="text/javascript"></script>
```
<%=basePath%> webapp目录

## 获取属性值
`$("#wsaae006").attr('readonly')`

## ta3 maven项目（如处方平台medplatform）利用ta框架下载模板文件
参考 medplat项目 ` MedicalPersonManController.fileDownload();`

## Ta3中使用原生JS或JQuery

### 获取某元素的属性值  $("#id").attr('属性名')
```javascript
if ($("#wsaae006").attr('readonly') != 'readonly'){
    obj.setVisible(true,false);
}
```

## Ta+3 自带ajax函数

### submit()
`Base.submit(submit,url,parameter,onSubmit,autoValidate,succCallback,failCallback)`
表单提交与验证，并能够对后台返回的JSON数据做处理。

### submitForm()
`Base.submitForm(formid,onSubmit,autoValidate,url)`
同步提交form，主要用途，表单提交后要刷新整个页面或者跳转到其他页面时、以及需要使用文件上传功能的时候使用

## Ta3 前台不常用方法

### getIdCardBirthday 鸡肋的方法
`Base.getIdCardBirthday(idCard)`通过身份证号码获取出生年月日

```javascript
var result = Base.getIdCardBirthday('130206199605250619');
console.log(result);
/*************************print**************************/
//1996-5-25  返回值不是标准的yyyy-mm-dd格式
/********************************************************/
```

### idcard218
`Base.idcard218(sId)`

身份证15to18 本身就是18位直接返回

## fileUpload
### onUploadSuccess无法进入回调
ta3 4.0.1版本 在chrome83以上版本 `fileUpload`组件的`onUploadSuccess`属性无法正确进入回调 解决办法
修改ta3cloud.js 第31291行 
`var iframe = toElement('<iframe src="javascript:false;" name="' + id + '" />');`
修改为
`var iframe = toElement('<iframe src="about:blank;" name="' + id + '" />');`