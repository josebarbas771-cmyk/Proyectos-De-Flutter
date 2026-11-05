class Alumno {
  final String nombre;
  final String apellido;
  final int edad;
  final List<double> notas;

  Alumno({
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.notas,
  });

  // Promedio de las 3 notas
  double calcularPromedio() {
    double suma = notas.reduce((a, b) => a + b);
    return suma / notas.length;
  }

  // 'Aprobado', 'Recuperatorio' o 'Desaprobado'
  String estadoFinal() {
    double promedio = calcularPromedio();
    if (promedio >= 6) {
      return 'Aprobado';
    } else if (promedio >= 4) {
      return 'Recuperatorio';
    } else {
      return 'Desaprobado';
    }
  }

  @override
  String toString() {
    return '$nombre $apellido — ${estadoFinal()}';
  }
}

void main() {
  // Lista de 5 alumnos distintos
  List<Alumno> alumnos = [
    Alumno(nombre: 'Sofía', apellido: 'Pérez', edad: 17, notas: [9.0, 8.0, 10.0]),
    Alumno(nombre: 'Lucas', apellido: 'Gómez', edad: 16, notas: [4.0, 5.0, 3.0]),
    Alumno(nombre: 'Ana', apellido: 'Torres', edad: 18, notas: [2.0, 3.0, 4.0]),
    Alumno(nombre: 'Martín', apellido: 'Díaz', edad: 17, notas: [7.0, 6.0, 8.0]),
    Alumno(nombre: 'Camila', apellido: 'Ruiz', edad: 16, notas: [5.0, 6.0, 7.0]),
  ];

  // Mostrar el estado de cada uno
  print('--- Estado de cada alumno ---');
  for (Alumno alumno in alumnos) {
    print('$alumno — Promedio: ${alumno.calcularPromedio()}');
  }
  Alumno mejor = alumnos.first;
  for (Alumno alumno in alumnos) {
    if (alumno.calcularPromedio() > mejor.calcularPromedio()) {
      mejor = alumno;
    }
  }
  print('--- Mejor promedio ---');
  print('${mejor.nombre} ${mejor.apellido}: ${mejor.calcularPromedio()}');

  // Contar aprobados, recuperatorios y desaprobados
  int aprobados = 0;
  int recuperatorios = 0;
  int desaprobados = 0;
  for (Alumno alumno in alumnos) {
    if (alumno.estadoFinal() == 'Aprobado') {
      aprobados++;
    } else if (alumno.estadoFinal() == 'Recuperatorio') {
      recuperatorios++;
    } else {
      desaprobados++;
    }
  }
  print('--- Conteo ---');
  print('Aprobaron: $aprobados');
  print('Recuperatorio: $recuperatorios');
  print('Desaprobaron: $desaprobados');

  // EXTRA: ordenar de mayor a menor promedio con list.sort()
  alumnos.sort((a, b) {
    if (a.calcularPromedio() < b.calcularPromedio()) return 1;
    if (a.calcularPromedio() > b.calcularPromedio()) return -1;
    return 0;
  });
  print('--- Ordenados de mayor a menor ---');
  for (Alumno alumno in alumnos) {
    print('$alumno — ${alumno.calcularPromedio()}');
  }
}
