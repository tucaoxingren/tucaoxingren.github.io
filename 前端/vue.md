## vue

### v-if vs v-show
`v-if` 是“真正”的条件渲染，因为它会确保在切换过程中条件块内的事件监听器和子组件适当地被销毁和重建。  
`v-if `也是惰性的：如果在初始渲染时条件为假，则什么也不做——直到条件第一次变为真时，才会开始渲染条件块。  
相比之下，`v-show` 就简单得多——不管初始条件是什么，元素总是会被渲染，并且只是简单地基于 CSS 进行切换。  
一般来说，`v-if` 有更高的切换开销，而 `v-show` 有更高的初始渲染开销。因此，如果需要非常频繁地切换，则使用 `v-show` 较好；如果在运行时条件很少改变，则使用 `v-if` 较好。

### 输出HTML代码
```html
<!-- 纯文本 -->
<p>Using mustaches: {{ rawHtml }}</p>
<!-- 可以包含html代码 -->
<p>Using v-html directive: <span v-html="rawHtml"></span></p>
```

### click 获取当前元素
```html
<body id="app">
  <ul>
    <li v-on:click="say('hello!', $event)">点击当前行文本</li>
    <li>li2</li>
    <li>li3</li>
  </ul>
  <script>
   new Vue({
       el: '#app',
       data: {
        message: 'Hello Vue.js!'
       },
       methods: {
        say: function(msg, event) {
           //获取点击对象      
           var el = event.currentTarget;
           alert("当前对象的内容："+el.innerHTML);
        }
    }
   })
  </script>
 </body>
```

### 数据更新后 视图没有重新渲染
1. watch监听到数据的变化但页面没有刷新

在数据改动的代码后加  this.$forceUpdate();

添加this.$forceUpdate();进行强制渲染，效果实现。因为数据层次太多，render函数没有自动更新，需手动强制刷新。



2. 没有监听到数据的变化

例如：改变了数组中的某一项或者改变了对象中的某个元素时，监听则未生效。

数组若要触发监听，下面方法即可触发

如：splice()，push() 等js方法

当然了，也可以使用vue中的方法 this.$set(object, index, new)

this.$set()方法是vue自带的可对数组和对象进行赋值，并触发监听的方法。

第一个参数为你要改变的数组或对象

第二个参数为下标，或者元素名称

第三个参数为新值



3. new Date()对象

   ```javascript
   date: {
       date: new Date();
   }
   method: {
       方法: function (){
           var temp = // Date对象改变操作后的新Date对象
           this.date = null;
           this.date = temp;
       }
   }
   ```

   

