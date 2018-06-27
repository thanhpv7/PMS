package sdec;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

public class Test {
	
	public static void main(String[] args) {
		String source = "report1.jrxml";
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("classId", "1");
		parameters.put("className", "A1");
		
		generatePDF(source, Prueba.getVehiculos(), parameters);
	}
	
	public static void generatePDF(String source, Collection<?> items, Map<String, Object> parameters) {
		JRBeanCollectionDataSource beanColDataSource = new JRBeanCollectionDataSource(items);

		try {
			JasperReport jasperReport = JasperCompileManager.compileReport(source);

			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, beanColDataSource);
			OutputStream os = new FileOutputStream("report.pdf");
			JasperExportManager.exportReportToPdfStream(jasperPrint, os);

			os.flush();
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
