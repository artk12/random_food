import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class FoodSelectorScreen extends StatefulWidget {
  @override
  _FoodSelectorScreenState createState() => _FoodSelectorScreenState();
}

class _FoodSelectorScreenState extends State<FoodSelectorScreen> {
  String selectedFood = 'هنوز انتخاب نشده';
  List<String> iftarHistory = [];
  List<String> sahariHistory = [];
  OverlayEntry? _loadingOverlay;

  List<Food> iftar = [
    Food('برگر'),
    Food('پیراشکی'),
    Food('شاورما'),
    Food('سالاد نخود'),
    Food('پیتزا'),
    Food('سوسیس بندری'),
    Food('ساندویج مرغ سیب زمینی'),
    Food('کنتاکی'),
    Food('برگر مرغ'),
    Food('اسنک مرغ'),
    Food('سالاد ماکارونی'),
    Food('الویه'),
    Food('سیب زمینی پنری'),
    Food('ساندویج دودی'),
    Food('لازانیا'),
    Food('ساندویج گوشت'),
    Food('رول سوخاری'),
    Food('آش'),
    Food('نان تمشی'),
    Food('نان پاراتا'),
    Food('ساندویج حلقه ای'),
    Food('تاکو'),
  ];

  List<Food> sahari = [
    Food('زرشک پلو'),
    Food('عدس پلو'),
    Food('خورشت لپه'),
    Food('قرمه سبزی'),
    Food('هواری'),
    Food('زیبنی'),
    Food('کوبیده مرغ'),
    Food('کوفته قلقلی'),
    Food('مرغ سرخ شده'),
    Food('مرغ منجلی کره ای'),
    Food('مرغ دودی'),
    Food('کاتغ گوشت عیشی'),
    Food('پلو تن'),
    Food('تن ماهی خورشتی برنجی'),
    Food('گوشت ریش ریش'),
    Food('کوکو'),
    Food('گوبلی مرغ'),
  ];

  List<String> weekendFoods = [
    'پیتزا',
    'لازانیا',
    'کباب',
    'بریانی',
    'هواری',
    'کنتاکی',
    'تاکو',
    'ساندویچ دودی'
  ];

  getRandomFood(List<Food> foodList) async {
    bool weekend = isWeekend();
    List<String> weightedList = [];
    _showLoadingOverlay();

    await Future.delayed(Duration(seconds: 20));
    for (var food in foodList) {
      int weight = weekend && weekendFoods.contains(food.name) ? 10 : 5;
      weightedList.addAll(List.filled(weight, food.name));
    }
    _hideLoadingOverlay();
    return weightedList[Random().nextInt(weightedList.length)];
  }

  bool isWeekend() {
    String today =
        DateFormat('EEEE').format(DateTime.now().add(Duration(days: 1)));
    print(today);
    return today == 'thursday';
  }

  Future<void> showRandomFood(String mealType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Food> foodList = mealType == 'iftar' ? iftar : sahari;

    String food = await getRandomFood(foodList);
    setState(() {
      selectedFood = food;
      if (mealType == 'iftar') {
        iftarHistory.add(food);
      } else {
        sahariHistory.add(food);
      }
    });

    prefs.setStringList('iftarHistory', iftarHistory);
    prefs.setStringList('sahariHistory', sahariHistory);
  }

  void _showLoadingOverlay() {
    _loadingOverlay = OverlayEntry(
      builder: (context) => Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/anim/cooking.json', // فایل انیمیشن خود را در assets قرار دهید
              width: 300,
              height: 300,
            ),
            SizedBox(height: 16),
            Material(
              child: Text(
                'در حال انتخاب غذا...',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_loadingOverlay!);
  }

  void _hideLoadingOverlay() {
    _loadingOverlay?.remove();
    _loadingOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white, //Color(0xFFEAD9B3),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF8914AF),
                        blurRadius: 3,
                        spreadRadius: 1,
                      )
                    ]),
                child: Column(
                  children: [
                    Text(
                      'غذای انتخابی',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      selectedFood,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B479A)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => showRandomFood('iftar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF68D6D2),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'افطار',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => showRandomFood('sahari'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE093EF),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('سحری',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Row(
                children: [
                  // لیست تاریخچه افطار
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF68D6D2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'افطار:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: iftarHistory.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Text(index.toString()),
                                    trailing: Icon(Icons.fastfood,
                                        color: Colors.orangeAccent),
                                    title: Text(iftarHistory[index]),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // لیست تاریخچه سحری
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFFE093EF),
                                blurRadius: 3,
                                spreadRadius: 1)
                          ]),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سحری:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: sahariHistory.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    trailing: Text(index.toString()),
                                    leading: Icon(Icons.dinner_dining,
                                        color: Colors.green),
                                    title: Text(sahariHistory[index]),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Food {
  final String name;

  Food(this.name);
}
