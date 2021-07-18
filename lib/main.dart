import 'package:flutter/material.dart';
import 'providers/auth.dart';
import 'providers/orders.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/user_products_screen.dart';
// import 'package:myshop/widgets/drawer.dart';
import './providers/cart.dart';
import 'package:provider/provider.dart';
import 'screens/product_overview_screen.dart';
import './providers/products.dart';
import './screens/product_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(),
          update: (context, auth, previousProducts) => previousProducts
            ..update(
              auth.token,
              auth.userId,
              previousProducts.items == null ? [] : previousProducts.items,
            ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, auth, previousOrders) => previousOrders
            ..update(
              auth.token,
              auth.userId,
              previousOrders.orders == null ? [] : previousOrders.orders,
            ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          // home: MyHomePage(title: 'Flutter Demo Home Page'),
          initialRoute: auth.isAuth
              ? ProductOverviewScreen().screenId
              : AuthScreen().screenId,
          routes: {
            ProductOverviewScreen().screenId: (ctx) => ProductOverviewScreen(),
            ProductDetails().screenId: (ctx) => ProductDetails(),
            CartScreen().screenId: (ctx) => CartScreen(),
            OrdersScreen().screenId: (ctx) => OrdersScreen(),
            UserProductsScreen().screenId: (ctx) => UserProductsScreen(),
            EditProductScreen().screenId: (ctx) => EditProductScreen(),
            AuthScreen().screenId: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('home page'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
