import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/register_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      home: Page1(),
    ),
  );
}


class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: const Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[
              const Spacer(flex: 70),
// Group: Group 32

              SizedBox(
                width: 200.0,
                height: 85.76,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: const <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Text(
                        'LAMBER EMS',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Color(0xFF830C0C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // Image(
                    //   // ambulance
                    //   '<svg viewBox="164.31 75.24 63.37 47.76" ><path transform="translate(164.31, 75.24)" d="M 61.78959274291992 32.83634948730469 L 60.20524215698242 32.83634948730469 L 60.20524215698242 22.75160789489746 C 60.20524215698242 21.5675106048584 59.70000839233398 20.42818641662598 58.80924987792969 19.58903694152832 L 48.91764068603516 10.27048015594482 C 48.02688598632812 9.431328773498535 46.81926345825195 8.955368041992188 45.56058883666992 8.955368041992188 L 41.19306564331055 8.955368041992188 L 41.19306564331055 4.477684020996094 C 41.19306564331055 2.005007266998291 39.06475448608398 0 36.44001770019531 0 L 4.753046035766602 0 C 2.128308296203613 0 0 2.005007266998291 0 4.477684020996094 L 0 34.32891082763672 C 0 36.80158615112305 2.128308296203613 38.80659484863281 4.753046035766602 38.80659484863281 L 6.337394237518311 38.80659484863281 C 6.337394237518311 43.75028991699219 10.59577178955078 47.761962890625 15.84348678588867 47.761962890625 C 21.09120178222656 47.761962890625 25.34957695007324 43.75028991699219 25.34957695007324 38.80659484863281 L 38.02436828613281 38.80659484863281 C 38.02436828613281 43.75028991699219 42.28274536132812 47.761962890625 47.53045272827148 47.761962890625 C 52.77817153930664 47.761962890625 57.03654479980469 43.75028991699219 57.03654479980469 38.80659484863281 L 61.78959274291992 38.80659484863281 C 62.66098403930664 38.80659484863281 63.37394714355469 38.13494110107422 63.37394714355469 37.31403350830078 L 63.37394714355469 34.32891082763672 C 63.37394714355469 33.50800323486328 62.66099166870117 32.83635330200195 61.78959274291992 32.83635330200195 Z M 15.84348678588867 43.28427886962891 C 13.21874904632568 43.28427886962891 11.09043979644775 41.27927017211914 11.09043979644775 38.80659484863281 C 11.09043979644775 36.33391571044922 13.21874904632568 34.32890701293945 15.84348678588867 34.32890701293945 C 18.46822166442871 34.32890701293945 20.59653282165527 36.33391571044922 20.59653282165527 38.80659484863281 C 20.59653282165527 41.27927017211914 18.46822357177734 43.28427886962891 15.84348678588867 43.28427886962891 Z M 30.10262298583984 20.14957809448242 C 30.10262298583984 20.56086349487305 29.74526977539062 20.89585876464844 29.31044960021973 20.89585876464844 L 23.76523017883301 20.89585876464844 L 23.76523017883301 26.11982154846191 C 23.76523017883301 26.53110504150391 23.40787124633789 26.8661060333252 22.97305488586426 26.8661060333252 L 18.22001075744629 26.8661060333252 C 17.78343200683594 26.8661060333252 17.42783355712891 26.52944755554199 17.42783355712891 26.11982345581055 L 17.42783355712891 20.89585876464844 L 11.88261604309082 20.89585876464844 C 11.4460391998291 20.89585876464844 11.09044075012207 20.55920219421387 11.09044075012207 20.14957809448242 L 11.09044075012207 15.67189502716064 C 11.09044075012207 15.26061058044434 11.4478006362915 14.925612449646 11.88261604309082 14.925612449646 L 17.42783355712891 14.925612449646 L 17.42783355712891 9.70164966583252 C 17.42783355712891 9.290366172790527 17.78519439697266 8.955368995666504 18.22001075744629 8.955368995666504 L 22.97305488586426 8.955368995666504 C 23.40963172912598 8.955368995666504 23.76523017883301 9.292025566101074 23.76523017883301 9.70164966583252 L 23.76523017883301 14.925612449646 L 29.31044960021973 14.925612449646 C 29.74702453613281 14.925612449646 30.10262298583984 15.2622709274292 30.10262298583984 15.67189502716064 L 30.10262298583984 20.14957809448242 Z M 47.53046035766602 43.28427886962891 C 44.90572357177734 43.28427886962891 42.77741241455078 41.27927017211914 42.77741241455078 38.80659484863281 C 42.77741241455078 36.33391571044922 44.90571975708008 34.32890701293945 47.53046035766602 34.32890701293945 C 50.15520095825195 34.32890701293945 52.28350830078125 36.33391571044922 52.28350830078125 38.80659484863281 C 52.28350830078125 41.27927017211914 50.15520095825195 43.28427886962891 47.53046035766602 43.28427886962891 Z M 55.45219802856445 23.8809814453125 L 41.19306564331055 23.8809814453125 L 41.19306564331055 13.4330530166626 L 45.56058883666992 13.4330530166626 L 55.45219802856445 22.75160789489746 L 55.45219802856445 23.88097953796387 Z" fill="#830c0c" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    //   width: 63.37,
                    //   height: 47.76,
                    // ),
                  ],
                ),
              ),
              const Spacer(flex: 77),
              const Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'Manage and track your requests',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 20.0,
                    color: Color(0xFFA34747),
                  ),
                ),
              ),

              SizedBox(
                width: 350.0,
                height: 350.0,
                child: Image.asset('assets/images/ambulance.jpg'),
              ),
              const Spacer(flex: 56),
              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: EdgeInsets.all(25),
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute());
                      },
                      child: const Text('Sign In'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFFA34747)),
                      ),
                    ),
                  )),
              const Spacer(flex: 20),
              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: EdgeInsets.all(25),
                  child: Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoutes());
                        },
                        child: const Text(
                          'Verify your Email',
                          style: TextStyle(
                            color: Color(0xFFA34747),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 1.0,
                            color: Color(0xFFA34747),
                            style: BorderStyle.solid,
                          ),
                        )),
                  )),
              const Spacer(flex: 59),
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _createRoutes() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page3(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignIn(),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Register(),
    );
  }
}
