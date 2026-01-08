import 'package:doit_list/StyleClasses/main_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class UltraSimpleCalendar extends StatefulWidget {
  const UltraSimpleCalendar({super.key});

  @override
  State<UltraSimpleCalendar> createState() => _UltraSimpleCalendarState();
}

class _UltraSimpleCalendarState extends State<UltraSimpleCalendar> {
  DateTime month = DateTime.now();

  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: MainColors.backgroundColor,
          appBar: AppBar(title: Text("Menu", style: TextStyle(color: MainColors.titleTextColor, fontSize: 54)), centerTitle: true, backgroundColor: MainColors.buttonBackgroundColor_beta,),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainColors.buttonBackgroundColor_beta,
                ),
                child: Text("ON MAIN PAGE", style: TextStyle(color: MainColors.titleTextColor),),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Text("MAIN MENU", style: TextStyle(color: MainColors.textColor),),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = DateTime(month.year, month.month + 1, 0).day;
    final weekDays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];

    return Scaffold(
      backgroundColor: MainColors.backgroundColor,
      appBar: AppBar(
        title: Text('${DateTime.now().day.toString().padLeft(2, "0")}.${month.month.toString().padLeft(2, "0")}.${month.year} ${weekDays[DateTime.now().weekday - 1]}', style: TextStyle(color: MainColors.titleTextColor), textAlign: TextAlign.justify,),
        backgroundColor: MainColors.appBarColor_alpha,
        actions: [
          IconButton(
            onPressed: () => setState(() => month = DateTime(month.year, month.month - 1, 1)),
            color: MainColors.buttonBackgroundColor_beta,
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: () => setState(() => month = DateTime(month.year, month.month + 1, 1)),
            color: MainColors.buttonBackgroundColor_beta,
            icon: const Icon(Icons.arrow_forward),
          ),
          IconButton(onPressed: _menuOpen,color: MainColors.buttonBackgroundColor_beta, icon: Icon(Icons.menu_outlined))
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(1),
        crossAxisCount: 3,
        children: [
          for (int i = 1; i <= days; i++)
            SizedBox(
              child: Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: i == DateTime.now().day && month.month == DateTime.now().month && month.year == DateTime.now().year
                        ? MainColors.buttonBackgroundColor_alpha.withAlpha(150)
                        : ([weekDays[5], weekDays[6]]).contains(weekDays[DateTime(month.year, month.month, i).weekday - 1]) ? Colors.pinkAccent.withAlpha(80) : MainColors.buttonBackgroundColor_alpha.withAlpha(80),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                      children: [Container(
                          decoration: BoxDecoration(
                              color: ([weekDays[5], weekDays[6]]).contains(weekDays[DateTime(month.year, month.month, i).weekday - 1]) ? Colors.pinkAccent.withAlpha(80) : MainColors.buttonBackgroundColor_alpha,
                              shape: BoxShape.rectangle,
                          ),
                          child: Row(
                              children: [
                                IconButton(onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/todo");
                                },
                                    icon: Text(
                                        i.toString(), style: TextStyle(
                                        color: MainColors.textColor,
                                        fontSize: 18)
                                    )
                                ),
                                Padding(padding: EdgeInsets.only(left: 40)),
                                Text("${weekDays[DateTime(month.year, month.month, i).weekday - 1]}", style: TextStyle(
                                      color: MainColors.textColor,
                                      fontSize: 18)
                                  )
                               ]
                          )
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Container(
                              decoration: BoxDecoration(
                                color: ([weekDays[5], weekDays[6]]).contains(weekDays[DateTime(month.year, month.month, i).weekday - 1]) ? Colors.pinkAccent.withAlpha(60) : null,
                                border: Border.all(
                                  width: 1,
                                  color: MainColors.buttonBackgroundColor_beta
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: 130,
                              padding: EdgeInsets.only(top: 15),
                              child: Column(
                                children: [
                                  for (int i = 1; i <= 4; i++)
                                    Text("Title ${i}", style: TextStyle(fontSize: 12))
                                ],
                              )
                            ),
                          ],
                        )
                      ]
                  )
              ),
            ),
        ],
      ),
    );
  }
}