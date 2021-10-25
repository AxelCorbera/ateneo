import 'package:ateneo/constants/theme_data.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.menuBackgroundColor,
      ),
      drawer: Drawer(),
      body: Row(
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 64,
                    minHeight: 64,
                    maxWidth: 64,
                    maxHeight: 64,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 7,),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColors.minHandStatColor,
                  ),
                  child: Form(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(),
                  )),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: GradientTemplate
                                    .gradientTemplate[index].colors,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              // boxShadow: BoxShadow(
                              //   color: gradientColor.last.withOpacity(0.4),
                              //   blurRadius: 8,
                              //   spreadRadius: 2,
                              //   offset: Offset(4, 4),
                              // ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            constraints: BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                              maxWidth: 32,
                                              maxHeight: 32,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              size: 30,
                                              color: Theme.of(context).secondaryHeaderColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '#nombre$index',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      onChanged: (bool value) {},
                                      value: true,
                                      activeColor: Colors.white,
                                    ),
                                  ],
                                ),
                                Text(
                                  'textoooooooooooooooooooooooooooooo$index,',

                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
