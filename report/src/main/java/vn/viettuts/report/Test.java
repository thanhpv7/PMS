package vn.viettuts.report;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import sdec.Prueba;

public class Test {
	public static void main(String[] args) {
		String source = "ClaimReport.jrxml";
		Map<String, Object> parameters = new HashMap<String, Object>();

		generatePDF(source, Prueba.getVehiculos(), parameters);
	}

	public static void generatePDF(String source, Collection<?> items,
	        Map<String, Object> parameters) {
		JRBeanCollectionDataSource beanColDataSource = new JRBeanCollectionDataSource(items);
		parameters.put("SUB_LIST", items);
		try {
			JasperReport jasperReport = JasperCompileManager.compileReport(source);

			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters,
			        beanColDataSource);
			OutputStream os = new FileOutputStream("report.pdf");
			JasperExportManager.exportReportToPdfStream(jasperPrint, os);

			os.flush();
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static ArrayList<Student> generateCollection() {
		ArrayList<Student> arrlist = new ArrayList<Student>();
		arrlist.add(new Student("A", "20"));
		arrlist.add(new Student("B", "20"));
		arrlist.add(new Student("C", "20"));
		return arrlist;
	}
}
