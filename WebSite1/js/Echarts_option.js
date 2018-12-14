			$(document).ready(function() {
			    
			        var dom = document.getElementById("container");
			        var myChart = echarts.init(dom);

			        var x_value = new Array();
			        var y_value = new Array();


			        var app = {};
			        option = null;
			        option = {
			            backgroundColor:'#FFFFFF',
			        title: {
			            text: 'DES化工线历史记录查询',
			            subtext: ''
			        },
			        tooltip: {
			            trigger: 'axis'
			        },
			        legend: {
			            data: ['DES监控值']
			        },
			        toolbox: {
			            show: true,
			            feature: {
			                dataZoom: {
			                    yAxisIndex: 'none'
			                },
			                dataView: { readOnly: false },
			                magicType: { type: ['line', 'bar'] },
			                restore: {},
			                saveAsImage: {}
			            }
			        },
			        xAxis: {
			            type: 'category',
			            boundaryGap: false,
			            data: x_value
			        },
			        yAxis: {
			            type: 'value',
			            max:5,
			            axisLabel: {
			                formatter: '{value} L/min'
			            }
			        },
			        dataZoom: [
			            {
			                show: true,
			                realtime: true,
			                start: 0,
			                end: 120
			            },
			            {
			                type: 'inside',
			                realtime: true,
			                start: 45,
			                end: 85
			            }
			        ],
			        visualMap: [
			        {
			            show: false,
			            type: 'piecewise',
			            precision:2,
			            seriesIndex: 0, //控制series 对应的区域
			            pieces: [
			                {
			                    gt: 0,
			                    lte: 5,
			                    color: 'red'
			                },
			                {
			                   
			                    gt: 5,
			                    lte: 10,
			                    color: 'green'
			                },
			                {
			                  
			                    gt: 11,
                                lte: 25,
                                color:'red'}
			            ]

			                }
			            ],
			            series: [
			                {
			                    name: 'DES监控值',
			                    type: 'line',
			                    data: y_value,

			                    markLine: {
			                        data: [
			                            { yAxis: marklineValue  },
			                            { type: 'average', name: '平均值' }
			                        ]
			                    }
			                }
			            ]
			        };;
			        if (option && typeof option === "object") {
			           // myChart.setOption(option, true);
			            window.onresize = function() {
			             //重置容器高宽
			             //resizeWorldMapContainer();
			            myChart.resize();
			            };
			        }
			    
			});