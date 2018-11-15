<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script src="js/jquery-3.3.1.min.js"></script>
    <script src="js/echarts.min.js"></script>
    <script src="js/Echarts_option.js"></script>
    <script src="js/jquery-ui.js"></script>
    <script src="js/select_option.js"></script>
    <link rel="stylesheet" type="text/css" href="css/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="css/amazeui.flat.css"/>
    <title></title>
<style> 
   #hidebg { position:absolute;left:0px;top:0px; 
      background-color:#000; 
      width:100%;  /*宽度设置为100%，这样才能使隐藏背景层覆盖原页面*/  
      height: 100%;
      opacity:0.6;  /*非IE浏览器下设置透明度
          
          为60%*/ 
      display:none;
      z-Index:2;} 
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
        <label>上限设置</label>
        <input type="text"  id="deadline2"  style="width: 30px"/>
		<input type="button" Value="查询" onclick="Echarts()" />
      <%--  <input type="button" value="导出excle" id="ExcleButton" onclick="ExcleBG()"/>--%>
    </form>
    <div id="hidebg">
        <h1 style="text-align: center;margin-top: 50px">正在导出数据···</h1>
        <h1 style="text-align: center;margin-top: 50px">请稍等</h1>
        
    </div>
    <div id="container" style="height: 20px; width: 50px;"></div>
</body>
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

    //导出excle方法，通过ajax调用后台导出
    function ExcleBG(parameters) {
        //设置按键不可用
        $("#ExcleButton").attr("disabled", true);
        $("#ExcleButton").val("loading..............");
        //显示遮罩层
        show();
        //ajax以post方式发送指令
        $.ajax({
            type: 'post',
            contentType: 'application/json',
            url: 'index.aspx/ExcleExplore',
            data: "{'str':''}",
            dataType: 'json',
            success: function(result) {
                if (result.d[0]=="true") {
                    alert("导出成功");
                } else {

                    alert("请点击“是”按钮，然后另存到所需的目录下");
                }
                //取消遮罩层
                hide();

                //取消变灰，还原按键
                $("#ExcleButton").removeAttr("disabled");
                $("#ExcleButton").val("导出excle");
            }
        })

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

    function Echarts() {
    
        //设置div图表区域的大小
        var worldMapContainer = document.getElementById('container');
        worldMapContainer.style.width = parseInt(window.innerWidth * 0.9) + 'px';
        sleep(20);
        worldMapContainer.style.height = parseInt(window.innerHeight * 0.9) + 'px';
        
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
            data: "{'str':'" + sendData[0] + "','str2':'" + sendData[1] + "','str3':'" + sendData[2] + "','str4':'" + sendData[3] + "','str5':'" + sendData[4] + "'}",
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

    //显示隐藏层和弹出层 
    function show() 
    {
        var hideobj = document.getElementById("hidebg");
        hidebg.style.display = "block";  //显示隐藏层 
        //hidebg.style.height=document.body.clientHeight+"px";//设置隐藏层的高度为当前页面高度
      //  document.getElementById("hidebox").style.display = "block";  //显示弹出层 
    }

    //去除隐藏层和弹出层 
    function hide()  
    {
        document.getElementById("hidebg").style.display = "none";
        //   document.getElementById("hidebox").style.display="none"; 
    }
</script>
      
</html>

