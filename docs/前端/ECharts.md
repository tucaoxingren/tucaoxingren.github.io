## ECharts

### 圆环图在圆环中间显示文字
```javascript
option.series.lable=
{
    normal: {
        show: true,
        position: "center",
        formatter: function(){
            return "要显示的文字";
        },
        textStyle: {
            fontSize: 15,
            color: 'rgba(127, 127, 127, 0.996)'
        },
    },
    emphasis: {
        show: false,
        formatter: '{a}'
    }
}
```
### 页面初始化时 ECharts 容器需要隐藏
1. 页面初始化时 ECharts 容器需要隐藏 在取消隐藏的方法中延迟加载ECharts
```javascript
setTimeout(function () {
    // 加载ECharts
}, 300);
```
2. 在ready中初始化 在open中隐藏
3. 重新设置高度
```javascript
var charts = echarts.init(document.getElementById('gradedDiagnosis-bar'));
charts.getDom().style.height = "300px";
charts.resize();
```

### 取消图例的点击事件 即点击图例不隐藏所对应的数据系列
```javascritp
var option = {
    legend: {
        // 取消图例上的点击事件
        selectedMode:false
    }
```

### formatter

#### 格式化参数 {a} {b} {c} {d} 说明

| 图表名 | a | b | c | d | e |
| ---  | --- | --- | --- | --- | --- |
| 折线（区域）图、柱状（条形）图 | 系列名称 | 类目值 | 数值 | 无 |
| 散点图（气泡）图  | 系列名称 | 数据名称 | 数值数组 | 无 |
| 饼图、雷达图  | 系列名称 | 数据项名称 | 数值 | 百分比 |
| 弦图  | 系列名称 | 项1名称 | 项1-项2值 | 项2名称 | 项2-项1值 |
| 节点 | 类目名称 | 节点名称 | 节点值 |
| 边 | 系列名称 | 源名称-目标名称 | 边权重 | 如果为true的话则数据来源是边 |


#### 柱状图修改顶部显示的数值样式
```javascript
series: [
{
    name: "条", 
    type: "bar", 
    yAxisIndex: 0, 
    data: [
        4789030.9, 
        24758209.80, 
        8232927.44, 
        33109229.10
    ], 
    label: {
        normal: {
            show: true, 
            position: "right", 
            textStyle: {
                color: "rgba(127, 127, 127, 0.996)", 
                fontSize: 12
            },
            formatter:function(param){
                // data: "  4789030.96"
                // dataIndex: 0
                // dataType: null
                // name: "医疗救助金额"
                // seriesId: "条0"
                // seriesIndex: 0
                // seriesName: "条"
                // seriesType: "bar"
                // param.data 即 series.data
                // series.data必须是number型 echarts 默认会将数值显示在柱状图的顶部
                // 实际应用中顶部显示的数值如果太大 需要做万元处理是 在此处修改显示值
                return param.data;
            }
        }
    }
}
```