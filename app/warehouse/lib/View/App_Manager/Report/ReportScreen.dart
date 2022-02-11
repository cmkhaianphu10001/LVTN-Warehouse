import 'dart:developer';
import 'dart:ui';

import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/historyModel.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime selectedDate = DateTime.now();
  List<HistoryModel> histories;
  List<Product> products;
  List<charts.Series<ChartValue, String>> seriesList1, seriesList2, seriesList3;

  //getdata
  Future<List<HistoryModel>> getHistories() async {
    return await ProductService().getHistory();
  }

  Future<List<Product>> getProducts() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await ProductService().getProducts(pre.getString('token'));
  }

  //create chart value
  static List<charts.Series<ChartValue, String>> _chartValueAmountImportExport(
      List<HistoryModel> histories, DateTime selectedDate) {
    List<ChartValue> chartvalueImport = [];
    List<ChartValue> chartvalueExport = [];
    for (int i = 1;
        i <= DateUtil().daysInMonth(selectedDate.month, selectedDate.year);
        i++) {
      double value1 = 0;
      double value2 = 0;
      histories
          .where((element) =>
              element.date.day == i && element.typeHistory == 'import')
          .toList()
          .forEach((element) {
        value1 += element.totalAmount;
      });
      chartvalueImport.add(new ChartValue(i.toString(), value1));
      histories
          .where((element) =>
              element.date.day == i && element.typeHistory == 'export')
          .toList()
          .forEach((element) {
        value2 += element.totalAmount;
      });
      chartvalueExport.add(new ChartValue(i.toString(), value2));
    }
    return [
      charts.Series(
        id: 'SaleInMonth',
        data: chartvalueImport,
        domainFn: (ChartValue value, _) => value.label,
        measureFn: (ChartValue value, _) => value.value,
        fillColorFn: (ChartValue value, _) =>
            charts.MaterialPalette.green.shadeDefault,
      ),
      charts.Series(
        id: 'SaleInMonth',
        data: chartvalueExport,
        domainFn: (ChartValue value, _) => value.label,
        measureFn: (ChartValue value, _) => value.value,
        fillColorFn: (ChartValue value, _) =>
            charts.MaterialPalette.red.shadeDefault,
      )
    ];
  }

  static List<charts.Series<ChartValue, String>> _chartValueBestSale(
      List<Product> products) {
    List<ChartValue> chartvalue = [];
    products.forEach((element) {
      chartvalue.add(ChartValue(
          element.productName, double.parse(element.sold.toString())));
    });
    return [
      charts.Series(
        id: 'BestSale',
        data: chartvalue,
        domainFn: (ChartValue value, _) => value.label,
        measureFn: (ChartValue value, _) => value.value,
        fillColorFn: (ChartValue value, _) =>
            charts.MaterialPalette.teal.shadeDefault,
      )
    ];
  }

  static List<charts.Series<ChartValue, String>> _chartPieAmount(
      List<HistoryModel> histories) {
    double importAmount = 0;
    double exportAmount = 0;
    histories
        .where((element) => element.typeHistory == 'import')
        .toList()
        .forEach((element) {
      importAmount += element.totalAmount;
    });
    histories
        .where((element) => element.typeHistory == 'export')
        .toList()
        .forEach((element) {
      exportAmount += element.totalAmount;
    });

    List<ChartValue> chartvalue = [
      ChartValue('Export', double.parse(exportAmount.toStringAsFixed(2))),
      ChartValue('Import', double.parse(importAmount.toStringAsFixed(2))),
    ];

    return [
      charts.Series(
        id: 'AmountImportExport',
        data: chartvalue,
        domainFn: (ChartValue value, _) => value.label,
        measureFn: (ChartValue value, _) => value.value,
        fillColorFn: (ChartValue value, _) =>
            charts.MaterialPalette.teal.shadeDefault,
      )
    ];
  }

  barchartAmountExportImport() {
    return Column(
      children: [
        Text(
          'Total Amount by day of Import and Export in ${selectedDate.month} - ${selectedDate.year}',
        ),
        Expanded(
          child: charts.BarChart(
            seriesList1,
            animationDuration: Duration(milliseconds: 500),
            animate: true,
            vertical: true,
          ),
        ),
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.green),
            ),
            Text('Import'),
          ],
        ),
        Row(
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.red),
            ),
            Text('Export'),
          ],
        ),
      ],
    );
  }

  pieChartAmountImportExport() {
    return Column(
      children: [
        Text(
          'totalAmount Import per Export in ${selectedDate.month} - ${selectedDate.year}',
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(3, 3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                    ),
                    Text(
                        '${seriesList3[0].data[0].label} - \$${seriesList3[0].data[0].value} '),
                    CircleAvatar(
                      backgroundColor: Colors.blue[200],
                    ),
                    Text(
                        '${seriesList3[0].data[1].label} - \$${seriesList3[0].data[1].value} '),
                  ],
                ),
              ),
              Expanded(
                child: charts.PieChart(
                  seriesList3,
                  animationDuration: Duration(milliseconds: 500),
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  barchartProductBestSale() {
    return Column(
      children: [
        Text(
          'Best selling products',
        ),
        Expanded(
          child: charts.BarChart(
            seriesList2,
            animationDuration: Duration(milliseconds: 500),
            animate: true,
            vertical: false,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Report'), backgroundColor: my_org),
      floatingActionButton: FloatingActionButton(
        backgroundColor: my_org_30,
        onPressed: () async {
          showMonthPicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 1, 5),
            lastDate: DateTime(DateTime.now().year + 1, 9),
            initialDate: selectedDate ?? DateTime.now(),
            locale: Locale("es"),
          ).then((date) {
            if (date != null) {
              setState(() {
                selectedDate = date;
              });
            }
          });
        },
        child: Icon(
          Icons.date_range,
          color: my_org,
        ),
      ),
      body: FutureBuilder(
          future: Future.wait([
            getHistories(),
            getProducts(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              histories = (snapshot.data[0] as List)
                  .where(
                    (element) =>
                        element.date.month == selectedDate.month &&
                        element.date.year == selectedDate.year,
                  )
                  .toList();
              seriesList1 =
                  _chartValueAmountImportExport(histories, selectedDate);

              List<Product> temp = snapshot.data[1];
              temp.sort(
                (a, b) => b.sold.compareTo(a.sold),
              );
              products = temp.take(5).toList();
              seriesList2 = _chartValueBestSale(products);
              seriesList3 = _chartPieAmount(histories);
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${selectedDate?.month} - ${selectedDate?.year} ',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 24,
                              color: my_org,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    //listview
                    Container(height: 1, width: size.width, color: Colors.grey),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              color: Colors.grey,
                              offset: Offset(4, 4),
                              spreadRadius: 5),
                          BoxShadow(
                              blurRadius: 15,
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              spreadRadius: 5),
                        ],
                      ),
                      height: size.height * 0.4,
                      width: size.width,
                      child: barchartAmountExportImport(),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              color: Colors.grey,
                              offset: Offset(4, 4),
                              spreadRadius: 5),
                          BoxShadow(
                              blurRadius: 15,
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              spreadRadius: 5),
                        ],
                      ),
                      height: size.height * 0.4,
                      width: size.width,
                      child: pieChartAmountImportExport(),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              color: Colors.grey,
                              offset: Offset(4, 4),
                              spreadRadius: 5),
                          BoxShadow(
                              blurRadius: 15,
                              color: Colors.white,
                              offset: Offset(-4, -4),
                              spreadRadius: 5),
                        ],
                      ),
                      height: size.height * 0.2,
                      width: size.width,
                      child: barchartProductBestSale(),
                    ),
                  ],
                ),
              );
            } else {
              return MyLoading();
            }
          }),
    );
  }
}

class ChartValue {
  final String label;
  final double value;
  ChartValue(
    this.label,
    this.value,
  );
}
