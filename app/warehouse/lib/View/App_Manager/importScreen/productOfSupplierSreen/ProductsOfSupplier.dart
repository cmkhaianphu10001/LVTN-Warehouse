import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Models/userModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/importScreen/productImport/productImport.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ProductsOfSupplier extends StatefulWidget {
  final User supplier;
  const ProductsOfSupplier({Key key, @required this.supplier})
      : super(key: key);

  @override
  _ProductsOfSupplierState createState() => _ProductsOfSupplierState(supplier);
}

class _ProductsOfSupplierState extends State<ProductsOfSupplier> {
  final User supplier;

  _ProductsOfSupplierState(this.supplier);

  List<Product> products;
  Future getProducts() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    var token = pre.getString('token');
    products =
        await ProductService().getProductBySupplierID(token, supplier.id);
    return products;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return MyLoading();
          } else {
            return Scaffold(
              drawer: MyDrawer(),
              body: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Header(
                        userDrawer: false,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: size.width,
                              child: Text(
                                'Products of ${supplier.name}',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 24,
                                    color: my_org,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            //listview
                            Container(
                                height: 1,
                                width: size.width,
                                color: Colors.grey),

                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: size.height * 0.7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.height * 0.01,
                                ),
                                child: GridView.builder(
                                  itemCount: snapshot.data.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.65,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) => ItemCard(
                                    product: snapshot.data[index],
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductImport(
                                                      supplier: supplier,
                                                      product: snapshot
                                                          .data[index])));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}

class ItemCard extends StatelessWidget {
  final Product product;
  final Function onTap;

  const ItemCard({
    Key key,
    this.onTap,
    this.product,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
        // color: Colors.red,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: onTap,
            child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    height: size.width * 0.25,
                    width: size.width * 0.3,
                    // color: Colors.blueAccent,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: my_org),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      getdownloadUriFromDB(product.image),
                      fit: BoxFit.contain,
                    )),
              ],
            ),
          ),
          Text(
            '${product.productName != null ? product.productName : 'ss'}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('\$${product.importPrice != null ? product.importPrice : ''}'),
          Text('Unit: ${product.unit != null ? product.unit : ''}'),
        ],
      ),
    );
  }
}
