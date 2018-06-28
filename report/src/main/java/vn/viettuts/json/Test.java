package vn.viettuts.json;

import java.io.IOException;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

public class Test {
	public static void main(String[] args) throws JsonParseException, JsonMappingException, IOException {
//		ObjectMapper mapper = new ObjectMapper();
		String resultStr = "{\"metaData\":{\"code\":\"200\",\"message\":\"Sukses\"},\"response\":{\"klaim\":[{\"Inacbg\":{\"kode\":\"N-3-15-0\",\"nama\":\"DIALYSIS\"},\"biaya\":{\"byPengajuan\":\"991200\",\"bySetujui\":\"0\",\"byTarifGruper\":\"991200\",\"byTarifRS\":\"1170689\",\"byTopup\":\"0\"},\"kelasRawat\":\"3\",\"noFPK\":\"\",\"noSEP\":\"0301R00109170001280\",\"peserta\":{\"nama\":\"NUR\",\"noKartu\":\"0033681422715\",\"noMR\":\"974956\"},\"poli\":\"Hemodialisa\",\"status\":\"Proses Verifikasi\",\"tglPulang\":\"2017-09-02\",\"tglSep\":\"2017-09-02\"},{\"Inacbg\":{\"kode\":\"N-3-15-0\",\"nama\":\"DIALYSIS\"},\"biaya\":{\"byPengajuan\":\"991200\",\"bySetujui\":\"0\",\"byTarifGruper\":\"991200\",\"byTarifRS\":\"1015000\",\"byTopup\":\"0\"},\"kelasRawat\":\"3\",\"noFPK\":\"\",\"noSEP\":\"0301R00109170000094\",\"peserta\":{\"nama\":\"YUH\",\"noKartu\":\"0223416974628\",\"noMR\":\"878410\"},\"poli\":\"Hemodialisa\",\"status\":\"Proses Verifikasi\",\"tglPulang\":\"2017-09-02\",\"tglSep\":\"2017-09-02\"}]}}";
//		MonitoringClaimResultServiceJson resultServiceJson = mapper.readValue(resultStr,
//				MonitoringClaimResultServiceJson.class);
		System.out.println(resultStr);
		StringBuilder sbURL = new StringBuilder("http://viettuts.vn/java/12334444343");
		sbURL = sbURL.delete(sbURL.lastIndexOf("/") + 1, sbURL.length());
		System.out.println(sbURL);
	}
}
