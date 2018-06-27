package sdec;

import java.util.ArrayList;

public class Poliza {
	private int codigo;
	private ArrayList<Vehiculo> vehiculos;

	public Poliza(int codigo, ArrayList<Vehiculo> vehiculos) {
		super();
		this.codigo = codigo;
		this.vehiculos = vehiculos;
	}

	public int getCodigo() {
		return codigo;
	}

	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}

	public ArrayList<Vehiculo> getVehiculos() {
		return vehiculos;
	}

	public void setVehiculos(ArrayList<Vehiculo> vehiculos) {
		this.vehiculos = vehiculos;
	}
}
