# TA3Cloud tips

## 获取服务器绝对路径
### JS
`Base.globvar.basePath`
### 页面中
`${basePath}`

## Exception
`PrcException`引入路径为`com.yinhai.sisp3.his.common.exception.PrcException`，引入其它`PrcException`无法捕获

## 登录信息的获取
```java
ParamDTO dto = getDto();
dto.put("akb020", dto.getAsString("akb020"));//医院编码默认为当前登录医院
```
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

###idcard218
`Base.idcard218(sId)`

身份证15to18 本身就是18位直接返回