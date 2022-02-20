import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/View/App_Customer/cusProducts/ProductDetailsScreen/ProductDetailsScreen.dart';
import 'package:warehouse/View/App_Customer/cusProducts/cusScanner/CusQRScanner.dart';
import 'package:warehouse/View/App_Customer/customer_header.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/components/searchBar.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<Product> products =
        await ProductService().getProducts(preferences.getString('token'));
    return products;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CusScanQRProduct()));
        },
        backgroundColor: my_org,
        child: Icon(
          Icons.qr_code_scanner_outlined,
          color: my_org_30,
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Header(),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Products',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 24,
                            color: my_org,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(height: 1, width: size.width, color: Colors.grey),
                    FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return ListProduct(
                              products: snapshot.data,
                            );
                          } else {
                            return MyLoading();
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListProduct extends StatefulWidget {
  const ListProduct({Key key, this.products}) : super(key: key);

  @override
  _ListProductState createState() => _ListProductState(products);

  final List<Product> products;
}

class _ListProductState extends State<ListProduct> {
  final List<Product> oProducts;
  String search = '';
  bool loadtemp = false;

  _ListProductState(this.oProducts);

  void load() {
    setState(() {
      loadtemp = true;
    });
  }

  List<Product> products;
  searchHandle(String search, oProducts) {
    setState(() {
      products = oProducts
          .where(
            (Product e) => e.productName.toLowerCase().contains(
                  search.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    products = oProducts;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        SizedBox(height: size.height * 0.01),
        SearchBar(
          onChanged: (value) {
            setState(() {
              search = value;
            });
            searchHandle(search, oProducts);
          },
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          height: size.height * 9 / 12,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.height * 0.01,
            ),
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => ItemCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        product: products[index],
                      ),
                    ),
                  );
                },
                product: products[index],
              ),
            ),
          ),
        )
      ],
    );
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
      child: FittedBox(
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
              '${product.productName != null ? product.productName : ''}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('\$${product.importPrice != null ? product.importPrice : ''}'),
            Text('Unit: ${product.unit != null ? product.unit : ''}'),
          ],
        ),
      ),
    );
  }
}
