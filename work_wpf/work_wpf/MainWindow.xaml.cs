using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.WindowsAPICodePack.Dialogs;
using ClosedXML.Excel;
using System.IO;

using System.Collections.ObjectModel;

namespace work_wpf
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        XLWorkbook workbook = null;
        IXLWorksheet worksheet = null;
        XLWorkbook taskbook = null;
        IXLWorksheet tasksheet = null;

        public MainWindow()
        {
            InitializeComponent();
        }

        // 参照ボタン(ファイル)押下
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            using (var cofd = new CommonOpenFileDialog()
            {
                Title = "ファイルを選択してください。",
                InitialDirectory = @"D:\Users\threeshark",
            })
            {
                if (cofd.ShowDialog() != CommonFileDialogResult.Ok)
                {
                    return;
                }

                // FileNameで選択されたフォルダを取得する
                textbox_path.Text = cofd.FileName;
            }
        }

        // 開始ボタン押下
        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            try
            {
                if ("閉じる" == btn_start.Content)
                {
                    btn_start.Content = "開く";
                }
                else
                {
                    workbook = new XLWorkbook(@textbox_path.Text);
                    string name = textbox_name.Text;
                    name = name.Replace(" ", "").Replace("　", "");
                    worksheet = workbook.Worksheet(name);

                    btn_start.Content = "閉じる";
                    string date = datepic.SelectedDate.Value.Year.ToString() + "/";
                    date = date + datepic.SelectedDate.Value.Month.ToString() + "/";
                    date = date + datepic.SelectedDate.Value.Day.ToString();

                    int max_line = worksheet.LastRowUsed().RowNumber();
                    List<SearchResult> listSearchResult = new List<SearchResult>();
                    for (int line = 1; max_line >= line; line++)
                    {
                        string str_date = worksheet.Cell(line, 1).Value.ToString();
                        str_date = str_date + ".";

                        // yyyy/mm/ddの前方一致したものをListに登録
                        if (str_date.StartsWith(date))
                        {
                            // 年月日が前方一致（時間はのぞいた検索）
                            SearchResult sr = new SearchResult();
                            sr.line = line;
                            sr.date = str_date;
                            sr.name = worksheet.Cell(line, 2).Value.ToString();
                            sr.task = worksheet.Cell(line, 3).Value.ToString();
                            sr.time = worksheet.Cell(line, 4).Value.ToString();
                            sr.memo = worksheet.Cell(line, 5).Value.ToString();
                            listSearchResult.Add(sr);
                        }
                    }

                    data_grid.ItemsSource = listSearchResult;
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message,
                    "エラー",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
            }
        }

        // 参照ボタン(勤務表)押下
        private void btn_kinm_Click(object sender, RoutedEventArgs e)
        {
            using (var cofd = new CommonOpenFileDialog()
            {
                Title = "ファイルを選択してください。",
                InitialDirectory = @"D:\Users\threeshark",
            })
            {
                if (cofd.ShowDialog() != CommonFileDialogResult.Ok)
                {
                    return;
                }

                // FileNameで選択されたフォルダを取得する
                textbox_kinm.Text = cofd.FileName;
            }
        }
    }

    // 検索結果
    public class SearchResult
    {
        public int line { get; set; }       // 行
        public string date { get; set; }    // 日付
        public string name { get; set; }    // 氏名
        public string task { get; set; }    // 作業名
        public string time { get; set; }    // 時間
        public string memo { get; set; }    // メモ
    }

}
