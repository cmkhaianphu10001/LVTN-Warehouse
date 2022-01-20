import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/productService.dart';
import 'package:warehouse/colors.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/JWTconvert.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({Key key}) : super(key: key);

  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  Future getProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var payload = parseJwt(token);

    var res =
        await ProductService().getProductBySupplierID(token, payload['id']);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot) {
          if (!(snapshot.data != null)) {
            return MyLoading();
          } else {
            return Container(
              height: size.height * 9 / 12,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.height * 0.01,
                ),
                child: GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) => ItemCart(
                    onTap: () {},
                    product: snapshot.data[index],
                  ),
                ),
              ),
            );
          }
        });
  }
}

class ItemCart extends StatelessWidget {
  final Product product;
  final Function onTap;

  const ItemCart({
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
                      domain + 'public/upload/images/' + product.image,
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
          Text('Quantity: ${product.quantity != null ? product.quantity : ''}'),
        ],
      ),
    );
  }
}
