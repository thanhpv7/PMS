package vn.viettuts.json;

public class BiayaServiceJson implements java.io.Serializable {
	private static final long serialVersionUID = 1L;

	private String byPengajuan;
	private String bySetujui;
	private String byTarifGruper;
	private String byTarifRS;
	private String byTopup;

	public String getByPengajuan() {
		return byPengajuan;
	}

	public void setByPengajuan(String byPengajuan) {
		this.byPengajuan = byPengajuan;
	}

	public String getBySetujui() {
		return bySetujui;
	}

	public void setBySetujui(String bySetujui) {
		this.bySetujui = bySetujui;
	}

	public String getByTarifGruper() {
		return byTarifGruper;
	}

	public void setByTarifGruper(String byTarifGruper) {
		this.byTarifGruper = byTarifGruper;
	}

	public String getByTarifRS() {
		return byTarifRS;
	}

	public void setByTarifRS(String byTarifRS) {
		this.byTarifRS = byTarifRS;
	}

	public String getByTopup() {
		return byTopup;
	}

	public void setByTopup(String byTopup) {
		this.byTopup = byTopup;
	}
}
