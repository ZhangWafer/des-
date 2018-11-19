using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Office.Interop.Excel;
using DataTable = System.Data.DataTable;


public partial class index : System.Web.UI.Page
{

    private static DataTable referDataTable;

    protected void Page_Load(object sender, EventArgs e)
    {
        referDataTable = SqlHelper.ExecuteDataTable("select * from Refer_Table");
    }

    //str是Name，str1是LeftRight，str2是UpDown
    private static DataTable ResultTable = null;





    [WebMethod]
    public static string[] HelloWord(string str, string str2, string str3, string str4, string str5,string str6)
    {
        //设置数据采样间隔
         int SectionSize = 10;
        int selectDays = int.Parse(str6);
        if (selectDays<15)
        {
            SectionSize = 5;
        }
        else if (selectDays>=15&&selectDays<=30)
        {
            SectionSize = 15;
        }
        else if (selectDays>=30&&selectDays<=60)
        {
            SectionSize = 30;
        }
        else
        {
            SectionSize = 60;
        }
       

        string TableSelect = "";
        if (str3 == "null" || str3=="undefined")
        {
            TableSelect = string.Format("Name='{0}' and  LeftRight='{1}'", str, str2);

        }
        else
        {
            TableSelect = string.Format("Name='{0}' and  LeftRight='{1}' and UpDown='{2}'", str, str2, str3);
        }


        //把筛选行的数组挑出来
        DataRow[] registerNum = null;
        try
        {
            registerNum = referDataTable.Select(TableSelect);
        }
        catch (Exception)
        {

            Console.WriteLine("输入信息错误");
        }
        try
        {
            ResultTable = QueryRecordFromSql(Convert.ToInt16(registerNum[0][0]), str4, str5);
        }
        catch (Exception)
        {
           Console.Write("读取id失败");
        }

        if (ResultTable.Rows.Count==0)
        {
            return null;
        }

        string[] x_Result =null;
        string[] y_Result =null;
        //设置数组大小
        string[] dataSql = new string[(ResultTable.Rows.Count / SectionSize) * 2 + 1];
        //写入数组大小，到数组第一位dataSql[0]
        dataSql[0] = (ResultTable.Rows.Count / SectionSize).ToString();
        for (int i = 1; i < ResultTable.Rows.Count / SectionSize; i++)
        {

            dataSql[i] = ResultTable.Rows[i * SectionSize][2].ToString();

            if (ResultTable.Rows[i * SectionSize][1].ToString() == "0")
            {
                dataSql[ResultTable.Rows.Count / SectionSize + i] = "-";
            }
            else
            {
                dataSql[ResultTable.Rows.Count / SectionSize + i] = ResultTable.Rows[i * SectionSize][1].ToString();
            }
        }

        return dataSql;
    }

    [WebMethod]
    public static bool ExcleExplore()
    {
        try
        {
            DataTableToExcel(ResultTable, "D:\\Des");
            return true;
        }
        catch (Exception exception)
        {
           Console.WriteLine("请关闭打开的excle文档" + exception.Message);
            return false;
        }
        
    }

    [DllImport("User32.dll", CharSet = CharSet.Auto)]
    public static extern int GetWindowThreadProcessId(IntPtr hwnd, out int ID);

    public static void DataTableToExcel(System.Data.DataTable tmDataTable, string strFileName)
    {

        if (strFileName == null)
        {
            return;
        }
        int RowNum = tmDataTable.Rows.Count;
        int ColumnNum = tmDataTable.Columns.Count;
        int RowIndex = 1;
        int ColumnIndex = 0;
        Microsoft.Office.Interop.Excel.Application xlapp = new Microsoft.Office.Interop.Excel.Application();

        //打开Excel应用
        xlapp.DefaultFilePath = "";
        xlapp.DisplayAlerts = true;
        Microsoft.Office.Interop.Excel.Workbooks workbooks = xlapp.Workbooks;
        Microsoft.Office.Interop.Excel.Workbook workbook =
        workbooks.Add(Microsoft.Office.Interop.Excel.XlWBATemplate.xlWBATWorksheet); //创建一个Excel文件
        Microsoft.Office.Interop.Excel.Worksheet worksheet =
        (Microsoft.Office.Interop.Excel.Worksheet)workbook.Worksheets[1];

        //拿到那个工作表
        //foreach (DataColumn dc in tmDataTable.Columns)
        //{
        //    ColumnIndex++;
        //    worksheet.Cells[RowIndex, ColumnIndex] = dc.ColumnName;
        //}

        //给两列写列名
        worksheet.Columns.HorizontalAlignment = XlHAlign.xlHAlignCenter; //水平居中
        worksheet.Columns.ColumnWidth = 20;
        worksheet.Cells[1, 1] = "值";
        worksheet.Cells[1, 2] = "时间";

        //添加寄存器对应的监控点名称
        for (int i = 0; i < RowNum; i++)
        {
            RowIndex++;
            ColumnIndex = 0;
            for (int j = 1; j < 3; j++)
            {
                ColumnIndex++;
                worksheet.Cells[RowIndex, ColumnIndex] = tmDataTable.Rows[i][j].ToString();
            }
        }
        workbook.SaveCopyAs(strFileName + ".xlsx");

        //退出关闭EXCLE.EXE线程
        xlapp.Quit();
        IntPtr t = new IntPtr(xlapp.Hwnd);
        int k = 0;
       
        System.Diagnostics.Process p = System.Diagnostics.Process.GetProcessById(k);
        p.Kill();
    }

    //Sql查询历史记录方法
    private static DataTable QueryRecordFromSql(int typeid,string date1,string date2)
    {
        string queryString =
            string.Format(
                "select * from MAT_Chemical_Line.dbo.Simple_RecordTable where TypeId={0} and RecordTime >= '{1} 00:00:00'  and RecordTime<='{2} 23:59:59'  order by RecordTime",
                typeid, date1, date2);
        return SqlHelper.ExecuteDataTable(queryString);
    }
}
