<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<div>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	    <script src="js/jquery-3.3.1.min.js"></script>
	    <script src="js/echarts.min.js"></script>
	    <script src="js/Echarts_option.js"></script>
	    <script src="js/jquery-ui.js"></script>
	    <script src="bootstrap-3.3.7-dist/js/bootstrap.js" type="text/javascript" charset="utf-8"></script>
	    <script src="js/select_option.js"></script>
	    <link rel="stylesheet" type="text/css" href="css/jquery-ui.css"/>
	    <link rel="stylesheet" type="text/css" href="bootstrap-3.3.7-dist/css/bootstrap.css"/>
	    <link rel="stylesheet" type="text/css" href="css/amazeui.flat.css"/>
	    <title></title>
</div>	

</head>
<body style="background-size:cover; height: 100%; width: 100%;margin: 0">
    <form id="form1" runat="server" >
		<label>模式</label>
         <select  id="select1" class="btn-secondary-outline radius"></select>
		<select  id="select2" class="btn-secondary-outline radius"></select>
		<label>线体</label>
        <select id="select3" class="btn-secondary-outline radius"></select>
		<label>位置</label>
        <select id="select4" class="btn-secondary-outline radius"></select>
		<!--时间-->
		<label>开始时间</label>
		<input type="text"  id="datePicker1" style="width: 100px"/>
		<label>结束时间</label>
		<input type="text"  id="datePicker2" style="width: 100px"/>
        <label>下限设置</label>
        <input type="text"  id="deadline1"  style="width: 30px"/>
        <div style="display: inline;">       
        <label>上限设置</label>
        <input  type="text"  id="deadline2"  style="display: inline;width: 50px;"/>
        </div>
		<input  class="btn" type="button" Value="查询" onclick="Echarts()" />
		<input  class="btn" type="button"  value="新增" onclick="AddSeries()" />
		<!--<input  class="btn" type="button" value="更改上下限" onclick="changeDeadline()" />-->
		<input  class="btn" type="button"  value="清空" onclick="ClearWeb()" />
    </form>
    <div id="container" style="height: 20px; width: 50px;"></div>
</body>
 	<!--js内容-->
<script type="text/javascript">
    //设置日期选择器
    $("#datePicker1").datepicker({ dateFormat: 'yy-mm-dd' });
    $("#datePicker2").datepicker({ dateFormat: 'yy-mm-dd' });
    //定义mychart
    var dom = document.getElementById("container");
    var myChart = echarts.init(dom);


    var marklineValue = 0;
    var marklineValue1 = null;
    var marklineValue2 = null;

    //线程休眠
    function sleep(numberMillis) {
        var now = new Date();
        var exitTime = now.getTime() + numberMillis;
        while (true) {
            now = new Date();
            if (now.getTime() > exitTime)
            return;
        }
    }
    
    //刷新页面
    function ClearWeb () {
    	window.location.reload();
    }
    
    //更改上下限方法
    function changeDeadline () {
    	//读取两个输入框的值
        marklineValue1 = $("#deadline1").val();
        marklineValue2 = $("#deadline2").val();
        //设置markline值
        option.series[0].markLine.data[0].yAxis = marklineValue1;
        option.series[0].markLine.data[1].yAxis = marklineValue2;
        //设置markline上下颜色
		option.visualMap[0].pieces[0].lte = parseFloat(marklineValue1);
	    option.visualMap[0].pieces[1].gt = parseFloat(marklineValue1);
	    option.visualMap[0].pieces[1].lte = parseFloat(marklineValue2);
	    option.visualMap[0].pieces[2].gt = parseFloat(marklineValue2);
	    
        //设置图标区域y轴最大值
        option.yAxis.max = (parseFloat($("#deadline2").val()) + parseFloat($("#deadline2").val() / 4));
	    //重新启动echart
	     myChart.setOption(option, true);
    }

    
    ////测试环境初始化变量
    //$("#datePicker1").val("2018-08-01");
    //$("#datePicker2").val("2018-09-01");

	//计算日期相差天数方法
	function CalDays () {
			var s1 = ($("#datePicker1").val()).toString();
			var s2 = ($("#datePicker2").val()).toString();
			s1 = new Date(s1.replace(/-/g, "/"));
			s2 = new Date(s2.replace(/-/g, "/"));
			var days = s2.getTime() - s1.getTime();
			var time = parseInt(days / (1000 * 60 * 60 * 24));
			return time;
	}
	
	//创建新的数组
    var sendData = new Array(5);
	function SelectOPtioned () {
		if (($("#select1").val() == "流量监控") || ($("#select1").val() == "喷淋压力监控")) {
            sendData[0] = $("#select2").val();
            sendData[1] = $("#select3").val();
            sendData[3] = $("#datePicker1").val();
            sendData[4] = $("#datePicker2").val();
            sendData[5] = $("#deadline1").val();
            sendData[6] = $("#deadline2").val();
        }
        else {
            sendData[0] = $("#select2").val();
            sendData[1] = $("#select3").val();
            sendData[2] = $("#select4").val();
            sendData[3] = $("#datePicker1").val();
            sendData[4] = $("#datePicker2").val();
            sendData[5] = $("#deadline1").val();
            sendData[6] = $("#deadline2").val();
        }
	}

	//随机颜色生成
	function RandonColor () {
		this.r = Math.floor(Math.random()*180);
	    this.g = Math.floor(Math.random()*255);
	    this.b = Math.floor(Math.random()*255);
	    var  color = 'rgba('+ this.r +','+ this.g +','+ this.b +',0.8)';
	    return color;
	}
	 
	var LineList=new Array();
    function Echarts() {
		//计算所查相差天数
        var days =CalDays();
        //设置div图表区域的大小
        option.visualMap.precision = 2;
        var worldMapContainer = document.getElementById('container');
        worldMapContainer.style.width = parseInt(window.innerWidth * 0.9) + 'px';
        sleep(20);
        worldMapContainer.style.height = parseInt(window.innerHeight * 0.9) + 'px';
        //设置图标区域y轴最大值
        option.yAxis.max = (parseFloat($("#deadline2").val()) + parseFloat($("#deadline2").val() / 4));
        //设置曲线名称
        option.series[0].name= $("#select1").val()+'-'+$("#select2").val()+'-'+$("#select3").val()+'-'+$("#select4").val();
        myChart.resize();
        //读取两个输入框的值
        marklineValue1 = $("#deadline1").val();
        marklineValue2 = $("#deadline2").val();
        //选择第一或第三项的时候做select4的判断
		SelectOPtioned();
        //判断是否所有条件都进行了选择
        if (sendData[0] == "" || sendData[1] == "" || sendData[3] == "" || sendData[4] == ""||sendData[5]==""||sendData[6]=="") {
            alert("缺少必填项！");
            return;
        }
        //设置select1，2不可用
        $("#select1").attr("disabled",'disabled');
        $("#select1").attr('style','background-color: #9D9D9D;');
        //添加线体名称进列表
        LineList.push(($("#select1").val()+'-'+$("#select2").val()+'-'+$("#select3").val()+'-'+$("#select4").val()).toString());
        
        //新建缓存x,y
        var x_value = new Array();
        var y_value = new Array();
        //ajax发送数据到后台
        $.ajax({
            type: 'post',
            contentType: 'application/json',
            url: 'index.aspx/HelloWord',
            data: "{'str':'" + sendData[0] + "','str2':'" + sendData[1] + "','str3':'" + sendData[2] + "','str4':'" + sendData[3] + "','str5':'" + sendData[4] + "','str6':'"+days+"'}",
            dataType: 'json',
            success: function (result) {
                if (result.d==null) {
                    alert("读取数据为空！");
                    return;
                }
                //x轴的值和y轴的值的定义
                 // alert(result.d[0]);

                for (var i = 0; i < parseInt(result.d[0]); i++) {
                    x_value[i] = result.d[i + 1];
                    y_value[i] = result.d[i + parseInt(result.d[0]) + 2];
                }
                option.xAxis.data = x_value;
                option.series[0].data = y_value;
                //设置markline值
                option.series[0].markLine.data[0].yAxis = marklineValue1;
                option.series[0].markLine.data[1].yAxis = marklineValue2;
                //设置markline上下颜色
				option.visualMap[0].pieces[0].lte = parseFloat(marklineValue1);
	            option.visualMap[0].pieces[1].gt = parseFloat(marklineValue1);
	            option.visualMap[0].pieces[1].lte = parseFloat(marklineValue2);
	            option.visualMap[0].pieces[2].gt = parseFloat(marklineValue2);
				//设置数值精度
                option.visualMap.precision = 2;
                myChart.setOption(option, true);
            }
        })
    }
		//复选按钮调用方法
		function AddSeries () {
			if(LineList.indexOf(($("#select1").val()+'-'+$("#select2").val()+'-'+$("#select3").val()+'-'+$("#select4").val()).toString())!=-1)
			{
				alert('已存在该线体');
				return;
			}
		//计算所查相差天数
        var days =CalDays();
        //定义线段数量
		var seriesNum =option.series.length;
		//添加颜色控制区域visualmap
		var tempVisualmap={};
		tempVisualmap.show=false;
		tempVisualmap.type='piecewise';			       
		tempVisualmap.precision	=2; 		           
		tempVisualmap.seriesIndex=seriesNum;			       
		tempVisualmap.pieces=[ {gt: 0,lte: 5, color: 'red'},{gt: 5,lte: 10,color: 'green'}, { gt: 11,lte: 25,color:'red'}]			           
		option.visualMap.push(tempVisualmap)
		//设置上下限的数值
		option.visualMap[seriesNum].pieces[0].lte = parseFloat(marklineValue1);
	    option.visualMap[seriesNum].pieces[1].gt = parseFloat(marklineValue1);
	    option.visualMap[seriesNum].pieces[1].lte = parseFloat(marklineValue2);
	    option.visualMap[seriesNum].pieces[2].gt = parseFloat(marklineValue2);
	    //设置上下限颜色
	    option.visualMap[seriesNum].pieces[1].color = RandonColor();
	    //取选择box的值
	    SelectOPtioned();
	    
		//新增一条series
	    var tempSeries = {};
        tempSeries.name =  $("#select1").val()+'-'+$("#select2").val()+'-'+$("#select3").val()+'-'+$("#select4").val();
//      $("#select1").val().toString()+"-"+$("#select2").val().toString()+“-”+$("#select3").val().toString()+“-”+$("#select4").val().toString();
        tempSeries.type = 'line';
        tempSeries.data = [];        
        option.series.push(tempSeries);
        //设置数值精度
        option.visualMap.precision = 2;
        //定义y数组
        var y_value = new Array();
		//ajax请求数据
		$.ajax({
            type: 'post',
            contentType: 'application/json',
            url: 'index.aspx/HelloWord',
            data: "{'str':'" + sendData[0] + "','str2':'" + sendData[1] + "','str3':'" + sendData[2] + "','str4':'" + sendData[3] + "','str5':'" + sendData[4] + "','str6':'"+days+"'}",
            dataType: 'json',
            success: function (result) {
            	//数据返回成功方法
				if (result.d==null) {
                    alert("读取数据为空！");
                    return;
               }
                //x轴的值和y轴的值的定义
                 // alert(result.d[0]);
                for (var i = 0; i < parseInt(result.d[0]); i++) {
                    y_value[i] = result.d[i + parseInt(result.d[0]) + 2];
                }
				//把数据塞进y轴
                option.series[seriesNum].data = y_value;
                //重新启动echarts
          		myChart.setOption(option, true);
            }
		});

	}
</script>
      
</html>

