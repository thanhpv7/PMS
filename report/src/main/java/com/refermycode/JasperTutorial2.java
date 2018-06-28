package com.refermycode;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

public class JasperTutorial2 {
	public static List addEmployeeInfo() {
		List employeeList = new ArrayList();

		Employee employee = new Employee();
		employee.setEmployeeNumber("1001");
		employee.setEmployeeName("Ajit");
		employee.setEmployeeAddress("Latur");
		employee.setEmployeeSalary("40,000");
		employeeList.add(employee);

		employee = new Employee();
		employee.setEmployeeNumber("1002");
		employee.setEmployeeName("Amit");
		employee.setEmployeeAddress("Aurangabad");
		employee.setEmployeeSalary("50,000");
		employeeList.add(employee);

		employee = new Employee();
		employee.setEmployeeNumber("1004");
		employee.setEmployeeName("Aniket");
		employee.setEmployeeAddress("Nashik");
		employee.setEmployeeSalary("50,000");
		employeeList.add(employee);

		employee = new Employee();
		employee.setEmployeeNumber("1004");
		employee.setEmployeeName("Anup");
		employee.setEmployeeAddress("Pune");
		employee.setEmployeeSalary("60,000");
		employeeList.add(employee);

		employee = new Employee();
		employee.setEmployeeNumber("1005");
		employee.setEmployeeName("Kuldeep");
		employee.setEmployeeAddress("Hyderabad");
		employee.setEmployeeSalary("60,000");
		employeeList.add(employee);

		employee = new Employee();
		employee.setEmployeeNumber("1006");
		employee.setEmployeeName("Tushar");
		employee.setEmployeeAddress("Shirdi");
		employee.setEmployeeSalary("50,000");
		employeeList.add(employee);

		return employeeList;
	}

	public static void main(String[] args) throws FileNotFoundException {
		try {
			InputStream inputStream = new FileInputStream("report2.jrxml");
			JasperDesign jasperDesign = JRXmlLoader.load(inputStream);
			JasperReport jasperReport = JasperCompileManager.compileReport(jasperDesign);

			HashMap parameters = new HashMap();
			List employeeList = addEmployeeInfo();
			JRBeanCollectionDataSource beanColDataSource = new JRBeanCollectionDataSource(employeeList);
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, beanColDataSource);
			JasperExportManager.exportReportToPdfFile(jasperPrint, "test_jasper.pdf");
		} catch (JRException ex) {
			Logger.getLogger(JasperTutorial2.class.getName()).log(Level.SEVERE, null, ex);
		}
	}
}
