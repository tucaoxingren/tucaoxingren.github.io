//常用JS方法

//弹出个人信息查询窗口
function fnPopupQueryPersonInfoWindow(){
	var baa001=Base.getValue("baa001");
	var context = '<%=request.getContextPath() %>'; 
	showDialog(context + '/ynsicp3/common/common/popupWindowAction.do?reqCode=popupPersonWindowInit&bac002=2&baa001='+baa001, 780, 420);	
}
//弹出医院信息查询窗口
function fnPopupQueryMedicaAgencyInfoWindow(){
	var baa001 = Base.getValue("baa001");
	var context = '<%=request.getContextPath() %>';
	showDialog(context + '/ynsicp3/common/common/popupWindowAction.do?reqCode=personAppQueryMedicalInfoInit&bac002=2&baa001='+baa001, 800, 420);
}

//弹出单位信息查询窗口
function fnPopupQueryCorpInfoWindow(){
	var bac002 = Base.getValue('bac002');
    var context = '<%=request.getContextPath() %>';
	showDialog(context +'/ynsicp3/common/common/popupWindowAction.do?reqCode=queryCorp&bac002='+bac002, 780, 420);
}

//查询
function fnQuery(){
	if(!Base.validateForm()) return;
	Base.doUpdateCollection('balanceList', '', 'queryForCenter2',function(n,id){
    	Base.enabledButton('queryForCenter2');
    	if(n == 0){
        	alert('没有查询到待结算数据！');
        	Base.disabledButton('feeBalance2');
        	return;
      	}
    	Base.enabledButton('feeBalance2');
	});
	Base.disabledButton('queryForCenter2');
	Base.disabledButton('feeBalance2');
} 

// 提交到后台
Base.AjaxUpdateUi('info', 'query', null, null, function(){
	Base.enabledButton('btn_query');
});

Base.doUpdateCollection('paymentList', '', 'query',function(n,id){
	Base.enabledButton('btn_query');
	if(n == 0){
		alert('没有查询到待结算数据！');
		Base.disabledButton('btn_export');
		return;
	}
	Base.enabledButton('btn_export');
});