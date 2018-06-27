package sdec;

import java.util.ArrayList;

public class Vehiculo {
	private String matricula;
	private String modelo;

	private ArrayList<Conductor> conductores;

	public Vehiculo(String matricula, String modelo, ArrayList<Conductor> conductores) {
		super();
		this.matricula = matricula;
		this.modelo = modelo;
		this.conductores = conductores;
	}

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public String getModelo() {
		return modelo;
	}

	public void setModelo(String modelo) {
		this.modelo = modelo;
	}

	public ArrayList<Conductor> getConductores() {
		return conductores;
	}

	public void setConductores(ArrayList<Conductor> conductores) {
		this.conductores = conductores;
	}
}
