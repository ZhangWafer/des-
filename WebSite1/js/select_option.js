 		$(document).ready(function() {  
			//创建select数组
			var selectArray=["流量监控","风刀监控","喷淋压力监控","喷淋显影监控","喷淋蚀刻前监控","喷淋蚀刻后监控","喷淋去膜清洗监控","喷淋去膜监控"];
			var selectArray2=["放流1", "显影清洗", "放流2-1", "放流2-5", "比重水", "放流3-1", "酸洗1", "水洗3-4", "去膜定量", "放流4-1", "汤洗4-3", "酸洗2",
	                "水洗4-5", "防锈", "放流5-4"];
	        var selectArray3=["左","右"];
	        var selectArray4=["上","下"];
			//添加选项进第一个select
			for (i=0;i<selectArray.length;i++)
			{
				$("#select1").append("<option value='"+selectArray[i]+"'>"+selectArray[i]+"</option>");
			}
			
			//添加默认选项进去第二个select
			for (i=0;i<selectArray2.length;i++) {
				$("#select2").append("<option value='"+selectArray2[i]+"'>"+selectArray2[i]+"</option>");
			}
			
			//添加默认选项进去第三个select
			for (i=0;i<selectArray3.length;i++) {
				$("#select3").append("<option value='"+selectArray3[i]+"'>"+selectArray3[i]+"</option>");
			}
			
			//添加默认选项进去第四个select
			for (i=0;i<selectArray4.length;i++) {
				$("#select4").append("<option value='"+selectArray4[i]+"'>"+selectArray4[i]+"</option>");
			}
			
			$("#select4").hide();
			$("#select4").show();
			//把select4设置为disable
 		    $("#select4").attr("disabled", "disabled");
			
       	    //下拉触发选择事件
       	    $("#select1").change(function(){
    		//清除选项
    		$("#select2").find("option").remove();
			//创建临时数组
			var selectArrayOption=[];
			option.yAxis.axisLabel.formatter = "{value} L/min";
            
    		switch($("#select1").val())
			{
				case "流量监控":
				 selectArrayOption=["放流1", "显影清洗", "放流2-1", "放流2-5", "比重水", "放流3-1", "酸洗1", "水洗3-4", "去膜定量", "放流4-1", "汤洗4-3", "酸洗2",
	                "水洗4-5", "防锈", "放流5-4"];
				    $("#select4").attr("disabled", "disabled");
				    $("#select4").val("666");
				  
				  break;
				case "风刀监控":
				 selectArrayOption=["风刀1", "风刀2", "风刀3"];
				 $("#select4").removeAttr("disabled")
				 option.yAxis.axisLabel.formatter = "{value} kPa/min";
				  break;
				case "喷淋压力监控":
				 selectArrayOption=["显影", "蚀刻前", "蚀刻后", "去膜", "去膜清洗"];
				 $("#select4").attr("disabled","disabled")
				 $("#select4").val("666")
				 option.yAxis.axisLabel.formatter = "{value} MPa/min";
				  break;
				case "喷淋显影监控":
				 selectArrayOption=["显影1", "显影2", "显影3", "显影4", "显影5", "显影6", "显影7", "显影8"];
				 $("#select4").removeAttr("disabled")
				  break;
				case "喷淋蚀刻前监控":
				 selectArrayOption=["蚀刻前1", "蚀刻前2", "蚀刻前3", "蚀刻前4", "蚀刻前5", "蚀刻前6", "蚀刻前7", "蚀刻前8"];
				  $("#select4").removeAttr("disabled")
				  break;
				case "喷淋蚀刻后监控":
				 selectArrayOption=["蚀刻后1", "蚀刻后2", "蚀刻后3", "蚀刻后4", "蚀刻后5", "蚀刻后6", "蚀刻后7", "蚀刻后8"];
				  $("#select4").removeAttr("disabled")
				  break;
				case "喷淋去膜清洗监控":
				 selectArrayOption=["去膜清洗1", "去膜清洗2", "去膜清洗3", "去膜清洗4"];
				  $("#select4").removeAttr("disabled")
				  break;
				case "喷淋去膜监控":
				 selectArrayOption=["去膜1", "去膜2", "去膜3", "去膜4", "去膜5", "去膜6", "去膜7", "去膜8", "去膜9", "去膜10", "去膜11", "去膜12"];
				  $("#select4").removeAttr("disabled")
				  break;
			}
    		//添加option进去select
    		for (i=0;i<selectArrayOption.length;i++)
			{
				$("#select2").append("<option value='"+selectArrayOption[i]+"'>"+selectArrayOption[i]+"</option>");//新增
			}
    		
    		});
    		
		}); 	