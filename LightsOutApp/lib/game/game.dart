import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import '../countdown_clock/clock_painter.dart';

class Game extends StatefulWidget{
  final int dim;
  const Game({required this.dim});
  @override
  createState() => _GameState(dim: dim);
}

class _GameState extends State<Game>{

  _GameState({required this.dim});

  final List<List<bool>> _states = [];
  // late final AudioCache _audioCache;
  final playerS = AudioCache();

  int dim;
  // final bool _showSolution = false;
  bool _gameOver = false;
  bool _haswon = false;
  int _numSteps = 0;
  int _targetmoves = 21;
  int _hours =0;
  int _mins =0;
  int _secs =0;

  @override
  void initState() {
    super.initState();
    _targetmoves = _targetmoves + dim;

    for(int i = 0; i < dim; i++){
      _states.add([]);

      for(int j = 0; j < dim; j++){
        _states[i].add(false);
      }
    }
    for(int i = 0; i < _states.length; i++){
      for(int j = 0; j < _states[i].length; j++){
        _states[i][j] = Random().nextBool();
      }
    }
    // randomize();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        bool willLeave = false;
        // show the confirm dialog
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), //this right here
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade900,
                    border: Border.all(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2),
                          offset: const Offset(1.1, 4.0),
                          blurRadius: 8.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Are you sure want to leave?', style: TextStyle(fontSize: 15),),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              // width: 50.0,
                              child: TextButton(
                                child: const Text('Yes'),
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.lightGreen,
                                  onSurface: Colors.grey,
                                ),
                                onPressed: () {
                                  willLeave = true;
                                  Navigator.of(context).pop();
                                },
                              )
                            ),
                            const SizedBox(width: 25,),
                            SizedBox(
                                // width: 100.0,
                                child: TextButton(
                                  child: const Text('No'),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.red,
                                    onSurface: Colors.grey,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
        return willLeave;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Game'),
          ),
          body: _gameOver ? Center(
            child: _haswon ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Game Finished',
                    style: TextStyle(
                        fontSize: 20.0, color: Colors.white
                    ),
                  ),
                  const _BlinkingText( stat: 'You Won',),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Text('Finished in $_numSteps steps', style: const TextStyle(fontSize: 15.0),),
                        Row(
                          children: [
                            Text('Time Taken $_hours : $_mins : $_secs', style: const TextStyle(fontSize: 15.0),),
                            const Icon(Icons.access_alarm),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: MaterialButton(
                      elevation: 20.0,
                      color: Colors.red,
                      child: const Text('Next Level', style: TextStyle(fontSize: 15.0),),
                      onPressed:() {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Game(dim: (dim+1))));
                      },

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: MaterialButton(
                      elevation: 20.0,
                      color: Colors.grey,
                      child: const Text('Exit', style: TextStyle(fontSize: 15.0),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Game Finished',
                  style: TextStyle(
                      fontSize: 20.0, color: Colors.white
                  ),
                ),
                const _BlinkingText( stat: 'You Lost',),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      Text('Tried in $_numSteps steps', style: const TextStyle(fontSize: 18.0),),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_alarm),
                          const SizedBox(width: 4,),
                          Text('$_hours : $_mins : $_secs', style: const TextStyle(fontSize: 15.0),),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: MaterialButton(
                    elevation: 20.0,
                    color: Colors.red,
                    child: const Text('Try Again', style: TextStyle(fontSize: 15.0),),
                    onPressed: _reset,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: MaterialButton(
                    elevation: 20.0,
                    color: Colors.grey,
                    child: const Text('Exit', style: TextStyle(fontSize: 15.0),),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade900,
                  border: Border.all(
                    color: Colors.cyan,
                    width: 2,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.cyan.shade300.withOpacity(0.5),
                        spreadRadius: -20,
                        offset: const Offset(0, 25),
                        blurRadius: 3
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      // color: Colors.black,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TweenAnimationBuilder<Duration>(
                        duration: const Duration(hours: 24),
                        tween: Tween(begin: Duration.zero, end: const Duration(hours: 24), ),
                        onEnd: (){
                          setState(() {
                            _gameOver = true;
                          });
                          // print("Game stat:$_gameOver");
                        },
                        builder: (BuildContext context, Duration value, Widget? child){
                          _hours = value.inHours;
                          _mins = value.inMinutes;
                          _secs = value.inSeconds%60;

                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                height: 90.5,
                                width: 90.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black
                                            .withOpacity(1),
                                        offset: const Offset(1.1, 1.1),
                                        blurRadius: 12.0),
                                  ],
                                ),
                                child: LiquidCircularProgressIndicator(
                                  value: _mins*60/(24*60*60), // _mins*60/(24*60*60) => for 24 hours
                                  valueColor: const AlwaysStoppedAnimation(Colors.black,),
                                  backgroundColor: Colors.grey,
                                  borderColor: Colors.red.shade700,
                                  borderWidth: 0.5,
                                  direction: Axis.vertical,
                                  center: Text(
                                    _hours.toString().padLeft(2, '0') + ' : '+(_mins%60).toString().padLeft(2, '0') + ' : '+_secs.toString().padLeft(2, '0'),
                                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                height: 150,
                                width: 150,
                                // color: Colors.white,
                                child: CustomPaint(
                                  size: const Size(250, 250),
                                  painter: ClockPainter(
                                    second: _secs,
                                    minute: _mins,
                                    hour: _hours,
                                  ),
                                ),
                              ),

                            ],
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        const Text('Target', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 3,),
                        Text('$_targetmoves', style: const TextStyle(fontSize: 15.0),),
                        const SizedBox(height: 5,),
                        const Text('Current', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 3,),
                        Text('$_numSteps', style: const TextStyle(fontSize: 15.0),),
                      ],
                    ),
                    const Spacer()
                  ],
                ),
              ),
              const Spacer(),
              // const SizedBox(height: 5,),
              AspectRatio(
                aspectRatio: 1/1,
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                    //TODO : Set Nice Background for the board
                    // color: Colors.blueGrey
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: dim
                    ),
                    itemCount: (dim * dim),
                    itemBuilder: _buildGridItems,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Checkbox(
                    //   value: _showSolution,
                    //   onChanged: (bool newValue){
                    //     return showDialog(
                    //         context: context,
                    //         barrierDismissible: false,
                    //         builder: (context) => AlertDialog(
                    //           content: Text('Feature not Implemented Yet\nComing Soon'),
                    //           actions: <Widget>[CloseButton()],
                    //         )
                    //     );
                    //   },
                    // ),
                    // ! _showSolution ? const Text('Show Solution') : const Text('Hide Solution'),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: MaterialButton(
                        color: Colors.red,
                        child: const Text('Shuffle'),
                        onPressed: randomize,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: MaterialButton(
                        color: Colors.grey,
                        child: const Text('Restart'),
                        onPressed:() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => super.widget));
                        },
                      ),
                    )
                  ],
                ),
              ),
              const Spacer()
            ],
          )
      ),
    );
  }

  Widget _buildGridItems(BuildContext context, int index){

    int stateLength = _states.length;
    int x, y = 0;
    print(index);

    x = (index / stateLength).floor();
    y = (index % stateLength);

    return GestureDetector(

      onTap: (){
        playerS.play('audio/TapSound.mp3');
        HapticFeedback.vibrate();
        setState(() {
          _tappedItems(x, y);
        });
      },

      child: GridTile(
        child: Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: (_states[x][y]) ? Colors.lightGreenAccent : Colors.cyan, width: 0.5),
            color: (_states[x][y]) ? Colors.lightGreenAccent : Colors.cyan,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: (_states[x][y]) ? Colors.lightGreenAccent : Colors.black,
                borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
      ),

    );
  }

  void _tappedItems(int x, int y){
    _states[x][y] = !_states[x][y];

    if(x > 0){
      _states[x-1][y] = !_states[x-1][y];
    }
    if(x < _states.length-1){
      _states[x+1][y] = !_states[x+1][y];
    }
    if(y > 0){
      _states[x][y-1] = !_states[x][y-1];
    }
    if(y < _states.length-1){
      _states[x][y+1] = !_states[x][y+1];
    }
    // For easy testing
    // if(x > 0){
    //   _states[x-1][y] = false;
    // }
    // if(x < _states.length-1){
    //   _states[x+1][y] = false;
    // }
    // if(y > 0){
    //   _states[x][y-1] = false;
    // }
    // if(y < _states.length-1){
    //   _states[x][y+1] = false;
    // }
    _numSteps++;
    _gameOver = _checkFinished();

    print("Game stat:$_gameOver");
  }

  void randomize(){
    setState(() {
      for(int i = 0; i < _states.length; i++){
        for(int j = 0; j < _states[i].length; j++){
          _states[i][j] = Random().nextBool();
        }
      }
    });
  }

  void _reset(){
    randomize();
    setState(() {
      _numSteps = 0;
      _gameOver = false;
      _hours =0;
      _mins = 0;
      _secs = 0;
    });
  }

  bool _checkFinished(){
    print("$_hours : $_mins : $_secs");
    if(_gameOver){
      _haswon = true;

      return true;
    }
    if ((_states.any((element) => element.contains(true)))){
      _haswon = false;
      return false;
    }

    _haswon = true;
    return true;
  }

}

class _BlinkingText extends StatefulWidget{
  final String stat;

  const _BlinkingText({required this.stat});
  @override
  createState() => _BlinkingTextWidget(stat: stat);
}

class _BlinkingTextWidget extends State<_BlinkingText> with TickerProviderStateMixin{

  late AnimationController _animationController;

  _BlinkingTextWidget({required this.stat});
  String stat;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeTransition(
          opacity: _animationController,
          child:Text(
            stat,
            style: TextStyle(
                fontSize: 34.0, color: stat == "You Won" ? Colors.lightGreenAccent : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }
}