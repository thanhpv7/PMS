package vn.viettuts.json;

public class PesertaClaimServiceJson implements java.io.Serializable {
	private static final long serialVersionUID = 1L;

	private String nama;
	private String noKartu;
	private String noMR;

	public String getNama() {
		return nama;
	}

	public void setNama(String nama) {
		this.nama = nama;
	}

	public String getNoKartu() {
		return noKartu;
	}

	public void setNoKartu(String noKartu) {
		this.noKartu = noKartu;
	}

	public String getNoMR() {
		return noMR;
	}

	public void setNoMR(String noMR) {
		this.noMR = noMR;
	}
}
