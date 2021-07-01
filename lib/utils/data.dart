import 'dart:math';


Random random = Random();
List names = [
  "Ling Waldner",
  "Gricelda Barrera",
  "Lenard Milton",
  "Bryant Marley",
  "Rosalva Sadberry",
  "Guadalupe Ratledge",
  "Brandy Gazda",
  "Kurt Toms",
  "Rosario Gathright",
  "Kim Delph",
  "Stacy Christensen",
];


List posts = List.generate(
    13,
        (index) => {
      "name": names[random.nextInt(10)],
      "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
      "time": "${random.nextInt(50)} min ago",
      "img": "assets/images/cm${random.nextInt(10)}.jpeg"
    });


