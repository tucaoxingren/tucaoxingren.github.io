## jsp
两组图表
```html
<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
<ta:box  fit="true">
	<ta:box id="main"  cssStyle="height:300px;weight:300px" ></ta:box>
	<ta:box id="main1"  cssStyle="height:300px;weight:300px" ></ta:box>
</ta:box>
```

## javascript
js为图表赋值,根据id赋值

1. 获取图表对象
2. Base.getJson("java查询数据方法", 查询sql入参(JSON格式), 回调函数(一般是为图表数据赋值))
3. 回调函数 为图表准备JSON数据，包括图表格式，图表数据

```javascript
function submitData(start,end){
//基于准备好的dom，初始化echarts图表
var myChart = echarts.init(document.getElementById('main'));
var myChart1 = echarts.init(document.getElementById('main1'));
// 为echarts对象加载数据 
//myChart.setOption(option);
Base.getJson("departmentDrgsSituationGraphController!query.do", {
		"dto['start']" :start,
		"dto['end']" :end
}, function(data) {
	//var now = new Date();
	var xAxis = eval(data.fieldData.xAxis);
	var yAxis = eval(data.fieldData.yAxis);
	var jyje = eval(data.fieldData.jyje);
	var bkc120 = eval(data.fieldData.bkc120);
	var dbzjsbz = eval(data.fieldData.dbzjsbz);
	var option = {
		title : {
			  text : "单病种科室费用前五名"  // 图表标题
		},
		tooltip : {
			show : true						 // 是否展示提示
		},
		toolbox: {							 // 图表工具
			show : true,
			feature : {
				dataView : {show: true, readOnly: false},  // 数据视图
				restore : {show: true},					   // 重置
				saveAsImage : {show: true}				   // 保存为图片
			}
		},
		legend : {
			data : [ '医疗费总额','结余金额','病种标准','单病种结算标准']
		},
		xAxis : [ {							// 横坐标
			type : 'category',
			data : xAxis
		} ],
		yAxis : [ {
			type : 'value'
		} ],
		series : [ 							// 设置图表数据
				   {
			"name" : "医疗费总额",			// 数据名
			"type" : "bar",					// 数据类型：柱形图
			"data" :yAxis					// 数据变量名
		},
		{
			"name" : "结余金额",
			"type" : "bar",
			"data" :jyje
		} ,
		{
			"name" : "病种标准",
			"type" : "bar",
			"data" :bkc120
		},
		{
			"name" : "单病种结算标准",
			"type" : "bar",
			"data" :dbzjsbz
		} 
		]
	};
	
	var option1 = {
			tooltip : {
				show : true
			},
			toolbox: {
				show : true,
				feature : {
					dataView : {show: true, readOnly: false},
					restore : {show: true},
					saveAsImage : {show: true}
				}
			},
			legend : {
				data : [ '医疗费总额','结余金额','病种标准','单病种结算标准']
			},
			xAxis : [ {
				type : 'category',
				data : xAxis
			} ],
			yAxis : [ {
				type : 'value'
			} ],
			series : [ 
					   {
				"name" : "医疗费总额",
				"type" : "line",
				"data" :yAxis
			},
			{
				"name" : "结余金额",
				"type" : "line",
				"data" :jyje
			} ,
			{
				"name" : "病种标准",
				"type" : "line",
				"data" :bkc120
			},
			{
				"name" : "单病种结算标准",
				"type" : "line",
				"data" :dbzjsbz
			} 
			]
		};
myChart.setOption(option);		// 为图表赋值
myChart1.setOption(option1);

});

}
```

## java
java查询数据并赋值

```java
public String query() throws Exception {
	ParamDTO dto = getDto();
	dto.put("akb020", dto.getAsString("akb020"));
	
	
	//已进入单病种结算情况表
	@SuppressWarnings("rawtypes")
	List list1 = hissisp3Dao.queryForList("getTestData", dto);
	setData("xAxis", this.tongjitToJson1(list1, "bkf019"));
	setData("yAxis", this.tongjitToJson1(list1, "akc264"));
	setData("jyje", this.tongjitToJson1(list1, "jyje"));
	setData("bkc120", this.tongjitToJson1(list1, "bkc120"));
	setData("dbzjsbz", this.tongjitToJson1(list1, "dbzjsbz"));
	
	/*//应进未进单病种结算情况表
	PageBean list2 =hissisp3Dao.queryForPageWithCount("balanceFeeList2", "getkc4bAndKf38InfoYJWJ", dto, dto);
	setList("balanceFeeList2", list2);*/
	return JSON;
}
```