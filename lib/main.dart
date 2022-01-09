import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
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
  static final Color textColor = Color.fromARGB(255, 229, 227, 227);
  static final Color textTextColor = Color.fromARGB(255, 20, 30, 20);
  static final Color backColor = Color.fromARGB(255, 186, 171, 218);
  static final Color foodBackground = Color.fromARGB(255, 180, 170, 210);
  static final DateFormat formatter = DateFormat("EEEEE dd MMMMM");

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _currentDate = DateTime.now();
  FoodInfo foodInfo;
  bool _busy = false;

  @override
  void initState() {
    initializeDateFormatting("tr");

    super.initState();

    setState(() {
      _busy = true;
      getFood(DateTime.now());
      _busy = false;
    });
  }

  void getFood(DateTime dt) async {
    setState(() {
      foodInfo = null;
      _busy = true;
    });

    FoodInfo result;
    result = await JsonManager.getFoodListByDate(dt);

    setState(() {
      foodInfo = result;
      _busy = false;
    });
  }

  void increaseCurrentDateTime() {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: 1));
      getFood(_currentDate);
    });
  }

  void decreaseCurrentDateTime() {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: -1));
      getFood(_currentDate);
    });
  }

  bool swipedRight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          swipedRight = details.delta.dx < 0 ? false : true;
        },
        onPanEnd: (details) {
          if (swipedRight)
            decreaseCurrentDateTime();
          else
            increaseCurrentDateTime();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyHomePage.backColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 290,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image.asset("assets/food.png"),
                      datePickerWidget(),
                    ],
                  ),
                ),
                _busy ? WaitScreen() : FoodList()
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: MyHomePage.backColor,
        height: foodInfo != null && foodInfo.info.isNotEmpty ? 80 : 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            foodInfo != null && foodInfo.info.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.face),
                      SizedBox(width: 10),
                      Text(
                        foodInfo.info,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                : SizedBox(width: 0),
            Text(
              "Menü etkinlik günlerinde veya zorunlu durumlarda değişebilir.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget datePickerWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_left,
            color: Colors.black87,
          ),
          onPressed: decreaseCurrentDateTime,
        ),
        Text(
          (DateFormat("dd MMMM, EEEEE", "tr")).format(_currentDate),
          style: TextStyle(
            color: MyHomePage.textColor,
            fontFamily: "Verdana",
            fontSize: 18,
            wordSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_right,
            color: Colors.black87,
          ),
          onPressed: increaseCurrentDateTime,
        ),
      ],
    );
  }

  Widget FoodList() {
    return foodInfo != null
        ? Column(
            children: [
              foodInfo.getWidget(context, RepastType.BREAKFAST),
              foodInfo.getWidget(context, RepastType.LUNCH),
              foodInfo.getWidget(context, RepastType.DINNER),
            ],
          )
        : Text(
            "Menü mevcut değil.",
            style: TextStyle(
              fontSize: 24,
              color: MyHomePage.textTextColor,
            ),
          );

    /*
  return

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        foodInfo.info != ""
            ? foodInfo.info
            : "Menü mevcut değil.",
        style: TextStyle(
          fontSize: 24,
          color: MyHomePage.textTextColor,
        ),
      ),
    )
    : Column(
    children: [
    foodInfo.getWidget(context, RepastType.BREAKFAST),
    foodInfo.getWidget(context, RepastType.LUNCH),
    foodInfo.getWidget(context, RepastType.DINNER),
    ],
    );*/
  }
}

class WaitScreen extends StatelessWidget {
  const WaitScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPulse(
        color: Colors.white54,
      ),
    );
  }
}
