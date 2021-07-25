import 'package:flutter/material.dart';
import 'package:gelic_bakes/ui/admin/add_items.dart';
import 'package:gelic_bakes/ui/admin/items_page.dart';
import 'package:gelic_bakes/ui/admin/medicine.dart';
import 'package:gelic_bakes/ui/admin/orders_page.dart';

class AdminPage extends StatefulWidget {
  static const routeName = 'adminPage';
  int? selectedIndex;

  AdminPage({Key? key, this.selectedIndex}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Widget> _widgetOptions = <Widget>[
    OrdersPage(),
    ItemsPage(),
    Medicine(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: _widgetOptions.elementAt(widget.selectedIndex!),
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddItem()));
        },
        elevation: 0,
        child: Icon(Icons.add),
        mini: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: widget.selectedIndex!,
          selectedItemColor: Theme.of(context).primaryColor,
          backgroundColor: Color(0xFFFFFFFF),
          unselectedItemColor: Color(0xFFAFAFAF),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cake),
              label: 'All Pastries',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: 'Medicines',
            ),
          ]),
    );
  }
}
