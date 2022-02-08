import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Models/position.dart';
import 'package:warehouse/Models/productModel.dart';
import 'package:warehouse/Services/positionService.dart';
import 'package:warehouse/View/App_Manager/Header.dart';
import 'package:warehouse/View/App_Manager/mngHome/components/Drawer.dart';
import 'package:warehouse/View/App_Manager/positionScreen/productUnstoredDetails/productUnstoredDetails.dart';
import 'package:warehouse/components/loading_view.dart';
import 'package:warehouse/helper/actionToFile.dart';

class ListProductUnstored extends StatelessWidget {
  const ListProductUnstored({
    Key key,
    this.position,
  }) : super(key: key);

  final Position position;

  loadProducts() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await PositionService().getUnstoredItem(pre.getString('token'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: MyDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Header(
                title: 'UnStored Product',
                userDrawer: false,
                preLoad: true,
              ),
            ),
            Expanded(
              flex: 5,
              child: FutureBuilder(
                future: loadProducts(),
                builder: (context, snapshot) {
                  List<Product> products = snapshot.data;
                  if (snapshot.data != null) {
                    return Container(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => ProductUnstoredDetails(
                                    product: products[index],
                                    position: position,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300],
                                    blurRadius: 1,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              width: size.width * 0.9,
                              height: size.height * 0.05,
                              margin: EdgeInsets.all(5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: CircleAvatar(
                                      // maxRadius: 50,
                                      // minRadius: 10,
                                      backgroundImage: NetworkImage(
                                          getdownloadUriFromDB(
                                              products[index].image)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child:
                                        Text('${products[index].productName}'),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text('${products[index].unit}'),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                        '\$${products[index].importPrice}'),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                        'qty: ${products[index].quantity}'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return MyLoading();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
