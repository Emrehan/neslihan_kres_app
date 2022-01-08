import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:neslihan_kres/Repast.dart';

import 'jsonManager.dart';
import 'FoodInfo.dart';
import 'notificationManager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neslihan Kreş',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Harikalar Diyarı Neslihan Kreş'),
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
  DateTime _selectedValue;
  DatePickerController dpc = new DatePickerController();

  FoodInfo foodInfo = FoodInfo.valid(false);
  bool _busy = false;

  Timer timer;

  void getFood(DateTime dt) async {
    setState(() {
      foodInfo = FoodInfo.valid(false);
      _busy = true;
    });

    FoodInfo result;
    result = await JsonManager.getFoodListByDate(dt);

    setState(() {
      foodInfo = result;
      _busy = false;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _busy = true;
      getFood(DateTime.now());
      _busy = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.home_outlined),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.title,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: DatePicker(
                      DateTime.now().add(Duration(days: -10)),
                      initialSelectedDate: DateTime.now(),
                      controller: dpc,
                      selectionColor: Colors.blueAccent.withAlpha(100),
                      selectedTextColor: Colors.blueAccent,
                      onDateChange: (date) {
                        // New date selected
                        setState(() {
                          _selectedValue = date;
                          dpc.animateToDate((_selectedValue ?? DateTime.now())
                              .add(Duration(days: -2)));

                          getFood(date);
                        });
                      },
                      daysCount: 40,
                      locale: "tr_TR",
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.today),
                      onPressed: () {
                        setState(() {
                          _selectedValue = DateTime.now();
                          dpc.animateToDate(
                              (_selectedValue).add(Duration(days: -2)));
                        });
                      },
                    ),
                    width: MediaQuery.of(context).size.width * 0.2,
                  )
                ],
              ),
              _busy
                  ? Center(
                      child: SpinKitPulse(
                        color: Colors.white54,
                      ),
                    )
                  : !foodInfo.valid || foodInfo.info != ""
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            foodInfo.info != ""
                                ? foodInfo.info
                                : "Menü mevcut değil.",
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.blueAccent,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            foodInfo.getWidget(RepastType.BREAKFAST),
                            foodInfo.getWidget(RepastType.LUNCH),
                            foodInfo.getWidget(RepastType.DINNER),
                          ],
                        ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        child: Text(
          "Menü etkinlik güncelerinde veya zorunlu durumlarda değişebilir.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black38,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
