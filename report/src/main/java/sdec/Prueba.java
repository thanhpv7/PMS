package sdec;

import java.util.ArrayList;

public class Prueba {
	/**
	 * @param args
	 */
	public static ArrayList<Poliza> getPolizas() {
		ArrayList<Poliza> polizas = new ArrayList<Poliza>();
		polizas.add(new Poliza(3737333, getVehiculos()));

		return polizas;
	}

	public static ArrayList<Vehiculo> getVehiculos() {
		ArrayList<Conductor> conductores = new ArrayList<Conductor>();
		conductores.add(new Conductor("Paco Martin", 33));
		conductores.add(new Conductor("Josefa Sanchez", 66));

		ArrayList<Vehiculo> vehiculos = new ArrayList<Vehiculo>();
		vehiculos.add(new Vehiculo("3356VY", "Honda Civic", conductores));
		vehiculos.add(new Vehiculo("8888RE", "Seat Panda", conductores));

		return vehiculos;
	}
}
