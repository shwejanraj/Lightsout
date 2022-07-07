import 'package:flutter/material.dart';
import 'game/game.dart';
import 'dart:io';
// import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Covi Kill',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark
      ),
      home: const MyHomePage(title: 'Covi Kill',),
    );
  }
}

// class Screen extends StatefulWidget{
//   const Screen({Key? key}) : super(key: key);
//
//   @override
//   createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<Screen>{
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//       seconds: 5,
//       navigateAfterSeconds: const MyHomePage(title: 'Lights Out',),
//       title: const Text('Lights Out', style: TextStyle(
//           fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white
//       ),),
//       image: Image.asset('assets/images/launch.png'),
//       backgroundColor: Colors.black38,
//       styleTextUnderTheLoader: const TextStyle(),
//       onClick: () => print('Lights Out Flutter'),
//       photoSize: 100.0,
//       loaderColor: Colors.white,
//     );
//   }
// }

class MyHomePage extends StatefulWidget {

  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Widget> _lstLevels = [
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(3.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(4.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(5.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(6.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(7.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(8.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(9.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(10.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(11.toString()),), elevation: 10.0,),
    Card(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(12.toString()),), elevation: 10.0,)
  ];

  Card? _currLevel;
  int _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    _currLevel == _lstLevels.elementAt(_currIndex);

    return Scaffold(
        appBar: AppBar(title: const Text('Home'),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 25.0,),
              // Center(
              //   child: Row(
              //     children: [
              //       AnimatedSwitcher(
              //         child: _currLevel,
              //         duration: const Duration(seconds: 1),
              //       ),
              //     ],
              //   )
              // ),
              Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.navigate_before, size: 32.0,),
                          onPressed: (){
                            if(_currIndex != 0){
                              setState(() {
                                _currIndex-=1;
                              });
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            children:  [
                              const Text('Levels', style: TextStyle(fontSize: 20.0),),
                              Text(_currIndex.toString(), style: const TextStyle(fontSize: 20.0),),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.navigate_next, size: 32.0,),
                          onPressed: (){
                            if(_currIndex != _lstLevels.length-1){
                              setState(() {
                                _currIndex+=1;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  color: Colors.redAccent,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Text('Start Game', style: TextStyle(fontSize: 15.0, color: Colors.white),),),
                  onPressed: (){

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Game(dim: (_currIndex + 3),)
                    ));

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: MaterialButton(
                  color: Colors.grey,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0),
                    child: Text('Exit', style: TextStyle(fontSize: 15.0, color: Colors.white),),),
                  onPressed: (){
                    exit(0);
                  },
                ),
              )
            ],
          ),
        )
    );
  }
}
