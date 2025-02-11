import 'package:flutter/material.dart';
import 'package:mall/constant/app_strings.dart';
import 'package:mall/event/tab_select_event.dart';
import 'package:mall/ui/page/home/tab_cart_page.dart';
import 'package:mall/ui/page/home/tab_category_page.dart';
import 'package:mall/ui/page/home/tab_mine_page.dart';
import 'package:mall/ui/page/home/tabhome/tab_home_page.dart';
import 'package:mall/utils/shared_preferences_util.dart';
import 'package:mall/utils/navigator_util.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _list = [];

  @override
  void initState() {
    super.initState();
    SharedPreferencesUtil.getInstance().setBool(AppStrings.IS_FIRST, false);
    tabSelectBus.on<TabSelectEvent>().listen((event) {
      setState(() {
        TabSelectEvent tabSelectEvent = event;
        _selectedIndex = tabSelectEvent.selectIndex;
      });
    });
    _list
      ..add(TabHomePage())
      ..add(TabCategoryPage())
      ..add(TabCartPage())
      ..add(TabMinePage());
  }

  _changeIndex(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _list,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.HOME,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: AppStrings.CATEGORY,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: AppStrings.SHOP_CAR,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: AppStrings.MINE,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black87,
        onTap: (int index) {
          if (index == 2 || index == 3) {
            SharedPreferencesUtil.getInstance().getString(AppStrings.TOKEN).then((value) {
              if (value == null) {
                NavigatorUtil.goLogin(context);
                return;
              }
              _changeIndex(index);
            });
          } else {
            //防止点击当前BottomNavigationBarItem rebuild
            _changeIndex(index);
          }
        },
      ),
    );
  }
}
