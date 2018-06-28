package vn.viettuts.json;

public class MonitoringClaimResultServiceJson implements java.io.Serializable {
	private static final long serialVersionUID = 1L;

	private MetadataServiceJson metaData;
	private MonitoringClaimResponseServiceJson response;

	public MetadataServiceJson getMetaData() {
		return metaData;
	}

	public void setMetaData(MetadataServiceJson metaData) {
		this.metaData = metaData;
	}

	public MonitoringClaimResponseServiceJson getResponse() {
		return response;
	}

	public void setResponse(MonitoringClaimResponseServiceJson response) {
		this.response = response;
	}
}
