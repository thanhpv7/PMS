package vn.viettuts.json;

public class MetadataServiceJson implements java.io.Serializable {

	private static final long serialVersionUID = 1L;
	
	private String code;
	private String message;
	private String error_no;
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getError_no() {
		return error_no;
	}
	public void setError_no(String error_no) {
		this.error_no = error_no;
	}
	
}
