﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

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
<style> 
   input {
   	
   }
</style>
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

    //测试方法
    function Test() {
        option.visualMap[0].pieces[0].color = 'yellow';

        myChart.setOption(option, true);
    }



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

	

    function Echarts() {

		//计算所查相差天数
        var days =CalDays();


    	
        //设置div图表区域的大小
        var worldMapContainer = document.getElementById('container');
        worldMapContainer.style.width = parseInt(window.innerWidth * 0.9) + 'px';
        sleep(20);
        worldMapContainer.style.height = parseInt(window.innerHeight * 0.9) + 'px';
        option.yAxis.max = (parseFloat($("#deadline2").val()) + parseFloat($("#deadline2").val() / 4))
        
        myChart.resize();
        //读取两个输入框的值
        marklineValue1 = $("#deadline1").val();
        marklineValue2 = $("#deadline2").val();

        //创建新的数组
        var sendData = new Array(5);
        //选择第一或第三项的时候做select4的判断
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

        //判断是否所有条件都进行了选择
        if (sendData[0] == "" || sendData[1] == "" || sendData[3] == "" || sendData[4] == ""||sendData[5]==""||sendData[6]=="") {
            alert("缺少必填项！");
            return;
        }
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

                option.visualMap.precision = 2;
                myChart.setOption(option, true);
            }
        })
    }

	function AddSeries () {
	           var tempSeries = {};
           tempSeries.name = 'vufguuj';
           tempSeries.type = 'line';
           tempSeries.calculable = true;
           tempSeries.data = [2000,2006,2546,2815,2645,2945,1347];

         
           option.series.push(tempSeries);
           myChart.setOption(option);
	}
</script>
      
</html>

