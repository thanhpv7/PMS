package vn.viettuts.json;

import org.codehaus.jackson.annotate.JsonProperty;

public class ClaimServiceJson implements java.io.Serializable {
	private static final long serialVersionUID = 1L;

	private InacbgServiceJson Inacbg;
	private BiayaServiceJson biaya;
	private String kelasRawat;
	private String noFPK;
	private String noSEP;
	private PesertaClaimServiceJson peserta;
	private String poli;
	private String status;
	private String tglPulang;
	private String tglSep;

	public InacbgServiceJson getInacbg() {
		return Inacbg;
	}

	@JsonProperty("Inacbg")
	public void setInacbg(InacbgServiceJson inacbg) {
		this.Inacbg = inacbg;
	}

	public BiayaServiceJson getBiaya() {
		return biaya;
	}

	public void setBiaya(BiayaServiceJson biaya) {
		this.biaya = biaya;
	}

	public String getKelasRawat() {
		return kelasRawat;
	}

	public void setKelasRawat(String kelasRawat) {
		this.kelasRawat = kelasRawat;
	}

	public String getNoFPK() {
		return noFPK;
	}

	public void setNoFPK(String noFPK) {
		this.noFPK = noFPK;
	}

	public String getNoSEP() {
		return noSEP;
	}

	public void setNoSEP(String noSEP) {
		this.noSEP = noSEP;
	}

	public PesertaClaimServiceJson getPeserta() {
		return peserta;
	}

	public void setPeserta(PesertaClaimServiceJson peserta) {
		this.peserta = peserta;
	}

	public String getPoli() {
		return poli;
	}

	public void setPoli(String poli) {
		this.poli = poli;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getTglPulang() {
		return tglPulang;
	}

	public void setTglPulang(String tglPulang) {
		this.tglPulang = tglPulang;
	}

	public String getTglSep() {
		return tglSep;
	}

	public void setTglSep(String tglSep) {
		this.tglSep = tglSep;
	}
}
