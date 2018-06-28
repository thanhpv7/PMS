package vn.viettuts.json;

import java.util.ArrayList;
import java.util.List;

public class MonitoringClaimResponseServiceJson implements java.io.Serializable {
	private static final long serialVersionUID = 1L;

	private List<ClaimServiceJson> klaim;

	public List<ClaimServiceJson> getKlaim() {
		return klaim;
	}

	public void setKlaim(List<ClaimServiceJson> klaim) {
		this.klaim = klaim;
	}
}
